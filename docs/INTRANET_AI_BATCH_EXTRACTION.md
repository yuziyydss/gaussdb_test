# 内网 AI 批量 Doc2Spec 运行手册

## 1. 结论与边界

产品文档不需要离开公司内网。需要带进公司的只有本项目、Python 依赖和抽取协议；原文在内网中被拆成章节文件，由公司可用的 AI 一次处理一个任务，结果写成 Factor Package V1，再由本地确定性程序做严格加载、SQL 生成和静态覆盖审计。

这套方案刻意不集成任何具体 AI API：

- 可以使用公司内部大模型平台、IDE Agent、命令行 Agent 或人工辅助；
- 项目不保存 Token，不发网络请求，不要求 OpenAI、Claude 或其他特定 SDK；
- AI 只负责“把自然语言文档翻译为候选规格”；是否合格由代码门禁判定；
- 当前闭环止于静态 SQL 生成，不连接数据库，不把 planned scenario 误报为已验证。

5800 页不等于 5800 页都应生成 SQL。SQL 命令章节适合进入 Factor Package V1；数据类型、函数、操作符、GUC、系统表、安装运维等内容需要先进入独立目录清单，其中部分应成为共享 matrix、环境能力或查询 oracle，而不是强行建立一个 SQL factor。第一阶段只批量处理 SQL 命令章节。

## 2. 总体流水线

```text
内网 PDF/HTML
    │ 本地、确定性拆章；保留标题、行号和版本
    ▼
intranet_corpus/<variant>/<category>/<section>.txt
    │ inventory：SHA-256、行数、factor_id、输出目录
    ▼
work/doc2spec/queue.json
    │ claim：一个 worker 原子认领一个章节
    ▼
work/doc2spec/tasks/<task_id>.md
    │ 任意内网 AI；一次只改一个 OUTPUT_DIR
    ▼
specs/<category>/<factor_id>/  (Factor Package V1)
    │ verify：严格加载 → 静态 SQL 生成 → 覆盖审计
    ▼
static_complete / needs_review
```

这里存在三个不同的覆盖概念，不能混写：

1. **文档账面覆盖**：每一行原文都进入 source unit 或逐行说明为什么忽略。
2. **静态生成覆盖**：值、规则、manifest、documented feature 与所有可行 pair 都被覆盖。
3. **数据库行为覆盖**：fixture 实际执行、SQLSTATE、生命周期、权限、元数据和行为 oracle 已验证。

`static_complete` 只代表前两项通过。第三项要等项目进入数据库执行阶段后单独闭环。

## 3. 带进公司的内容

建议将代码仓库以压缩包或公司允许的代码传输方式带入内网，至少包含：

```text
core/
scripts/
specs/
tests/
docs/
prompts/
requirements.txt
INTRANET_AI_INSTRUCTIONS.md
```

在外网机器上不要预填真实文档。`intranet_corpus/*` 和 `work/doc2spec/` 已加入 `.gitignore`，实际原文、队列、任务文件和 AI 临时输出都只留在内网工作区。

内网 Python 环境至少需要安装 `requirements.txt`。如果公司禁止在线安装，应提前按公司操作系统和 Python 版本准备离线 wheel 仓库；模型本身由公司 AI 环境提供，本项目不负责下载。

## 4. 先把文档变成“可对账语料”

### 4.1 不要直接把整本 PDF 交给 AI

整本输入会同时造成上下文截断、章节边界混淆、重复命令覆盖和无法断点恢复。先在内网本地把 PDF/HTML 转成 UTF-8 章节文本。转换工具可按公司已有能力选择，但输出必须满足同一个契约：

- 一个文件对应一个可独立抽取和验收的文档章节；
- 文件包含章节标题、功能描述、注意事项、完整语法、参数说明、示例及该章脚注；
- 表格不能只留下图片，至少转成能保持行列含义的文本或 Markdown 表格；
- 代码块中的换行和符号不能丢失；
- 页眉、页脚可清理，但清理规则需要固定；
- 转换完成后不再随意重排换行，因为 source ledger 使用稳定行号；
- 同一文档版本的原文不可边抽取边覆盖更新。版本变化必须改变 SHA-256 并重新审计。

目录示例：

```text
intranet_corpus/
  general/ddl/create_view.txt
  general/ddl/create_index.txt
  general/ddl/alter_table.txt
  general/dml/select.txt
  general/dml/insert.txt
  m_compat/ddl/create_view.txt
  m_compat/dml/select.txt
```

`general` 与 `m_compat` 中即使章节同名，也必须成为两个任务和两个 factor ID。不能用一个通用 SELECT 因子混合不同兼容模式语法。

### 4.2 建立总目录账本

PDF 目录页只能作为任务库存，不能作为产品事实。建议在内网另外保存一份文档总目录，至少记录：文档版本、章节层级、起止页、variant、category、是否属于第一阶段、对应语料路径。随后用实际语料文件与总目录取差集，发现“目录里有、语料里没有”的章节。

当前 `inventory` 管理已经切出的语料；它不宣称自动理解任意 PDF 目录。这样可以避免目录解析错误被误报成抽取完成。

## 5. 初始化与日常命令

### 5.1 创建或合并队列

```bash
python3 scripts/manage_extraction_queue.py inventory \
  --corpus-dir intranet_corpus
```

默认队列是 `work/doc2spec/queue.json`。重复执行不会丢失未变化任务的状态：

- 路径与 SHA-256 都没变化：保留状态、认领人、尝试次数和门禁结果；
- 路径相同但 SHA-256 变化：自动重置为 `pending`；
- 原文件消失：保留任务记录并标记 `blocked`；
- 出现重复 `factor_id`：初始化失败，必须先修复 variant/category/文件名。

查看进度：

```bash
python3 scripts/manage_extraction_queue.py summary
python3 scripts/manage_extraction_queue.py list --status needs_review
python3 scripts/manage_extraction_queue.py list --variant m_compat
```

### 5.2 认领任务

```bash
python3 scripts/manage_extraction_queue.py claim \
  --worker company-ai-01 \
  --variant general \
  --category ddl \
  --render
```

认领在文件锁中完成，多个 worker 不会正常认领到同一项。输出 JSON 包含 `rendered_task_path`，把这个 Markdown 文件交给 AI 即可。若 AI 无法直接读取本地 `SOURCE_PATH`，可加 `--embed-source`；这只会把原文复制进内网的本地任务文件，不会联网。

### 5.3 AI 生成后登记状态

```bash
python3 scripts/manage_extraction_queue.py update \
  --task-id doc2spec_general_ddl_create_view \
  --status generated \
  --message "V1 package 已生成，等待静态门禁"
```

遇到文档缺页、乱码、表格丢失或版本冲突时使用 `blocked`；模型不能表达或需要人判断时使用 `needs_review`；工具或 AI 异常可以标记 `failed`，修复后回到 `pending` 或 `in_progress`。不允许人工把任务直接标记为 `static_complete`。

### 5.4 执行静态门禁

```bash
python3 scripts/manage_extraction_queue.py verify \
  --task-id doc2spec_general_ddl_create_view
```

门禁顺序固定：

1. 任务信封对账：factor/source ledger 的 factor ID、SHA-256 和行数必须与队列原文一致，防止旧规格冒充新结果；
2. `lint_factor_packages_v1.py`：严格 Schema、ID、引用、约束和 source ledger；
3. `generate_factor_package_sql.py`：约束感知组合、100% 可行 pair、唯一 case_id、SQL 静态结构；
4. `audit_factor_coverage_v1.py --fail-on-gaps`：source unit 原子性、值域、规则、manifest、feature 与 scenario 分类。

任务信封对账和三项程序门禁都成功后，队列写入 `static_complete`。命令输出和返回码也保存在任务的 `checks` 中，方便后续审计。

## 6. 队列状态机

| 状态 | 含义 | 谁写入 |
|---|---|---|
| `pending` | 已登记，尚未处理 | inventory/人工恢复 |
| `in_progress` | 已被一个 worker 认领 | claim |
| `generated` | AI 已写出候选 V1 package | AI/操作者 |
| `needs_review` | 静态门禁或事实判断需要复核 | verify/AI/人工 |
| `blocked` | 缺原文、版本冲突或外部依赖阻塞 | inventory/AI/人工 |
| `failed` | 本次处理发生可重试错误 | AI/人工 |
| `static_complete` | 任务信封对账及三道静态门禁全部通过 | 只能由 verify 写入 |

队列采用原子替换写文件，并用 POSIX 文件锁保护认领和状态更新，适用于公司常见的 Linux/macOS 环境。不要把同一个工作目录放在不支持可靠文件锁的同步盘上并行运行。

## 7. AI 必须遵守的抽取纪律

任务模板已经写入完整规则，核心约束如下：

- 一次只处理一个章节，只修改一个 `OUTPUT_DIR`；
- 先做 source ledger，再写 factor/syntax/manifest；
- 一条独立事实对应一个原子 source unit，不能用超长段落刷“100%”；
- 原文明确事实、合理推断、待验证问题和示例必须分开；
- syntax 只描述结构，factor 描述事实和值域，matrix 描述能力 profile，manifest 选择值和覆盖策略；
- fixture 描述对象能力和生命周期，scenario 描述多步骤行为；
- 负向用例必须有目标错误 oracle，不能接受 fixture 或任意语法错误；
- 不为了当前任务通过而修改 core、Web、其他 factor package 或降低门禁；
- V1 无法表达时报告模型缺口，不私自扩展全局架构。

这能把 AI 的自由度限制在“文档理解和候选建模”，把可机械验证的部分交还给程序。

## 8. 推荐批量节奏

不要从 5 个样例直接跳到全部 5800 页。建议分四批：

### 批次 A：10 个代表性 SQL 章节

在现有 CREATE VIEW、SELECT、INSERT、CREATE INDEX、ALTER TABLE 基础上，再选择 UPDATE、DELETE、MERGE、CREATE TABLE、一个权限/事务限制较多的命令。目标是发现 V1 表达能力缺口，而不是追求数量。

验收后固定：语料转换规则、任务粒度、ID 命名、open question 处理和门禁错误分类。

### 批次 B：一个完整 SQL 子目录

例如全部 DML。统计平均章节行数、AI 重试率、needs_review 比例、单任务耗时和门禁失败原因。若 `needs_review` 持续很高，应修模型或提示词，不要扩大并发。

### 批次 C：通用 SQL 全量

按 DDL/DML/DCL 分组推进。并发 worker 可以认领不同任务，但每次只提交一个完整 package，且定期运行全库 lint，防止全局 ID 与共享引用漂移。

### 批次 D：兼容模式与非 SQL 参考

先隔离 M/B/其他兼容模式，再设计数据类型、函数、操作符、GUC、系统目录的专用 Schema。不要直接复用 SQL command factor 模型硬套这些章节。

## 9. 人工复核清单

静态工具无法替代以下判断，必须留给人或更高质量的模型复核：

- OCR 是否把关键字、上下标、表格列或代码符号识别错；
- 文档内部是否存在冲突、版本差异和部署形态差异；
- 示例是否只是示例，还是可以推广为规则；
- 目标 SQLSTATE 是否真的由产品文档保证；
- planned scenario 的 fixture、权限用户、会话和元数据 oracle 是否可在目标环境执行；
- generated SQL 虽通过静态校验，但是否命中了文档想验证的语义。

因此批量质量指标不应只有“完成任务数”，至少同时看：

- `static_complete / total`；
- 原文行覆盖率和 source unit 原子性缺口；
- confirmed/open question 比例；
- 静态门禁首轮通过率与重试次数；
- 每个 factor 的生成 case 数和 pair 覆盖；
- planned scenario 数量；
- 人工抽检错误率。

## 10. 安全与可审计性

- 原文、任务文件和队列状态默认不进入 Git；
- 每项任务记录原文相对路径、SHA-256 和行数；
- 每个 factor 保存同一 SHA-256，防止拿旧规格对应新文档；
- AI 任务文件不包含任何外部上传步骤；
- 不在提示词、代码或队列中保存模型密钥；
- 代码变更与产品文档抽取结果应分开评审；
- 需要把结果带出内网时，先按公司数据分级规则审查，因为 YAML 和生成 SQL 也可能包含产品细节。

## 11. 当前方案能保证什么

在输入章节文本完整、AI 遵守任务契约、任务信封对账和三道门禁均通过时，本方案可以证明：

- 文档原文在账面上没有未登记行；
- 抽取事实和测试消费者可追溯；
- 当前 V1 模型中的合法值、规则和可行两两交互被静态覆盖；
- 生成结果具有唯一 case ID，并通过项目现有的 SQL 基础结构检查；
- 批量任务可以断点恢复、重试和审计。

它不能在不执行数据库的前提下证明：SQL 一定被某个具体 GaussDB 版本接受、目标 SQLSTATE 一定准确、功能行为和生命周期一定符合文档，也不能证明 AI 没有误读一条自然语言事实。后续真实执行和人工抽检仍是最终质量闭环的一部分。
