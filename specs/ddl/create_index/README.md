# CREATE INDEX PDF-first 因子包

本目录以本地 `gaussdb-rf-cent.pdf` 的通用 SQL 章节 `1.13.9.27 CREATE INDEX` 为唯一产品事实源。它用于校准“原文抽取 → 事实分类 → 语法/能力建模 → SQL 组合生成 → 静态覆盖审计”链路，不代表 SQL 已经在数据库执行通过。

## 权威来源

- 产品/版本：GaussDB V2.0-10.0.0 集中式版参考
- PDF 物理页：1453–1472（文档印刷页 1404–1423）
- 抽取文本：`intranet_corpus/general/ddl/create_index.txt`
- 章节文本 SHA-256：`7a8ce69c11e865868cb75fd990000d6a41ceb91ce200dd3e882dc41496863d0d`
- 章节文本行数：899

任何旧规格、旧 SQL 快照和数据库经验都不能覆盖 PDF 事实；PDF 没有说明的组合必须登记为 open question 或 planned scenario。

## 包内职责

- `create_index.source.yaml`：209 个 source unit，逐行覆盖 899/899 行；复合限制按语义拆分，不以“少于若干行”冒充原子事实。
- `create_index.factor.yaml`：63 条 confirmed fact、9 条 open question、维度和可追溯约束。
- `create_index.syntax.yaml`：普通表与分区表两个顶层 AST，键列表由 repeat 节点渲染。
- `matrices/`：表形态、索引方法、键定义和 WITH 参数能力契约。
- `fixtures/`：9 个声明式前置对象；模式限定用例使用独立 Schema Fixture，保证索引与目标表同属 `ci_target_schema`。
- `manifests/`：22 个生成清单，区分 ready 正向候选与 needs_review 负向候选。
- `scenarios/`：19 个 planned 生命周期、行为、元数据和环境场景。

## 当前静态生成结果

在当前生成器上，本包生成 335 条候选 SQL：307 条正向、28 条负向。所有适用的 Pairwise 清单均为 100% 可行 pair 覆盖，规则覆盖缺口为 0，case ID 与 SQL 唯一。

这些数字只说明“模型内的组合被覆盖”，不等于 PDF 全域覆盖，也不等于数据库可执行：

- 51 个 documented feature 中，35 个已有代表值证据，只有 16 个达到当前模型定义的全域覆盖；审计因此保留 35 个 feature gap（19 个“仅代表覆盖”加 16 个 `needs_profile`）。
- 16 个明确的 `needs_profile` 包括完整 UGIN/GIN/GiST 键类型与 opclass、前缀/排序边界、FASTUPDATE、INDEXSPLIT、INDEX_TXNTYPE、STAT_STATE、LPI、GiST buffering、ILM、TDE、ACTIVE_PAGES 和二级分区。
- 8 个已知 dimension value 尚未进入可执行清单，主要是兼容模式、TDE、二级分区和可见性等环境门控值，以及两项尚未绑定的负向边界。
- 13 个负向清单只有目标错误类别，SQLSTATE/错误消息尚未经过数据库确认，因此保持 `oracle_status: needs_verification`。
- 19 个 scenario 均为 planned，尚未执行。

## 本轮纠偏

- 删除“表达式、前缀、COLLATE、opclass 与 CONCURRENTLY 组合必然失败”的猜测；PDF 只明确限制最终方法、表形态、PCR、二级分区和 GSI。
- 将“显式 UNIQUE LOCAL 且缺少分区键必然报错”改为 open question；原文的显式 scope 规则与 UNIQUE 自动选型规则存在未说明的优先级，ready 正向清单不再生成该组合。
- 31/32 键列上限按有效 scope 校验：显式 scope/分区名优先；省略 scope 时，UNIQUE 且包含全部分区键为 LOCAL，其他分区索引为 GLOBAL。
- UGIN 的 ILM 压缩能力在本章未说明，保留为 open question；仅对原文明确不支持压缩的 GIN/GiST 进行硬过滤。
- 以 PDF 明确禁止的 `PCR UB-Tree + CONCURRENTLY` 保留在线能力负向候选，仍不猜测具体 SQLSTATE。
- 修正模式限定正向用例：`ci_target_schema.idx_*` 作用于 `ci_target_schema.t_ci_schema`，符合“索引模式与表相同”的原文契约。
- 对单个代表 profile 使用 `coverage_mode: representative`，并另列完整值域 needs_profile，避免把代表值误报为全域覆盖。

## 审计结论

- `source_extraction_complete=true`
- `generation_model_complete=false`
- `static_coverage_complete=false`
- `behavior_coverage_complete=false`

当前已闭环的是“PDF 章节逐行有处置、已建模清单可确定生成、Pairwise 可审计”；尚未闭环的是完整文档值域、负向错误 Oracle、环境场景和数据库行为。

生成与审计命令：

```bash
python3 -B scripts/generate_factor_package_sql.py --factor create_index
python3 -B scripts/audit_factor_coverage_v1.py --factor create_index
```
