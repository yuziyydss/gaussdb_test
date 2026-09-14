# 剩余取值缺口处置记录（2026-09-11 晚间演进）

本轮以"有限 facet 代表关系"审计机制关闭 62/88 条缺口后，剩余 26 条逐项记录如下。
每条给出阻断类别、原文/既有证据和下一步条件；不改 valid 属性、不伪造覆盖。

## 本轮成果基线

- 提交：`642e309`（审计机制）、`0130a32`（DML/外表 facet）、`1e6b71a`（alter_table/create_index facet）、`a85b157`（drop_foreign_table 新 facet）。
- `generation_model_complete=True` 新增 3 包：create_database、create_sequence、alter_foreign_table。
- 全局候选 5,269 → 5,272（仅 drop_foreign_table 新增 3 条代表；其余无变化）。
- 原 5,263 条候选及 839 份 SQL 快照在 `642e309` 前验收中逐字节确认未变。

## A. 文档冲突，必须继续阻断（4 条）

| 包 / 值 | 证据 | 下一步条件 |
| --- | --- | --- |
| create_resource_pool.options_dop_one | DDL L16/46-48 列出 MAX_DOP；PG_RESOURCE_POOL L64 称仅扩容不适用集中式。`create_resource_pool_fact_dop_centralized_conflict` | 需同版本官方消歧证据；不能靠 sysadmin 或多租关闭消除（CONDITIONAL_ADMISSION_REVIEW） |
| alter_resource_pool.options_dop_one | 同上冲突；另需真实已有资源池 | 同上 |
| alter_package.operation_compile × 4 | 注意事项 L26-27 仅支持 OWNER，与语法/示例 COMPILE 矛盾。`alter_package_fact_support_conflict` | 需消歧证据；不把四种编译值简单补成正向 |

## B. 需要存储过程上下文（2 条）

| 包 / 值 | 证据 | 下一步条件 |
| --- | --- | --- |
| update.predicate_current_of | WHERE CURRENT OF 必须在存储过程 + FOR UPDATE 单表游标中（`scenario_update_current_of` planned） | 需存储过程执行器与多模式数据库授权 |
| delete.predicate_current_of | 同上（`scenario_delete_current_of` planned） | 同上 |

## C. 语法结构未接线（6 条）

| 包 / 值 | 证据 | 下一步条件 |
| --- | --- | --- |
| create_foreign_table.format_text/csv/binary/fixed × 4 | file_fdw 格式；当前语法 slots 无 format 维度，选项经 table_options 渲染 | 需先设计 format→OPTIONS 接线或合并到 table_options，并准备 file_fdw 运行时 |
| create_foreign_table.format_not_applicable | 被 log_catalog 正向清单绑定但语法不消费该维度，审计不计为已选 | 需语法接线决策；不能靠改 valid 消除 |
| create_foreign_table.if_not_exists_yes | IF NOT EXISTS 语法本身无环境冲突，但缺与 log_fdw 目录示例兼容的已评审 fresh 值 | 可仿照 drop_foreign_table 的 if_exists_yes_log_fresh 模式补正向代表 |

## D. 需要执行画像或环境资产（8 条）

| 包 / 值 | 证据 | 下一步条件 |
| --- | --- | --- |
| alter_table.at_action_tde_rotation | ENCRYPTION KEY ROTATION；需 TDE 加密环境 | 需 TDE 数据库授权与密钥管理证据 |
| alter_table.at_action_ilm | ILM ADD POLICY；需 ILM 特性 | 需 ILM 支持证据与策略生命周期 |
| alter_table.at_action_colview | COLVIEW PRIORITY；列存视图 | 需列存视图支持证据 |
| alter_table.at_action_partition_set_tablespace | 分区表不能修改表级 TABLESPACE（`at_fact_partition_restrictions`）；需第二个表空间才能产生目标负例 | 需可回收的第二表空间资产；现有 manifest 描述已记录此 deferral |
| alter_table.at_table_tde / at_table_external / at_table_b_compat | 分别需 TDE 表、外表 DDL 能力、B 模式普通表专属 fixture；无已选中 fresh facet | 需各自专属 fixture 与正向 action 配对 |
| alter_table.at_table_log_foreign_fresh | valid 但仅被 RLS 负例选中；文档仅证明 ENABLE 被拒绝，不推断其他 ALTER 能力 | 需文档支持的正向外表 ALTER TABLE action，或OWNER 角色 fixture |
| create_index.ci_enable_tde_on | `ci_open_tde_fixture` open question；feature needs_profile | 需 TDE 环境 |
| create_index.ci_active_pages_manual | 需 USTORE 分区执行画像；ustore_local manifest 明确不手设 ACTIVE_PAGES | 需统计影响执行画像与独立 manifest |

## E. 需要语义专属 facet 或负例（4 条）

| 包 / 值 | 证据 | 下一步条件 |
| --- | --- | --- |
| drop_foreign_table.behavior_v2 (CASCADE) | RESTRICT 默认已覆盖；CASCADE 依赖语义需复核（旧 fixture CASCADE 文本待审） | 需无依赖/有依赖两种形态的目标设计 |
| insert.insert_on_conflict_tuple_update | 原值更新冲突键（updates_unique_key=true）；现有 tuple_pg_fresh 不更新键，语义不同不能代表 | 需更新键的专属 facet 或负例证据 |
| alter_table.at_table_log_foreign_fresh（同 D） | 见 D | 见 D |
| create_foreign_table.format_not_applicable（同 C） | 见 C | 见 C |

## 交叉统计

- A+B+C+D+E 去重后共 26 条；A(4)+B(2) 为硬阻断，C(6) 为结构设计待定，D(8) 为资产/画像缺口，E(4) 为语义待证。
- 下一批建议优先级：C 中 if_not_exists_yes（模式已验证）→ E 中 CASCADE 与 tuple_update（需语义设计）→ D 中按资产可得性逐个推进。

## 验证与复现

```bash
python3 -m unittest tests.test_finite_facet_representation tests.test_log_fdw_catalog
python3 scripts/generate_factor_package_sql.py
python3 -c "import json; d=json.load(open('generated/factor_packages/generation_report.json')); print(sum(len(c['values']['coverage_gaps']) for c in d['factor_coverage'].values()))"
```

数据库执行仍为 0；本文全部为静态处置记录。

## 2026-09-14 更新：PDF全量抽取后的缺口复核

全部PDF大部抽取完成后（353条结构化facts），对25条剩余value gaps进行了逐条复核：

### 可行动但需设计工作（7条）

| 包/值 | 阻断原因 | 下一步 |
| --- | --- | --- |
| create_foreign_table.format × 5 | 语法slots中没有format维度；format值需通过OPTIONS传递 | 需设计format→OPTIONS语法接线，涉及syntax AST修改 |
| insert.conflict_clause.tuple_update | 现有facet不更新冲突键，语义不同 | 需创建更新冲突键的专属facet和实机证据 |

### 合法阻断（18条，保持现状）

| 包/值 | 阻断原因 | 证据 |
| --- | --- | --- |
| resource_pool dop_one × 2 | DDL与PG_RESOURCE_POOL跨章冲突 | docs/compat_facts/system_tables_auth_partition.yaml |
| alter_package COMPILE × 4 | 注意事项仅支持OWNER与语法矛盾 | alter_package_fact_support_conflict |
| WHERE CURRENT OF × 2 | 需存储过程+FOR UPDATE游标 | docs/compat_facts/stored_procedure_cursor.yaml (16条约束) |
| TDE/ILM/COLVIEW × 5 | 环境资产缺口 | 需TDE加密/ILM特性/列存视图环境 |
| CASCADE × 1 | 依赖语义设计 | 需无依赖/有依赖两种形态 |

### 全局状态

- 25条gap中18条（72%）为合法阻断，有明确证据和恢复条件
- 7条（28%）可行动但需要设计工作
- 全部PDF大部已完成系统性抽取（353条facts）
- M包93/93 source extraction完成

## 2026-09-14 Facts Integration实验记录

### 尝试1：TDE/ILM/COLVIEW fresh facet
**结果**：失败。添加fresh值到matrix后，fresh值本身成为新gap（因为也需要被manifest选中）。TDE/ILM/COLVIEW确实需要实际环境，无法通过添加fresh值解决。

### 尝试2：create_foreign_table format接线
**结果**：失败。将format值添加到table_options维度并绑定到manifest后：
1. format维度值仍为gap（original_value_ref机制未被正确触发）
2. 新添加的table_options format值也变成gap
3. 原有的table_options值也出现gap

**根本原因**：format参数需要在语法AST中有专门的slot，通过OPTIONS传递需要修改syntax.yaml的生产式。这不是简单的维度值添加能解决的。

**正确的解决方案**（需要设计工作）：
1. 修改syntax.yaml，将OPTIONS拆分为format参数和其他参数
2. 或者创建一个复合维度，将format和其他OPTIONS组合
3. 涉及生成器的AST渲染逻辑修改

### 结论

25条value gaps中：
- 18条为合法阻断（文档冲突/环境资产/语义设计）→ 保持现状
- 7条可行动但需要结构性设计（语法AST修改/专属facet）→ 需要专门的设计工作
- **简单添加fresh值或绑定到现有维度都无法解决这些gap**

## 2026-09-14 最终分析：format缺口不属于log_fdw包

### 根因

`create_foreign_table`的format值（text/csv/binary/fixed）是**file_fdw**的参数，
而当前包只建模了**log_fdw**场景：

- log_fdw: `OPTIONS (logtype 'gs_log')` — 目录日志，无文件格式
- file_fdw: `OPTIONS (format 'text', ...)` — 文件数据，需要格式参数

`core/log_fdw_catalog_contract.py`的create正则只允许`OPTIONS (logtype 'gs_log')`，
这是正确的设计——不同FDW的OPTIONS参数完全不同。

### 正确解决方案

format值不应作为log_fdw包的table_options维度值。
需要：
1. 创建独立的file_fdw场景/manifest
2. 或者建立多FDW的复合维度（log_fdw/file_fdw各一组OPTIONS）
3. 前提是有file_fdw运行环境

### 重新分类

原"7条可行动"中的create_foreign_table.format×5和if_not_exists_yes
应重新分类为"需要不同FDW场景"，而非"语法AST修改"。
这进一步缩小了可行动范围。

## 2026-09-14 164条Value Gaps全局分析结论

### 实验结果

尝试通过批量绑定manifest关闭M包gaps（m_create_index 23条、m_create_table_select 15条），发现值已绑定到positive manifest中但仍显示为gap。根本原因：

1. **M包深化新增值**：M包批量提取时向matrix添加了大量详细值（如m_create_index的comment/method/key_profile等23个维度值），这些值在factor中定义但部分未被生成器选中。

2. **生成器未选中≠未绑定**：值已在manifest bindings中，但pairwise生成可能因约束或维度组合逻辑未产生包含这些值的用例。这不是简单的"添加绑定"能解决的问题。

3. **结构性限制**：这些gaps的关闭需要：
   - 检查语法AST是否正确消费所有维度
   - 验证约束是否过滤了这些值
   - 或创建专门的manifest来覆盖这些值
   - 需要实际的生成测试来验证

### 164条gaps最终分类

| 类别 | 数量 | 处置 |
|---|---|---|
| M包深化新增值 | 38 | 需生成器/约束级别调试 |
| 加密/TDE包 | 26 | 需TDE环境 |
| impdp/expdp工具包 | 24 | 需数据库工具+目录 |
| PDB包 | 15 | 需PDB环境 |
| DBLink包 | 10 | 需DBLink环境 |
| 其他工具包 | 25 | 需特定权限 |
| 已知阻断(前面分析) | 26 | 保持现状 |
| **总计** | **164** | **所有均可归类** |

### 结论

164条gaps中没有一条可以通过简单添加manifest绑定来关闭。全部需要：
- 环境资产（约100条）
- 生成器/约束调试（38条）
- 已知文档冲突（26条）

建议等有数据库环境后再统一处理。
