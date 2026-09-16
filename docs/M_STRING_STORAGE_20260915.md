# M 字符串存储合同与参考事实复核（2026-09-15）

## 本轮边界

这是上轮可信性恢复之后的一个有限增量：复核 8 组重名参考事实，
修复 M 字符串存储检查，接通显式赋值、DEFAULT、省略列和可选 Fixture seed 检查。
未连接数据库、未修改数据库状态、未提交或推送。
没有批量改写 885 条参考事实，也没有将文档复核等同于实机验证。

## 1. 复核结果：8 组 / 16 条记录

保留四个参考文件内各自的限定 ID，不删除同名记录、不按裸 ID 覆盖：

- `docs/compat_facts/mysql_m_data_types.yaml`
- `docs/compat_facts/mysql_m_datatypes_complete.yaml`
- `docs/compat_facts/mysql_m_operators.yaml`
- `docs/compat_facts/mysql_m_operators_complete.yaml`

| 裸 ID | 修正后的物理页 | 必须保留的区别 |
| --- | --- | --- |
| m_dt_int_union_length | 3293–3294 | CTAS 中 UNION 的直接整数常量；enable_precision_decimal 条件；不是任意表达式长度 |
| m_dt_precision_truncate | 3296 | 类型声明精度，不是输入值小数秒截断 |
| m_dt_time_negative_zero | 3296 | TIME 负零的输出格式，不是负数存储规则 |
| m_dt_timestamp_explicit_defaults | 3295–3296 | MySQL 比较版本/开关、显式 NULL/NOT NULL、严格模式 |
| m_dt_year_display | 3296 | YEAR 元数据/显示，不推导整数或日期存储 |
| m_op_null_compare_unconvertible | 3379–3380 | NULL 整型/日期列、不可转换常量或绑定参数、具体操作符 |
| m_op_null_display | 3379 | 客户端显示空白不等于 SQL 空字符串 |
| m_op_string_to_double_error | 3379 | 常量与字段身份不同；未校准 SQLSTATE |

每条增加 `compatibility_mode`、`source_physical_pages`、`evaluation_phase`、
`applicability_conditions`，库存审计保留这些信息。`confirmed` 仍仅指来源复核。

当前库存仍为 67 文件、885 记录、885 限定 ID、877 裸 ID、8 组重名。
明确模式的新增记录是 16 条，其余 869 条仍需逐项评审模式条件。
该目录仍是参考资料，不是已接入生成器的全局 Fact/Capability 注册表。

## 2. 修复的真实失败

旧实现对以下离线检查返回 `checked`：

```sql
CREATE TABLE t (note TEXT);
-- 将 65,536 个 ASCII 字符作为一个完整字符串字面量：
INSERT INTO t VALUES ('...');
UPDATE t SET note = '...';
```

这里的省略号是说明文字，不是库内生成 SQL。回归测试实际构造完整字符串。
错误原因是沿用一般模式的 text 家族/无 typmod 逻辑，未使用 M TEXT 的 65,535 字节上限。
现在超出本合同的输入返回 `needs_review`，不擅自判为目标错误，也不改变原正负向预期。

## 3. 来源与具体范围

唯一产品原文：`gaussdb-rf-cent.pdf`，V2.0-10.0.0 集中式参考，2026-04-30。
PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

- 2.6.4 表 2-74，物理 2486–2487 页：VARCHAR(n) 的 n 为字符数，存储最多 65,532 字节；
  TEXT 最多 65,535 字节；超限行为受 strict_trans_tables 影响。已核对 PDF 表格图像。
- 2.3 表 2-2，物理 1992–1993 页：utf8 与 utf8mb4 对应同一字符集，字符编码 1–4 字节。
  同章区分 server/client/connection/schema 编码和列的继承规则。

正文来源：

- `work/pdf_tiered_2026_09_07/batch_19/corpus/m_compat/utility/section_2_6.txt`，
  SHA-256 `4c5cee6ed2ebb681cb9fcd83ee7656c7c427648dfb4faeab59f586ff9027e159`。
- `work/m_compat_batch_04_charset/corpus/m_compat/utility/section_2_3.txt`，
  SHA-256 `89cc98f9902703663753641a420245018d88fe35fb95a3b3dbf720345215ab80`。

适用条件全部是**清单声明的待满足环境**，不是观察到的运行事实：

| 条件 | 本轮接受值 |
| --- | --- |
| 原文章节范围 | m_compat |
| compatibility_mode | M |
| server_encoding / client_encoding | UTF8 |
| character_set_connection / character_set_database | utf8 或 utf8mb4 |
| 列来源 | 当前 schema 中未限定名称的普通 CREATE TABLE；没有显式表/列字符集覆盖 |

实现不根据 `m_` 名字推导实际数据库模式，也不执行 CREATE DATABASE 或切换连接。
部署时仍须按 `core/m_compat_environment.py` 的现有前置准备流程建立并验证 M 数据库。

接受范围：

- 完整单引号字面量，SQL 双单引号按一个引号解码；支持有效 UTF8 多字节字符。
- VARCHAR(n)：本轮仅支持 n 为 1～16,383 的保守范围（65,532 / 每字符最多 4 字节），
  同时检查实际字符数与编码字节数。这不是声称所有更大 n 都非法。
- 无 typmod TEXT：实际编码不超过 65,535 字节。
- 同一个检查用于显式 INSERT/UPDATE 值、常量 DEFAULT、省略列的常量默认值。
- Fixture 的有限写入检查使用同一份环境条件；视图列直接投影保留列来源，
  但视图 DEFAULT 仍然不从基表自动继承证明。

以下情况继续复核：缺失/重复/错误环境条件、超范围输入、CHAR 补空格、VARCHAR(0)、
TEXT(n)、自定义类型、编码覆盖、反斜杠转义、NUL、无效 Unicode、动态默认表达式、
函数/隐式转换、跨 schema 表、复杂视图和环境状态改变。不推导精确 SQLSTATE 或截断结果。

`shared_m_utf8_string_storage` 只表示上述有限存储条件已检查；
`scope=finite_write_shape_only` 不等于整条 SQL 可执行、Fixture 完整或 Oracle 已通过。

## 4. 接入与验证口径

入口：

- `core/shared_column_contract.py`：共享列元信息和字符串存储检查。
- `core/finite_sql_contract.py::inspect_write`：接收 `environment_requirements`。
- `core/factor_package_generator.py`：目标 SQL 与可选 Fixture seed 均传递条件。
- `scripts/audit_rendered_sql_contracts.py`：独立审计时保留同一份条件。

测试：`tests/test_m_string_storage_contract.py`，包含超长误判、UTF8 字符/字节边界、
DEFAULT 与省略列的一致性、错误环境、一般模式隔离、转义/视图边界、审计与 seed 接线。

全量重新生成于 `work/m_string_storage_20260915/regenerated/`：

- 841 manifests，5,273 cases；841 个 SQL 文件与现有快照逐字一致。
- JSON 仅 841 个 `sql_snapshot` 输出目录不同；规范化该路径后其余内容完全一致，
  包括 case_id、SQL、预期、参数、setup/teardown 和覆盖缺口。
- 对账：`work/m_string_storage_20260915/generation_comparison.json`。
- 静态审计：314 checked、20 needs_review、26 rejected、4,913 not_applicable；正向 rejected=0。
  rejected 不等于负向 Oracle 通过。

**本阶段结束时，正式清单中满足 M UTF8 字符串合同的用例数为 0。**
上述回归样例是离线测试，不是新发布的 manifest SQL；本轮不增加库的 SQL 覆盖数。
后续正式清单接入的增量见 [M INSERT/UPDATE 字符串包报告](M_STRING_PACKAGES_20260915.md)，
不应将本阶段历史统计当作当前库存。

受影响回归计划位于 `work/m_string_storage_20260915/static/plan.json`（98 模块）。
各分片 receipt 和最终 result 才是本轮执行证据；不能沿用上轮 1,938 的全项目通过数。
最初两分片为补跨 schema 编码隔离回归而主动中止（exit -15），保留原始失败 receipt，
不计入通过数；修正后的复跑写入 `static_final/`，不覆盖原始证据。
该轮发现两项旧 M 字符串解析测试缺少编码环境，未满足新合同而失败。
两项均补充显式条件后保留原 `checked`/字面量解析断言，并新增缺条件复核断言；
生产代码未因此放宽。再次冻结后的统一复跑存放于 `static_verified/`。

最终验收：**98 模块、833/833 项通过**（392 + 441），无跳过/预期失败。
独立 discovery 计数一致，两分片的起止输入哈希与最终工作区一致，日志哈希核验通过。
这是受影响范围回归，不是本轮重新执行全项目测试。
唯一汇总证据：`work/m_string_storage_20260915/static_verified/result.json`。
现有 5,273 条逐例静态审计结果与上轮一致，保留原有 95 条 ASCII 合同消费者。

## 下一批

只增加 M INSERT/UPDATE 两个小型字符串清单及独立 Fixture：
ASCII/中文/四字节字符、显式值/DEFAULT/省略列；将本轮来源按正式包的 supplemental source
与 fact 引用接入，复核 schema 字符集前置条件。先确保新增用例真正消费合同，
再考虑超限严格模式的目标 Oracle。数据库执行仍须独立授权。
