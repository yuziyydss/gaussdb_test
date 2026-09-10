# 冲突更新源列合同：2026-09-09 下一轮

本轮在 `deb38ad` 的 DEFAULT 修复上继续收敛 INSERT 冲突更新。仅修改共享检查器与实际消费者，不改 Factor Package V1 结构，不改 SQL、取值域或预期，不连接数据库。

## 为什么需要这一轮

上一轮开始检查冲突更新中的 DEFAULT，但 `VALUES(note)`、`EXCLUDED.note` 还没有源列身份合同：混合 DEFAULT 会停在未知表达式；没有 DEFAULT 的冲突子句则可能被输入行检查掩盖。例如 `qty=VALUES(missing)` 以前仍会标为有限检查通过。

这里有两种不同的“行”：INSERT 提供的新行，以及唯一键冲突后要更新的已有行。`VALUES(qty)` 指向前者，不能把它直接替换为 `qty`，进而断言“分区键没有改变”或“更新结果等于原值”。

## 本地 PDF 依据

采用项目当前 V2.0-10.0.0 集中式来源，不沿用旧环境的行为结论。

| 来源 | 本轮依据 | 正文章节 SHA-256 |
| --- | --- | --- |
| 一般 INSERT，`general/dml/insert.txt` | L285–294、L315 的源行引用及 VALUES 使用范围；L469–473 的 PG ON CONFLICT 示例 | `5383f2eca79ecbe64ce3e880c8e3a2a39178a6bd93ca328401740bf36c16fae5` |
| M INSERT，`m_compat/dml/insert.txt` | L87–94、L104–107 的 VALUES 源行引用及使用范围 | `8bb5cd8bc169b34969fb1c4940bf113f87ac75e797896a6d7ca157cb8361f0b0` |

两份正文哈希均与对应 source.yaml 的 artifact_sha256 一致。一般正文记载 VALUES/EXCLUDED；本次审阅的 M 正文只有 VALUES 依据。因此 M EXCLUDED 保留待审，**不是断言数据库不支持它**。章节正文仍仅留本地。

## 有限实现和边界

复用已有 `check_assignments`、普通表 `_column_contract`、DEFAULT 和生成列保护，新增直接源列检查：

- `qty=VALUES(qty)`：仅在 ON DUPLICATE KEY UPDATE 内检查。
- `qty=EXCLUDED.qty`：只有一般章节证据范围内检查；目标表名或别名遮蔽 EXCLUDED 时待审。
- 必须有完整解析的普通表 DDL；源列和目标列必须存在，且为同名列。
- 元组与混合 DEFAULT 继续检查列数、生成列禁写、默认值和已知非空限制。
- `qty=VALUES(id)`、复合表达式、子查询、视图、派生目标、分区表和失效 DDL 不借用同列证据。
- 普通 UPDATE 的表达式解析器不新增 VALUES 函数，也不把 EXCLUDED 注册成通用表别名。

`conflict_input_same_column_types` 只表示声明列身份和同列类型检查，不表示完整值域、函数结果、唯一键仲裁、WHERE/RETURNING、更新行数、运行环境或目标错误 Oracle 已验证。未涉及 DEFAULT/源行引用的其他冲突表达式仍不因此获得新检查。

生成器的目标 SQL 检查、启用 fixture_write_contract 的 seed 检查，均按 factor 的 catalog 来源传递一般/M 范围。独立审计器按现有包 ID 的 `m_` 命名规则传递范围；这是来源选择，不是实测数据库模式。审计文件哈希也加入了该路由脚本，避免只追踪底层检查器而遗漏入口变化。

## 验收结果

初始 15 项新回归产生 13 项失败、1 项新参数缺失错误、1 项通过，复现了旧行为。随后补充生成列保护、未知来源范围，以及真实生成/seed 消费者回归，共新增 19 项测试。

- 最终 12 个相关模块：145 项通过，123.884 秒。
- 独立 M 写入审计模块：4 项通过，0.013 秒。
- 两组互不重复，合计 **149 项相关回归通过**；不是全项目测试或实机回归。
- 重新加载完整规格注册表，再生成一般/M INSERT、UPDATE 的 48 个 manifest、240 条用例。完整序列化字段逐条相同，包括 ID、SQL、参数、预期、Oracle 声明、环境条件、setup/teardown；Pairwise 完整性检查通过。
- 已有全库 generation_report.json 未改，SHA-256 仍为 `fee7f40f74d39366991c1058e0016761f72591d6a5a502b5a895826155073415`。

240 条用例的新旧写入检查结果：

| 变化 | 条数 | 含义 |
| --- | ---: | --- |
| checked → checked | 196 | 部分新增源列检查标签，仍不是实机证明 |
| needs_review → checked | 2 | 普通表上的 VALUES(note) + aux=DEFAULT 混合赋值补齐有限检查 |
| checked → needs_review | 4 | 1 条复杂表达式、2 条一般视图、1 条 M 视图；均为负向候选，保留原 SQL/预期 |
| needs_review → needs_review | 32 | 原有限边界继续保留 |
| rejected → rejected | 6 | 原静态矛盾保留，不自动证明负向 Oracle |

其中总共 16 条检查证据变化，但只有 6 条状态变化。没有删候选、改 expected 或把待审重分类为“不支持”。

全库 5060 条快照重新审计：4774 条不适用有限写入检查；适用的 286 条中，240 checked、40 needs_review、6 rejected。6 条 rejected 均不是正向候选，positive_rejected=0。这些数字**不能叫全库 SQL 通过率**。生命周期仍为 4730 needs_review、330 transaction_scoped；transaction_scoped 也不表示共享数据库安全执行获准。

## 重现与后续

专项回归：

```bash
GAUSSDB_ENABLED=false python3 -m unittest \
  tests.test_conflict_source_contract tests.test_conflict_default_contract \
  tests.test_default_target_contract tests.test_shared_column_contract \
  tests.test_generated_assignment_contract tests.test_finite_sql_contract \
  tests.test_finite_keyword_boundaries tests.test_finite_derived_targets \
  tests.test_m_compat_explicit_null_contract tests.test_m_compat_insert_target_contract \
  tests.test_m_compat_insert_generated tests.test_general_insert_pg_conflict \
  tests.test_m_compat_write_audit -q
```

可用 `scripts/audit_rendered_sql_contracts.py --output <本地报告路径>` 再审计快照。生成可用 `scripts/generate_factor_package_sql.py --factor insert --output-dir <独立目录>`，再分别换为 update、m_insert、m_update；不要用单包结果覆盖全库报告。

本地完整对照证据在 `work/conflict_source_round_20260909/final/`，包括 verification.json、rendered_contract_audit.json、带入口哈希的 cli_audit.json；work 不随代码发布。历史审计不冒充本轮重算结果。

后续优先处理真实消费者里尚未识别的 M INSERT 入口形态，将语句识别与共享列合同接起来；以已有候选和文档反例验收。复杂冲突表达式、视图可更新性、动态 DEFAULT、ALTER 后默认值状态及数据库 Oracle 分开推进，不在这一轮同时扩建。
