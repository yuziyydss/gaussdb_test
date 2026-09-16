# CREATE FOREIGN TABLE：格式、OPTIONS 与本地输入资产

本轮只处理这个有限合同；没有连接数据库、部署文件、提交或推送。
INSERT 冲突键更新与通用 Fixture / Oracle 离线执行准备仍是后续任务。

## PDF 依据和边界

以本地 `gaussdb-rf-cent.pdf` 为准，SHA-256：
`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

- CREATE FOREIGN TABLE：物理页 1434–1437，正文 L52–87 描述 file_fdw 的选项；L101–111 的示例实际使用 log_fdw。
- COPY：物理页 1380–1387；正文 L231–247、L346–388、L428–487、L499–527 提供格式和分隔符、NULL、HEADER、QUOTE / ESCAPE 的限制。
- OPTIONS 的同层名称不能重复；列级与表级属于不同作用域。本轮仅实现表级有限选项，不把同名列选项一律判非法。
- 允许的完整选项仍取决于 FDW validator；本地静态检查不是远端 validator 的替代品。

| 分支 | 本轮处理 | 保留限制 |
| --- | --- | --- |
| log_fdw | 原目录示例不变；format=not_applicable 显式参与消费检查 | 不借此证明 file_fdw 或实际日志读取 |
| file_fdw TEXT | 新增无表头、两列 INTEGER 的真实 TSV 资产及候选 | 仅这一个有限布局，不证明所有 TEXT 输入 |
| file_fdw CSV | 新增无表头、无引号包裹的两列 INTEGER CSV 资产及候选 | 不覆盖引用字段、换行字段、NULL 数据、HEADER=true |
| BINARY | 仍保留缺口 | 未实现二进制字节协议，不能拿 UTF-8 文本冒充 |
| FIXED | 仍保留缺口 | COPY 要求 FORMATTER；外表本章未给出对应选项支持证据 |
| 其他 FDW | 不纳入本次正向生成 | 不把 file_fdw 规则推广到其他 wrapper |

## 从选择到 SQL

语法使用 `OPTIONS ({format}{table_options})`。文件格式值输出真实的
`format 'text', ` 或 `format 'csv', `，不再只作为未消费的标签。
生成后重新读取实际 SQL，检查格式与选择值一致；删除消费标记或改动格式会失败。

`core/file_fdw_options_contract.py` 检查选项结构、大小写不敏感的重复键、
未知/错作用域选项、格式适用性及有限文件布局。它还检查真实两列 DDL、
file_fdw server/schema setup、显式模式/文件访问门槛和逆序 RESTRICT 清理。
这是有限检查器，不是任意 SQL 的解析器。

CSV 目标示例（不可作为已获授权的执行脚本）：

```sql
CREATE FOREIGN TABLE g_cft_file_ns.rows (id INTEGER, qty INTEGER)
SERVER g_cft_file_server
OPTIONS (format 'csv',
         filename '/tmp/factor_assets/general/create_foreign_table/rows.csv',
         encoding 'UTF8', header 'false', delimiter ',',
         quote '"', escape '"', null '');
```

本地文件是 `specs/ddl/create_foreign_table/fixtures/assets/rows.csv`，内容为：

```text
1,10
2,20
3,30
```

Fixture 声明源文件 SHA-256、3 行、2 列、INTEGER 布局、计划中的服务器路径及
仅清理本次拥有且哈希匹配文件的条件。生成器核验真实本地字节；未向服务器复制。
TEXT 对应 `rows.tsv`，使用制表符。
新增 integer_csv 不能扩大旧 LOAD DATA 的文件合同：没有已评审的 CSV 外表 OPTIONS
时，生成器拒绝使用这种文件资产。

setup 创建新 server 和 schema，不伪造目标外表已存在；目标 CREATE 独立生成。
teardown 按外表、schema、server 的顺序显式 RESTRICT，禁止兜底 CASCADE。
执行时仍须记录每个对象是否由本次成功创建；静态 SQL 不证明清理所有权。
两个文件用例复用固定 server/schema 名称，后续执行必须独占并串行隔离，
或先实现一致的命名重写合同；当前不允许据此并发执行。

## Oracle 与执行状态

新增两个 planned 场景：目标 CREATE 后查询两列并按 id 排序，预期结果来自本地
文件的三行整数。它们尚未执行，也未完成远端 validator、权限及读取结果校准。
manifest 的 success / syntax_only 是有前置条件的候选预期，不是数据库通过结论；
当前模型对 success 输出的 oracle_status=confirmed 也不是实机校准回执。

通用离线执行准备器尚未扩展到这一 file_fdw 文件/所有权合同。
不能把文件存在、planned Oracle 或 fixture execution.status=ready 当成执行许可。
数据库授权、路径独占、文件部署/哈希/可读权限、validator、对象所有权均需独立证据。

## 验证与对账

- 正式产物：845 manifest、5,292 条候选；本轮新增 2 个单候选清单。
- 843 份旧 SQL 快照逐字不变；5,290 条旧候选的 SQL、ID、预期和生命周期不变。
- 两条旧 log_fdw 候选只新增 format 的消费元数据，不新增文件格式 SQL。
- CREATE FOREIGN TABLE 的 5 个格式取值缺口收敛至 BINARY / FIXED 两个；
  这只是有限取值覆盖，包不因此变成语义或行为全覆盖。
- 新增反例是静态回归：重复/错配 OPTIONS、错误 wrapper、门槛缺失、格式未消费、
  实际列型不匹配、文件路径/哈希/行列数/格式不一致，以及旧 LOAD DATA 误用 CSV。
  它们不是已执行的数据库负向用例，没有伪造 SQLSTATE。
- 审计脚本：`work/foreign_options_20260915/verify_result.py`；核验报告、旧候选、
  重构快照、四分片日志哈希、实际测试数以及前/后/当前输入一致性。
- 最终回执路径：`work/foreign_options_20260915/result.json` 与
  `static_final/shard_*/receipt.json`。只有实际生成且核验通过的回执才是完成证据。
- 本轮已完成上述核验：**128 个模块、1,063 项测试通过**；四分片分别为
  48 / 353 / 352 / 310，均 exit 0、OK，无跳过或 expected-failure。
  9,677 个被跟踪输入的前/后/当前哈希一致。这是受影响范围回归，不是全项目所有模块。
- 正式生成报告 SHA-256：
  `ef4d90c50bdd8d0836827343b72056e3101de8bc244db006004c5deec2dc923d`。
  初始缺少模块和绑定条件值导致的失败日志保留，不计入最终通过数。

## 下一步

先评审 INSERT 的冲突键更新：区分将键赋回 EXCLUDED 的相同冲突值与真正改成其他键值，
保留实际唯一索引、种子行、WHERE 过滤和重复键限制。不能把现有非键 tuple 更新
算成键更新已覆盖，也不能在没有合同的情况下直接修改原 SQL。
随后将本轮文件准备和目标 Oracle 接入独立离线准备器；不自动开启数据库执行。
