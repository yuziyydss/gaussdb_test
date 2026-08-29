# CREATE INDEX Factor Package 适配验证

本目录使用 Factor Package Schema V1 抽取用户提供的 164 行 GaussDB `CREATE INDEX` 产品文档，并检验当前架构对 DDL、对象能力、在线生命周期和元数据行为的适配程度。

来源：

- 文档标题：`CREATE INDEX`
- 产品版本：正文未显式标注，记为 `unknown`
- 原文 SHA-256：`753dd73b4d8310dc8146a5d4793f739a581c73f6116f7b9b81bf9e5ba4a77a07`

## 当前静态结果

- 63 个 source unit 登记 164/164 行；全部完成 `atomic/grouped` 复核，原子性缺口为 0。
- 34 条 confirmed fact 和 5 条 open question；confirmed 非示例事实均有下游消费者。
- 普通表与分区表使用两个 AST 顶层产生式，键列表使用 `repeat`，表形态和键定义分别进入 capability matrix。
- 本页明确的方法只有 `btree`，因此 V1 主生成域没有沿用旧规格中的 `ubtree/gin/gist/ugin`。
- 新增 `index_column_count_contract`，在 Pairwise 前检查键项数量、INCLUDE 非键列要求，以及普通/GLOBAL/在线列数上限。
- 10 个 manifest 生成 308 条 SQL：299 条正向、9 条带目标错误 Oracle 的负向；所有可行 Pair 100%，case ID 和 SQL 全局唯一。
- 3 个 Fixture 为普通表、临时表和两分区表生成真实 setup/seed/teardown。
- 12 个权限、唯一性、在线创建、失败清理、分区元数据、表达式、TDE、可见性、性能和边界 scenario 仍为 `planned`。

审计结论：

- `source_extraction_complete=true`
- `generation_model_complete=true`
- `static_coverage_complete=false`
- `behavior_coverage_complete=false`

静态覆盖尚有 5 个明确缺口：省略 LOCAL/GLOBAL 时原文同时声称默认 GLOBAL 和默认 LOCAL；无名索引与 IF NOT EXISTS 的组合语义冲突；二级分区 Fixture 未补齐；TDE 密钥和加密基表 Fixture 未补齐；本页提到部分/条件索引但没有给出离线 WHERE 子语法。

生成结果位于 `generated/factor_packages/create_index/`，覆盖审计位于其中的 `coverage_audit.json`。
