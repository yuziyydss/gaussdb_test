# CREATE VIEW V1 SQL 静态校对记录

校对日期：2026-08-28。范围仅包括文档事实映射、规格加载、SQL 生成、约束、fixture 契约和 Pairwise 覆盖，不连接数据库。

## 最终结果

| Manifest | 用途 | 候选组合 | 可行组合 | 可行 Pair | SQL 用例 |
| --- | --- | ---: | ---: | ---: | ---: |
| `manifest_create_view_basic_positive` | 主语法正向组合 | 480 | 408 | 146/146 | 18 |
| `manifest_create_view_options_positive` | 视图选项正向组合 | 320 | 128 | 145/145 | 22 |
| `manifest_create_view_read_only_non_updatable_positive` | 不可更新查询的只读分支 | 16 | 16 | 111/111 | 16 |
| `manifest_create_view_schema_qualified_positive` | schema 限定名 | 1 | 1 | 21/21 | 1 |
| `manifest_create_view_invalid_options_negative` | 非法选项名/值 | 3 | 3 | 33/33 | 3 |
| `manifest_create_view_non_updatable_trailing_negative` | 尾部 CHECK 与不可更新查询 | 96 | 96 | 176/176 | 48 |
| `manifest_create_view_non_updatable_option_negative` | 参数型 CHECK 与不可更新查询 | 64 | 64 | 154/154 | 32 |

合计 140 条 SQL、140 个全局唯一 case ID。所有 manifest 均满足 100% 可行 Pair 覆盖，且没有跨 manifest 重复 SQL。

## 本轮校对后修正的遗漏

1. 增加 schema 限定视图名生成，当前可生成 `public.v_name`，不再只覆盖裸标识符。
2. 增加非法选项名、非法 `security_barrier` 值和非法 `check_option` 值三类负向 SQL。
3. 同时覆盖 `security_barrier` 与 `check_option` 的两种书写顺序；顺序不再固定为一种。
4. 增加 `SELECT *` 示例形态，并由 fixture 列契约核对通配符查询的输出列数。
5. 文档列出的 16 类不可更新查询特征均已映射到 query profile，并进入负向 CHECK 与正向 READ ONLY manifest；UNPIVOT、层次查询和闪回语法来自有版本锚点的 GaussDB 官方补充来源。
6. 增加 security-only 参数与所有尾部选项的组合；参数型 CHECK 与尾部 CHECK/READ ONLY 的组合因文档语义不足，暂由约束排除并登记 open question。
7. 将“显式视图列名数量等于查询输出列数”从产品硬约束调整为生成器结构契约。原文确认了列名语义，但没有明确给出数量不等时的产品结果，不能冒充已确认规则。
8. confirmed fact 现在必须存在 syntax、rule、matrix、scenario、structural check 或维度值的实际消费者；只记录、不消费的事实会使规格加载失败。
9. query profile 现在显式声明源表、源列和输出列数；生成器会逐 case 与 fixture 对照，防止生成引用不存在列的 SQL。
10. 文档特性不再用字符串列表假装覆盖，而是逐项登记为 `covered` 或 `needs_profile`，并校验 profile/fact/open-question 引用闭合。
11. 移除把 `VALUES` 与所有尾部选项一并排除的过度约束；全局可更新性规则仍排除 `VALUES × CHECK OPTION`，但允许文档语法没有禁止的 `VALUES × READ ONLY`。
12. 增加全部 16 类不可更新 query profile 与 `WITH READ ONLY` 的正向清单，避免这些 profile 只出现在预期失败的 CHECK 用例中。
13. 正向 manifest 现在只能绑定 `validity: valid` 的值；未验证或非法值不能再被静默标成 success。由此同时纠正了 `FORCE` 的建模：token 本身是 confirmed valid，条件性属于依赖生命周期 scenario，而不是语法值合法性。
14. 确定性对象名的哈希现在包含 manifest ID 与参数组合；不同 manifest 复用相同前缀时不再仅因组合相同而同名。schema/prefix 同时增加安全的未引用标识符校验。
15. 原文 64 个 source unit 全部完成映射、问题隔离或范围处置；新增补充来源引用模型，避免用原文没有提供的方言子语法冒充原文事实。
16. 增加普通可更新视图、无 CHECK 不可见行、视图权限边界、连接/保留键定义等计划场景，使所有 confirmed 行为事实都有明确消费者。

## 已检查的 SQL 结构

- 修饰符顺序为 `CREATE [OR REPLACE] [TEMP|TEMPORARY] [FORCE] VIEW`。
- 视图名支持裸名称和 manifest 指定的 schema 前缀。
- 列别名列表位于 view name 后、`WITH (...)` 和 `AS` 前。
- `security_barrier` 与参数型 `check_option` 位于 view name 后的 `WITH (...)`。
- 尾部 `WITH [CASCADED|LOCAL] CHECK OPTION` 与 `WITH READ ONLY` 位于 query 后。
- 正向 CHECK 组合只选取 `updatable=True` 的 query profile。
- 负向 CHECK 组合只选取文档列明的不可更新 query profile，并记录预期违反的规则。
- 所有查询引用的表和列均由 fixture 提供；显式列别名数量与声明的查询输出列数一致。
- 所有 SQL 以分号结束、括号平衡、不含未渲染占位符。

## 文档事实覆盖状态

- 原文 source unit：64/64 已明确处置，不存在 `unmapped`。
- confirmed facts：44 条，均有实际消费者。
- open questions：10 条，均不会自动升级为硬约束。
- 不可更新特征：16/16 已有 profile 且实际进入 manifest。
- planned scenarios：10 个，覆盖 OR REPLACE、临时对象生命周期、FORCE 依赖恢复、普通可更新行为、CHECK OPTION、READ ONLY、权限、security barrier、INSTEAD 规则和连接视图键保留等行为；当前尚未执行。

全局审计进一步确认：43/43 个 valid value 都实际进入了生成用例，4/4 条硬规则都有正向满足证据和目标负向违反证据，7/7 个 manifest 的 Pairwise 完整。原文抽取、生成模型和静态覆盖三项均已闭环；行为覆盖仍因 10 个 open question 和 10 个未执行场景保持未完成。

## 当前结论边界

静态层可以确认：规格引用闭合、约束可编译、结构契约满足、每个 manifest 的所有可行 Pair 均被覆盖、case ID 和 SQL 唯一。

静态层不能确认：GaussDB 当前版本是否接受每条 SQL、实际错误码、兼容模式差异、对象有效状态、目录字段和 DML 行为。尤其以下内容继续保留为 open question：

- `WITH (security_barrier)` 省略布尔值是否等价于 `true`。
- 参数型 CHECK 与尾部 CHECK/READ ONLY 同时出现时的合法性和优先级。
- 重复 view option 的处理方式。
- FORCE 缺少查询权限时的 warning、valid 状态和重编译条件。
- `VALUES` 视图的可更新性。
- 完整标识符边界、security barrier 行为 oracle 和产品文档版本。

因此，这 140 条应被称为“静态生成候选 SQL”，不能在尚未连接数据库时称为“产品验证通过 SQL”。
