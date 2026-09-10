# M STORED 生成列：四种真实输入的有限合同

2026-09-09 夜间窗口第一批，依据本地 V2.0-10.0.0 集中式 PDF。此批不连接数据库，不改变 Factor Package V1 公共模型，也没有手改最终 SQL。

## 解决什么问题

生成列上的 `DEFAULT` 表示请求生成，不是普通列的常量默认值，更不能自动转成 `NULL`。此前四条真实候选虽然可以生成，独立写入审计没有足够依据检查其生成结果，因而保持 `needs_review`。

新合同读取实际 CREATE TABLE、实际 INSERT 输入或有限 seed 历史，检查两列 INT 输入与末列显式 STORED 整数和。名字来自实际声明，不依赖 `generated` 之类的 profile 标签。

| 已有候选 manifest | 输入依据 | 有限检查 |
|---|---|---|
| `manifest_m_insert_generated` | `(7,9,DEFAULT)` | 两个新输入均为 INT32，和为 16；DEFAULT 请求生成 |
| `manifest_m_insert_generated_omitted_values` | `(7,9)` | 按声明前两列关联输入，末列省略并生成 |
| `manifest_m_insert_generated_omitted_query` | 实际源表 seed `(1,10),(2,20),(3,30)`；投影 `id,qty WHERE id=1` | 所有 seed 输入合法，选中行提供生成输入，和为 11 |
| `manifest_m_update_generated_default` | 实际 seed `(id,qty)=(2,9)`；仅 `SET g=DEFAULT WHERE id=2` | 校验初始生成值，再用不变的基础列重新计算，和为 11 |

这些数值是有限静态推导，不是数据库返回值或已执行 Oracle。真实建表是否成功、权限、会话、触发器、并发等仍由独立执行阶段负责。

## 来源与实现

- M CREATE TABLE 正文 L441–458、L472–474：STORED/VIRTUAL 时机、生成表达式约束、不能为生成列声明普通 DEFAULT、写入时可指定 DEFAULT。PDF 物理页 2127、2128、2133 已图像核读。
- M INSERT 正文 L15–16、L76–80：生成列写入限制、默认填充、输入前 N 列与目标声明顺序。
- M UPDATE 正文 L5–7、L14–15：未指定字段不变、生成列不能直接指定值但允许 DEFAULT。
- `core/generated_column_contract.py`：实际列身份、INT32 字面量与和、完整有限 seed 历史、投影和仅生成列更新。
- `core/finite_sql_contract.py`：在有明确 M 来源且没有 CTE 时接入，范围外继续走原来的保守检查。
- `scripts/audit_rendered_sql_contracts.py`：保存新增检查器的源码哈希，避免报告无法绑定真实实现。
- 两个新增回归模块分别覆盖字面量输入和实际 seed 行来源，共 24 项测试；相关冻结回归共 108 项。

## 明确保留的边界

这里只支持两个普通裸 INT/INTEGER 列和末列显式 STORED 的两列相加。VIRTUAL、未明确存储类型、函数、其他算术、NULL/动态输入、类型转换、触发器、连接查询、CTE、基列与生成列同时赋值等不能借此宣称通过。

查询和 UPDATE 只接受完整精确的有限 CREATE/INSERT 历史、裸列整数等值条件、实际 seed 命中。历史中出现额外修改、会话设置、重复创建或不可解释步骤时保持待审；不凭一张表的 DDL 猜测已有数据。所有初始 seed 行都要合法，即便 WHERE 不会选中它们。直接写生成列为 NULL 或整数的既有负例仍保持目标矛盾类别，不伪造 SQLSTATE。

本批不是整个生成列语义的全覆盖。16 条视图/派生 DEFAULT 与 1 条复杂冲突表达式仍待审。

## 验收与统计

- 首阶段 96 项、最终相关冻结回归 108 项通过；分别保留独立收据，不相加当成不重复测试总数。
- 全库重新生成 772 个活跃 manifest、5,061 条唯一候选：全部 case 字段、预期、Oracle 字段、环境门、fixture、报告及 SQL 字节均与原基线相同；所要求 pair 完整覆盖。
- 独立逐 ID 比对：仅上面四条从 `needs_review` 变为有限 `checked`，其余 5,057 条不变。
- 写入审计：4,776 不适用、251 有限已检查、17 待审、17 既有负例静态矛盾；正向矛盾 0。生命周期口径不变。
- 包数仍为 317（一般 224 / M 93）；行为验证仍为 0。未重新宣称旧全量 1,339 项已验证本轮新代码。

本地可追溯证据：`work/project_evolution_20260910_0900/generated_seeded_verification.json`，关联全字段/逐 ID 差异、正文和检查器哈希；`generated_seeded_regression/receipt.json` 关联实际进程、日志、测试数和输入端点。首阶段证据以 `generated_literal_*` 保留，不覆盖历史失败或验证结果。
