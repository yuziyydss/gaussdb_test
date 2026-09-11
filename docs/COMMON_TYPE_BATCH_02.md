# PDF 类型规则第二批：显式 A 整数共同类型

## 当前结果

2026-09-11 下午，本批已完成有限实现与验收：**当前冻结版本单次完整 discovery 为 1,912 项通过**，unittest 耗时 3,456.038 秒，含输入快照的完整收据耗时 3,488.890 秒。验收再次核对日志/起点收据 SHA、前后及当前输入指纹、四份正文 SHA 和旧产物保全，见 `work/type_rules_loop_20260911_140048/acceptance.json`。没有数据库执行，不代表全章或整个因子库语义完成。

新增 4 条 SELECT、2 条 INSERT SELECT；全库为 317 包、841 manifest、5,269 候选。`work/type_rules_loop_20260911_140048/publication.json` 逐字段/逐字节确认原 5,263 候选、839 SQL 快照、既有缺口和所有覆盖结论均未改变。新增候选不提升包的实机状态。

本次只接入一个共享合同 `a_integer_union_case_v1`：选自 PDF 1.9.5 表 1-309 中 int2/int4/int8 的九个有序配对，不实现整张转换表。原 PG 合同保持独立，不能把 A 表用到 PG/M/C。

## 来源与抽取

权威 PDF 为 `gaussdb-rf-cent.pdf`，V2.0-10.0.0 集中式参考，文档 01、2026-04-30；SHA-256 为 `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

已复核物理第 1141 页（印刷 1092 页）的表格图像和正文：

- `work/pdf_foundations_2026_09_07/foundation_batch_05/corpus/general/utility/union_case.txt`，SHA `9f169c91b5e9056010d430d1efddff1cdf165e77a0bc9ce352ce51ec88a6244d`。
- L28 明确 A 兼容；L32–34 区分 UNION 左到右和 CASE 从 ELSE 开始的解析顺序；L37–52 为数值表头及三条整数行。
- 规则分别落在 `select_fact_a_integer_environment` 与 `select_fact_a_integer_common`；INSERT 从 SELECT 引用，不再抄一份。
- `select_src_028` 是本章的**消费者锚点**，不冒充 1.9.5 的原文。真正来源为补充记录 `select_type_a_integer_source`，锚点 L28–L52；`publication.json.source_proof.common_body` 单独保留其 SHA、页码及九格范围。通用依赖报告中的主章 units 不能单独充当补充规则正文证据。

| 输入 1 / 输入 2 | SMALLINT | INTEGER | BIGINT |
|---|---|---|---|
| SMALLINT | SMALLINT | INTEGER | BIGINT |
| INTEGER | INTEGER | INTEGER | BIGINT |
| BIGINT | BIGINT | BIGINT | BIGINT |

单元测试对 UNION 和 CASE 分别检查九格；SQL 只选六个消费者代表。**九格单元检查、六条 SQL、整章覆盖是三个不同口径。**

## 从规则生成 SQL

SELECT 的 fixture 提供实际三列源表，INSERT 的目标 fixture 依赖它；展开先建源表和 seed，再建目标，清理顺序反转。fixture 要求新独占命名空间，不预先 DROP 同名对象，也不清理未经确认的公共资产。

```sql
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
CREATE TABLE a_common_target (result BIGINT);

INSERT INTO a_common_target (result)
SELECT CASE WHEN TRUE THEN lo ELSE hi END AS result FROM a_common_source;
```

CASE 即使条件恒真，也检查 ELSE 的 BIGINT。共同输出为 BIGINT，目标也是 BIGINT，属于本批允许的精确存储类型。若目标改为 INTEGER，不因这两行数值较小就放行，仍报 `assignment_conversion_unknown`。若 manifest 模式改为 PG/M/C，生成入口拒绝 A 合同。

环境门只声明物理 A 连接要求，没有创建数据库或探测连接。候选 `expected=success` 且 `scope=syntax_only` 是有限规格预期，不是成功执行的事实。新场景 `scenario_insert_common_a_integer` 仍为 planned，计划查询排序后的 `[[1],[2]]` 并人工校准真实类型/目标错误，不编造 SQLSTATE。

## A3：长度/精度消费者评审

结论：**先保留独立存储阶段，不把共同结果类型升级成长度、舍入或写入成功保证。** 已复核 PDF 物理 100 页（印刷 51）字符表、物理 89 页（印刷 40）数值表图像。

| 已有消费者或规则 | 实际已有能力 | 保留缺口/下一步 |
|---|---|---|
| 1.9.4 L9–15：长度/atttypmod 转换 | 同型与长度处理明确分阶段 | 需要目标 typmod、显式/隐式上下文、模式，不能靠基本类型相同推导长度安全 |
| INSERT `insert_source_values_*`、UPDATE `update_set_literal` 对 VARCHAR(64) | 可检查有限列名/列数/类型族 | 显式字符串赋值没有长度证明；优先做共享有限 ASCII 字符串存储守卫，而不是逐条修改 SQL |
| INSERT/UPDATE 的常量 DEFAULT | `validate_literal` 已检查有限 ASCII 和声明长度，非 ASCII/超长待审 | 不能把 DEFAULT 专用检查说成所有显式赋值都已覆盖 |
| NUMERIC(p,s) 常量、DEFAULT | 现有共享检查只证明精确可表示，小数需缩减或整数位超界待审 | 不模拟通用舍入/告警；舍入后的进位、溢出与错误 Oracle 需独立校准 |
| INSERT 的 `insert_fact_truncation` | 已有 C 模式、`td_compatible_truncation=on`、非外表条件；历史场景 planned | 不从 INSERT 章节自动外推 UPDATE；多字节编码跨截断点也未解决 |
| PG/A/B 字符长度 | 文档明确 PG VARCHAR 以字符计；A 有 byte/char；B 的 5.7/s1 与 sql_mode 改变行为 | M 必须使用 M 正文；模式、编码、参数缺失时保留待审，不能统一按 Python len() 判定 |

原文依赖（本批只精读相关行，不宣称新抽取整章）：

- `section_1_3_4.txt` L9–31、L35–57、L76–112；SHA `1c9f061dcb9ebbfc7f65d25cde82e23feb2c99cde57f076e34a48fa077f0ed2e`。
- `section_1_3_1.txt` L149–185、L252–264；SHA `1d2671cb8e57f72fbfe0dccdf4d57cd400af496a35ba2e5a63631bf7e9c8d1b3`。二者都在 `work/pdf_foundations_2026_09_07/corpus/general/utility/`。
- INSERT 主章 L18–27：`work/doc2spec/full_general_corpus/general/dml/insert.txt`。现有场景 `specs/dml/insert/scenarios/generated_and_truncation.scenario.yaml` 保持 planned。

本次实际离线探针：对 `t(id INTEGER, note VARCHAR(2), qty NUMERIC(4,2))`，INSERT/UPDATE 写入 `'long'` 均返回 `checked`，但 scope 仅 `finite_write_shape_only`，checks **没有长度检查**；写入 `1.234` 均返回 `needs_review / decimal_rounding_unknown`。这不是数据库结果，也不能据 checked 认定超长字符串可执行。详细探针留在本轮 review.md。

## 验证与复现

- 真实 RED：`work/type_rules_loop_20260911_140048/red/receipt.json`（6 项失败，含旧生成器拒绝 A 身份）；保留失败日志，不抹掉历史。
- 专项：同目录 `targeted/receipt.json`，28 项通过（A 9、原 PG 11、跨章依赖 8），不与全量重复相加。
- 包计数三个旧断言真实失败后，仅按新增 4+2 更新，三项复跑通过；原 INSERT 110 条基线及负例数保持不变。
- 全量：同目录 `full/receipt.json` 为本版本 1,912 项通过的实际收据，`acceptance.json` 为二次对账；不是借用上一批 1,903 项旧收据。专项与全量有重叠，不相加计数。
- 重建：`/usr/bin/python3 -m scripts.build_a_integer_common_type --check`；旧 `scripts/build_common_type_batch.py --check` 同时保持通过。默认输出 patch，不写规格、不执行 SQL。
- SQL：`generated/factor_packages/select/manifest_select_common_type_a_integer.sql` 和 `generated/factor_packages/insert/manifest_insert_common_type_a_integer.sql`。这些是检查快照，应按 case 分阶段执行，不能整份盲跑。

下一批优先评审“显式 ASCII 字符串赋值的长度守卫”，先明确模式/存储阶段/超限待审口径，再用真实 INSERT/UPDATE 回归接入；不扩建全局转换框架，不同时精修所有类型。
