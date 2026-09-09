# M 兼容命令：第一批有限域抽取与静态验证

2026-09-08。输入是本地 `gaussdb-rf-cent.pdf`（集中式参考，文档日期 2026-04-30），不是历史公司环境的执行报告。

## 本轮做到了哪里

六个独立 M 包已经进入正式 `specs/` 注册与生成链路；这是**首批代表域**，不是六章全文抽取完成，也不是数据库验收通过。普通模式原有 224 包不改身份、不被 M 内容覆盖。

| 包 | PDF 章节 | 正文行数 | 清单 | 候选 SQL | 本轮代表范围 |
|---|---|---:|---:|---:|---|
| `m_create_table` | 2.4.2.8.16 | 981 | 3 | 18 | 普通列/DEFAULT、显式 STORED/VIRTUAL、本地临时表、IF NOT EXISTS、表 COMMENT、LIKE、列存负向 |
| `m_create_view` | 2.4.2.8.21 | 303 | 1 | 14 | OR REPLACE、TEMPORARY、FORCE、两列别名、security_barrier、CHECK OPTION |
| `m_insert` | 2.4.2.12.1 | 441 | 9 | 22 | 表/视图 × VALUES、SET、查询六种形式；可省略 INTO；VALUE；生成列 DEFAULT 与负向 |
| `m_update` | 2.4.2.18.1 | 346 | 2 | 16 | 表/简单视图/直接投影子查询，SET 重复赋值、DEFAULT、WHERE、ORDER、LIMIT |
| `m_delete` | 2.4.2.9.2 | 273 | 2 | 8 | 单表/简单视图，WHERE、ORDER、NULLS、LIMIT |
| `m_select` | 2.4.2.16.2 | 1225 | 2 | 23 | 一/两列投影、嵌套 FROM、DISTINCTROW、缓存语法、LIMIT 三种写法、UNION/EXCEPT |
| 合计 | 6 章 | 3569 | 19 | 101 | 98 条正向语法候选 + 3 条负向候选 |

另有 19 个 **planned** 场景，表达行为/环境/错误预期的后续工作，不是已经执行的测试。72 个新增 YAML 文件、46 条已选择事实（包含待确认问题）；文件数量不是质量指标。

## 数据如何流转

1. 已保存正文被重新按六个准确章节独立提取，记录父 PDF SHA256、章节 SHA256、章节号和行号。
2. `source.yaml` 保留所有正文行的处置；未形式化内容仍是 `unmapped`，未完成原子性复核的 unit 仍是 `unreviewed`。不能将“行号全部有记录”解释为“所有事实已抽取”。
3. `factor.yaml` 定义代表取值、事实、规则、共享检查和引用。M 包使用独立 `m_` 身份；没有抄用通用模式的 TEMP、READ ONLY、RETURNING 或其他未在本章确认的分支。
4. `syntax.yaml` 使用已有 AST 的 choice/repeat/ref，编译语法分支和列表，而非直接输出 PDF 的方括号、竖线或省略号。
5. `matrix` 保存有限输入/查询 profile 的列数、类型和来源。`fixture` 生成实际建表、种子行和清理语句；本地包装 fixture 通过 `requires_fixture_refs` 复用跨包对象，不复制假 setup。
6. `manifest` 固定本次域、M 模式门禁和预期。Pairwise 在有限可行域内选组合，再生成带 setup/target/teardown 的 SQL 快照。
7. 独立核验脚本重新枚举有限可行域，对照生成组合，检查所有要求的非固定维度 pair、ID、SQL 快照、来源哈希和依赖顺序。

例如 M INSERT SET 候选为：

```sql
-- setup：来自依赖 fixture
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- target：来自 M INSERT 的 SET 分支
INSERT INTO m_b01_source SET id = 7, qty = DEFAULT;
-- teardown：逐 case 使用，不能把不相关对象一并清掉
DROP TABLE m_b01_source;
```

这说明目标 SQL 和 fixture 可以生成，不意味着所有静态检查器已理解 SET，也没有证明数据库已经执行成功。

## 本次修正了什么

- **共享 SELECT 锁合同的固定 ID 假设**：原实现只把 `select_lock_none` 认作“无锁”，使 M 的 DISTINCT/集合分支被错误过滤。先用真实 M 包复现失败，再支持 `lock_clause.properties.active`；旧包无该属性时保留原逻辑。正反回归同时验证“无锁不误拒绝”和“真实锁仍拒绝冲突”。
- **INSERT 的覆盖域**：VALUES/VALUE 的选择只放在 VALUES 清单中；SET 和查询输入分别建清单。不会把 AST 未使用的变化算成覆盖。
- **DEFAULT 的复用边界**：复用现有表列 DEFAULT 合同与真实 DDL，INSERT/UPDATE 引用 M CREATE TABLE 的事实；视图列资格引用 M CREATE VIEW 的导出事实。未确认的视图 DEFAULT 继承仍保留 `needs_review`。
- **Fixture 依赖**：表先于视图，目标用例在两者之后，清理逆序；空对象包装仅组合依赖，不生成 `SELECT 1` 假 setup。

本轮没有改变公开 V1 模型，也没有新建一个通用 SQL 解析器。核心修改是已有共享 SELECT 检查的最小适配。

## 验证口径

- 全库重新生成：547 个清单，4022 条候选；其中新增 M 为 19/101。
- 原有 528 份通用模式 SQL 快照的文件哈希前后相同。
- M 首批全部 19 个清单生成非空；ID 全局唯一，同一 M 包内 SQL 不重复，重复生成结果确定。
- V1 回归 46 项通过；M 专项、DEFAULT、派生目标、fixture 和跨章依赖相关回归合计 49 项通过。M 专项的 7 项包含在 49 项中，不重复累计；这不是整个项目全部测试的宣称。
- 去掉固定维度后，本批要求的 pair 合计 **461/461**；没有交互维度的单例不称为 pairwise 交互覆盖。独立枚举仍使用当前规则判断合法性，因此不能证明规则本身完整或正确。
- 3 个负向候选只声明目标错误类别，SQLSTATE 尚未实机校准，明确 `needs_verification`。
- 静态写入检查是有限范围工具：M INSERT 有 7 条、M UPDATE 有 14 条候选当前为 `checked`；其余分别可能超出解析范围或缺 DEFAULT 语义证据。CREATE/SELECT/DELETE 不在该写入检查器的支持范围，不能据此判定数据库“不支持”。详细问题逐 case 保存在本批报告。
- 数据库执行：**0**。没有执行 SQL、连接数据库、提交或推送。

`generation_model_complete=true` 即便出现在某个有限模型的审计结果，也不表示该 PDF 章节已完整覆盖。这里六包的 `source_extraction_complete/static_coverage_complete/behavior_coverage_complete` 都不是 true，包状态均保留 `needs_review`。

## 明确保留的缺口

| 包 | 下一步缺口（不是不支持清单） |
|---|---|
| CREATE TABLE | AUTO_INCREMENT、键/索引、字符序、生成列表达式限制、全局临时表/ON COMMIT、配置依赖；普通列与 LIKE 的细项还需逐条映射 |
| CREATE VIEW | 已存在对象的替换生命周期、临时基表影响、FORCE 失效/重编译、精度开关、CHECK OPTION 行为与复杂可更新性 |
| INSERT | IGNORE 警告/调整规则、重复键的真实冲突 fixture、别名/分区、可插入视图限制；SET/省略 INTO 的共享写入检查尚未适配 |
| UPDATE | CTE、多表、索引提示、生成列写入、s2 从左到右赋值；ONLY 保留语法不能冒充功能覆盖 |
| DELETE | CTE、多表删除、s2 名称解析、复杂视图资格；不能从单表样本推导 |
| SELECT | CTE/递归、JOIN、分组和 ONLY_FULL_GROUP_BY、窗口、锁、导出文件/INTO、复杂输出类型与表达式 |

两项原文疑问独立登记：CREATE TABLE 的 IF NOT EXISTS 示例导语与上下文矛盾；SELECT 关于“子查询多列”的限制范围需要区分 scalar 与 FROM 派生表。不会把“尚未建模”全部伪装成 open question。

正文映射缺口与原子性缺口的完整 ID 列表在各包 `coverage_audit.json` 中。现阶段不批量豁免这些缺口，也不逐条手改生成的 SQL。

## 文件与复跑入口

- 规格：`specs/ddl/m_create_table/`、`specs/ddl/m_create_view/`、`specs/dml/m_{insert,update,delete,select}/`。
- 正文与目录：`work/m_compat_batch_01/corpus/`（本地输入，不向外发布）。
- 权威 SQL 快照：`generated/factor_packages/m_*/`。
- 本批证据与 SQL 镜像：`generated/m_compat_batch_01/generation_report.json`、各包 `coverage_audit.json`。
- 93 命令进度分账：`generated/m_compat_batch_01/m_command_progress.json`，目前 6 个有限域包、87 个仅来源初抽；不混入普通 224 包分母。
- `scripts/build_m_compat_pilot.py` 是本批人工审阅模型的补丁输出器，不是自动理解 BNF 的抽取器。默认拒绝覆盖；`--update` 只输出差异，必须先审阅再应用，不能据此覆盖后续人工工作。

```sh
GAUSSDB_ENABLED=false python3 scripts/lint_factor_packages_v1.py
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_pilot.py
GAUSSDB_ENABLED=false python3 -m unittest discover -s tests -p test_m_compat_pilot.py -v
```

当前固定对象名要求将来在独占隔离测试空间、逐 case 生命周期下运行。setup 成功不是目标成功；setup 失败不得继续目标或清理他人的同名对象。此文档不是数据库执行授权。

## 后续节奏

先以这批实际诊断作为共享合同的输入，优先审阅 M SET/省略 INTO 的有限写入适配；不得通过删除分支或吞异常伪造全绿。下一批可选择 15～20 个真实命令，搭配它们实际需要的表/视图/事务/索引依赖；每批复用上述门禁。复杂语义、外部环境与目标 Oracle 单列待办，不要求把六章行为都做到 100% 才扩批，也不宣称本轮已覆盖全部 93 章。
