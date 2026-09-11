# PDF 类型转换首批：值存储与 UNION/CASE

## 本批结论与口径

最终静态验收已完成：单次完整 discovery 为 **1,903 项通过**，unittest 耗时 3,523.004 秒，含输入快照的运行收据耗时 3,557.190 秒；冻结前后及验收时的受记录输入一致。两份正文哈希、旧候选/SQL 和原有缺口已再次核对，见 `work/common_type_batch_20260911/acceptance.json`。修正来源台账后的 24 项专项也通过，但与全量有重叠，不相加计数。

2026-09-11 从已有正文中精审 1.9.4、1.9.5 的有限子集，抽取 10 组规则：6 组接入有限生成检查，4 组明确待审。新增 7 条 SELECT 和 2 条 INSERT SELECT 候选。不是完成这两章全部语义，也不是新增两个 SQL 命令包。

当前生成库存为 317 包、839 个 manifest、5,263 条候选。已有 5,254 条候选的报告字段和 837 份 SQL 快照逐一对账不变；现有覆盖缺口、待解问题和完成度结论不变。新增清单单个维度枚举，不能把它们称为多维 Pairwise 全覆盖。

定向回归 22 项通过。首轮全量运行发现两项旧来源台账校验失败：正文集合仍预期 24 份，失效消费者清单遗漏新增两份正文。已保留 `work/common_type_batch_20260911/full/` 的失败日志和中止收据，按实际来源补齐精确集合为 26 份；没有放宽检查。最终全量静态回归结果以 `work/common_type_batch_20260911/full_final/receipt.json` 为准；收据不存在或状态不是 `passed` 时不得引用旧版 1,892 项作为本版本通过证据。未连接数据库、未执行 SQL、未提升包的实机验证状态。

## 来源与范围

权威文档为本地 `gaussdb-rf-cent.pdf`，GaussDB V2.0-10.0.0 集中式，文档版本 01，2026-04-30。PDF SHA-256 为 `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

| 章节 | 保存正文 | PDF 物理页 / 印刷页 | 本批范围 |
|---|---|---|---|
| 1.9.4 值存储 | `work/pdf_foundations_2026_09_07/corpus/general/utility/section_1_9_4.txt` | 1139–1140 / 1090–1091 | 来源与目标类型完全一致；转换、长度/精度分开待审 |
| 1.9.5 UNION，CASE和相关构造 | `work/pdf_foundations_2026_09_07/foundation_batch_05/corpus/general/utility/union_case.txt` | 1140–1146 / 1091–1097 | 每列独立解析、同类型、unknown、不同类型类别及左结合 |

两处正文哈希、规则行号、10 组规则的去向见 [机器可读记录](data/common_type_batch_01.json)。同时核对了物理页 1139、1141 的图像。A 模式转换表、C 模式特殊函数和 A 模式参数影响不能外推到 PG 或 M。本批消费者显式要求物理 PG 模式；环境声明不是实际连接探测。

## 从原文到生成检查

1. **确认事实身份。** 从正文区分通用描述、兼容模式专属表格和示例；保留每条规则的正文哈希、行号与限制。
2. **事实落在可复用的包内。** SELECT 导出 5 个 common-type 事实；INSERT 保存 exact-storage 事实并引用 SELECT 的事实，不复制一份转换规则。CREATE DATABASE 的兼容模式事实用于清单环境门。
3. **受控资产提供实际列类型。** SELECT 拥有 `fixture_select_common_type`；INSERT 的 `fixture_insert_common_type` 通过 `requires_fixture_refs` 依赖它。创建源表、种子、目标表按依赖顺序；清理按相反顺序。仅清理这批命名资产，没有广泛 DROP 或异常吞噬。
4. **生成器读取实际 SQL 与实际 setup。** 选中 `common_type_contract: pg_scalar_union_case_v1` 的 profile 才进入 `core/common_type_contract.py`。不能只信 `output_types` 标签；实际 SQL、实际源表 DDL 和目标列必须一致。
5. **先报告不确定，再扩大子集。** 不同类别已知类型是明确矛盾；同类别混合类型、字符串转数值、精度/长度转换等返回待审，不能借用全局默认转换表放行。
6. **生成后保全旧产物。** 全库生成到独立预览目录，对比所有旧 manifest 字段及 SQL 字节，确认仅新增 9 条，再发布新增快照和受影响审计。

本轮无需改变 Factor Package V1 的公共模型，也没有建立一个包罗万象的类型系统。

## 一个真实例子

源 fixture 的实际 DDL 与数据：

```sql
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES
  (1, 10, 'a', TRUE), (2, 20, 'b', FALSE), (3, NULL, NULL, NULL);
CREATE TABLE g_common_target (result INTEGER);
```

生成的 INSERT SELECT：

```sql
INSERT INTO g_common_target (result)
SELECT CASE WHEN flag THEN id ELSE qty END AS result
FROM g_common_source;
```

静态检查发现 `flag` 为 BOOLEAN，`id` 与 `qty` 都是 INTEGER，因此 CASE 的输出为 INTEGER；目标 `result` 也是 INTEGER，符合本批“同类型赋值”规则。如果将 fixture 的 `qty` 改为 TEXT，生成器拒绝此候选；将 profile 声称的输出改为 TEXT，也会拒绝。即使条件是 `TRUE`，也不会忽略 ELSE 分支的类型。

再如：

```sql
SELECT id, note FROM g_common_source
UNION SELECT qty, NULL FROM g_common_source;
```

两列分别求类型，得到 `[INTEGER, TEXT]`，不是整行统一成一种类型。`SELECT NULL UNION SELECT NULL` 的结果类型按文档规则为 TEXT；再在其后追加 `UNION SELECT 1` 时，不能忽略前一个 UNION 已经形成的 TEXT 类型。

这仅证明已评审子集的类型一致性，不证明执行成功、NULL 约束、行数或数据库返回值。INSERT 场景计划按 `result NULLS LAST` 排序检查 `[[1], [20], [null]]`；该 Oracle 仍为 planned，等待授权执行及校准。

## 支持与保留缺口

| 已接入的有限能力 | 未覆盖的边界 |
|---|---|
| INTEGER/SMALLINT/BIGINT、TEXT、BOOLEAN 的相同类型解析 | 混合类型优先级和完整隐式转换图 |
| 简单 UNION/UNION ALL，每列检查，最多四分支左结合 | INTERSECT/EXCEPT、括号组合、递归查询 |
| 单个 WHEN、显式 ELSE，有限布尔条件 | 多 WHEN、复杂表达式和完整运行时求值 |
| 全 unknown → TEXT；已知类型与 NULL 的有限组合 | unknown 字符串转非 TEXT 的内容校验 |
| INSERT SELECT 显式目标列与实际 DDL 完全同型 | 长度/精度、截断、NOT NULL、唯一性等行为 |
| PG 环境门与跨包依赖顺序 | A/C/M 外推、实机模式探测和行为结论 |

两项新场景均为 planned，包含结果检查和仍待人工校准的类型/错误断言。没有编造 SQLSTATE，也没有把任意失败视为正确的负向结果。

## 文件与复现

- 核心有限检查：`core/common_type_contract.py`；生成消费点：`core/factor_package_generator.py`。
- 规格：`specs/dml/select/`、`specs/dml/insert/` 下的 factor、source、matrix，以及新增 common_type fixture/manifest/scenario。
- 可复核构建：`GAUSSDB_ENABLED=false /usr/bin/python3 scripts/build_common_type_batch.py --check`。它验证来源哈希与已写入的精选增量；不执行数据库。默认模式只输出 patch。
- 回归：`tests/test_general_common_type_contract.py`，含真实生成入口的错误输出声明、错误模式及实际 DDL 变异回归。
- SQL：`generated/factor_packages/select/manifest_select_common_type_pg.sql`、`generated/factor_packages/insert/manifest_insert_common_type_pg.sql`。
- 旧产物对账：`work/common_type_batch_20260911/publication.json`；全量最终验收：同目录 `acceptance.json`，必须实际生成后才可引用。

下一批应先选择一种有明确正文和实际消费者的混合类型转换，补反例再接入；不由本批成功推导整章、全部类型或 M 兼容模式完成。
