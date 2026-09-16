# M INSERT/UPDATE：字符串合同正式接入（2026-09-15）

## 本轮完成范围

把上一轮已复核的 UTF8 字符串存储检查接入两个正式包，而不是只停留在测试函数里。
没有连接数据库，没有执行 CREATE DATABASE、setup、目标 SQL 或 teardown；没有提交或推送。

| 产物 | INSERT | UPDATE |
| --- | --- | --- |
| 清单 | `manifest_m_insert_string_utf8` | `manifest_m_update_string_utf8` |
| 独立 Fixture | `fixture_m_insert_string_utf8` | `fixture_m_update_string_utf8` |
| 生成用例 / planned 场景 | 9 / 9 | 8 / 8 |
| 目标表 | `m_insert_utf8_source` | `m_update_utf8_source` |

输入包含空串、一个/两个 ASCII 字符、一个/两个中文字符、四字节字符、单引号转义、
显式 DEFAULT；INSERT 另包含省略尾列。列为 `VARCHAR(2) DEFAULT '默认'`。
UPDATE 有真实种子 `(2,'旧')`，目标条件为 `id = 2`，不是更新不存在的行。
本批只有一个变化维度；所有声明值均生成，不能把 pairwise 状态解释成跨特性全覆盖。

## 来源与合同

产品来源、物理页和正文哈希见 [前一阶段报告](M_STRING_STORAGE_20260915.md)。
两个 source ledger 都增加 2.6.4 类型与 2.3 字符集的 supplemental source 引用，
保留原章节 DEFAULT 行作为消费位置，不把跨章事实冒充该行原文。
各包增加字符串存储、编码条件与尚未覆盖范围三类事实，不覆盖旧的精审事实。

生成必须满足清单声明的 M 模式、UTF8 server/client、utf8mb4 connection/database 条件；
结果场景另声明 results 字符集。表列不显式覆盖字符集，依赖当前独占 schema 的继承关系。
声明条件不是实测环境：通用 M 数据库创建计划不会自动证明数据库/会话实际为 UTF8。
执行前必须先按现有计划创建或授权复用物理 M 数据库、重连，再核验全部编码条件。

选定目标 profile 显式声明 `required_write_contract: m_utf8_string_storage`。
生成器必须在实际渲染的目标 SQL 上得到 `checked` 和 `shared_m_utf8_string_storage`；
相关 setup DML 也必须通过检查。缺失编码、超长 DEFAULT/seed、未消费或未知合同不能静默放行。
该要求只约束本次选择的 profile，不批量改变旧清单的 `needs_review` 边界。
Fixture/profile 的配套选择只属于 manifest 与生成检查，不作为产品的 SQL 非法条件。
因此不为测试资产 ID 的不匹配虚构数据库负向场景。

## 从生成到场景的例子

生成器从新 manifest 的目标 profile、输入 profile 与 Fixture 得到：

```sql
CREATE TABLE m_insert_utf8_source (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT '默认');
INSERT INTO m_insert_utf8_source VALUES (7,'😀好');
```

两字符、七 UTF8 字节，满足这一个有限列合同。对应场景用 candidate 的 manifest/params
选择这条生成用例，不复制另一份目标 SQL；预期结果查询为：

```sql
SELECT id,note FROM m_insert_utf8_source ORDER BY id;
```

计划预期 `[[7, "😀好"]]`。尚未观察实际结果，场景仍为 `planned`。
每个场景独立建表/种子/目标/结果检查/清理，不可将所有 SQL 快照串成一个脚本执行。
只对本场景成功创建的对象做 `DROP TABLE ... RESTRICT`；不会兜底清理其他对象。

## 产物与离线操作

- `specs/dml/m_insert/`、`specs/dml/m_update/`：正式因子、来源、矩阵/维度、Fixture、manifest、场景。
- `scripts/m_string_package.py`：现有 pilot builder 的有限增量，不是另一套 SQL 生成器。
- `generated/factor_packages/m_insert/manifest_m_insert_string_utf8.sql`
- `generated/factor_packages/m_update/manifest_m_update_string_utf8.sql`
- `work/m_string_packages_20260915/preparation_fixed.json`：17 个 candidate 与 17 个场景一一绑定。

离线重新准备（输出路径必须未存在；无数据库执行参数）：

```sh
python3 scripts/prepare_execution_batch.py --profile m_string_storage --output work/my_m_string_review/preparation.json
```

准备结果：2 包、2 清单、17 候选、17 已绑定、0 未绑定、0 静态阻断；
`execution_authorized=false`、`database_executed=false`、`runtime_verified=0`。
类型化结果 Oracle 通过结构检查不代表驱动/实机校准已经完成。
清单 `expected=success` / `scope=syntax_only` 表示有来源依据的预期，不表示执行通过。

## 验证证据与边界

全量生成从 841 清单 / 5,273 用例增加为 843 / 5,290。
原有 841 个清单除输出路径外的字段和 SQL 快照完全一致；
case_id、SQL、预期、参数、setup/teardown、原清单 pair 报告均未变化。
只有两个包的全局覆盖报告随新增事实/场景/值变化，未将其宣称为全章完成。
对账见 `work/m_string_packages_20260915/generation_comparison_fixed.json`。

全量有限写入审计：331 checked、20 needs_review、26 rejected、4,913 not_applicable；
正向 rejected=0。新增 17 条是 checked 的增量；旧的待复核/负向拒绝未隐藏。
`checked` 仅为有限写入合同检查，不是整条 SQL 正确性或数据库验证。

当前版本相关静态回归已通过：**111 模块 / 946 项**，分片为 48、337、295、266 项，
均 exit 0 / OK，无跳过项。结果见 `work/m_string_packages_20260915/static_final/result.json`。
已核对四份日志及启动记录哈希、模块清单和独立 unittest 发现数量；
9,661 个输入文件的前后快照与最终工作区一致。
这是受影响范围回归，不是所有项目模块的全量回归；不沿用前一阶段的 833 或历史全项目通过数。

正式生成报告 SHA-256：`d313f321c4ed4f10d3073f65d51656517177d8fb4d44fc3ec68c84048af4796e`。
离线准备包 SHA-256：`fca6a716a4a7c933bef80ff30745246af8cbc73d497940ce8ccf0c650fc82486`。
正式快照与 `_fixed` 预览逐字一致，生成报告仅输出路径不同；准备包输入哈希也与当前一致。

第一轮 `static/` 发现两类问题，已保留日志和终止回执（exit -15，不计通过）：
错误地把资产配套条件写成产品规则，以及旧测试把 INSERT 总数写死为 29。
两个失败在 `reproduced_failures.log` 独立复现；修正后保留原 29 条并单独核验新增 9 条，
不改覆盖审计器，也不虚构负向用例。相关 26 项测试复跑通过，见 `focused_fixed.log`。
旧版 `preparation.json`、`regenerated/` 等保留为过程证据，当前版本使用带 `_fixed` 的记录。
第二轮 `static_fixed/` 又发现一项相同的旧总数断言，位于视图合同测试。
独立复现见 `view_count_failure.log`；修正后仍要求原 29 条、新增 9 条及原 10 条视图用例，
整个视图合同模块 10 项通过，见 `view_count_fixed.log`。
该轮也主动终止以统一冻结输入；不将终止分片计为通过，最终仍复跑原 111 个模块 / 946 项。

仍未覆盖：CHAR 补空格、VARCHAR(0)、TEXT(n)、跨 schema、转码、动态默认值，
严格/宽松模式的超长行为与目标 SQLSTATE。空串/NULL 区分与 Unicode 返回值仍待实机校准。
本轮不通过猜测错误码补负向清单，也不把生成器拒绝输入计为数据库负向测试通过。

下一步：按包整理连接数据库前的可执行准备缺口，优先共用合同和目标 Oracle；
数据库执行仍是单独授权、独立环境、代表性小批次，不直接运行全部快照。
当前有限写入审计保留的 20 条待复核中，16 条涉及视图/派生目标的 DEFAULT，4 条涉及
CASE/UNION 查询。先判断是专用合同证据尚未汇总，还是语义确实未证明，再决定最小适配；
不直接把这些标记改成通过，也不把它们当作全库唯一剩余缺口。
