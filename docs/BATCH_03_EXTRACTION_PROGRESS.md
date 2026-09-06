# 第三批阶段结果（2026-09-05）

## 当前结果：20/20 个新包落盘，数据库行为未执行

最后新增 **ALTER VIEW、ALTER SEQUENCE、ALTER INDEX**，共 **31 个 manifest、139 条 SQL
候选（126 正向、13 负向）**。第三批累计 **20 个包、86 个 manifest、539 条候选**。
本批 20 个主章节均有来源账本和有限域生成结果，但不等于所有文档特性或行为全覆盖。

全库重新生成结果为 **35 个包、209 个 manifest、2183 个唯一 case_id、2156 种 SQL 文本**；
27 种跨章节 BEGIN 文本重叠保留来源信息。严格加载通过：676 个 YAML 文件。

| 本段章节 | Manifest | SQL 候选 | 仍未关闭的主要范围 |
|---|---:|---:|---|
| ALTER VIEW | 15 | 47 | 通用表达式/选项列表、失效重编译指南、目标错误 Oracle |
| ALTER SEQUENCE | 8 | 65 | 空修改语句的语义、完整数字域、缓存/锁/所有权生命周期及错误身份 |
| ALTER INDEX | 8 | 27 | 完整存储参数、并行/LPI、rowid/内部维护分支及目标错误身份 |

三章共 **687 行正文、159 个 source unit、156 个已确认事实、12 个 open question**。
来源行账本与原子性检查通过，已建模有限域的可行 pair 无遗漏；三个包均保留
`needs_review`，严格静态覆盖与行为覆盖均未完成。新增 22 个 planned scenario，未执行。

### 本段的语法与前置条件处理

- ALTER VIEW 按八类动作拆分 AST，COMPILE 分支不继承其他分支的 IF EXISTS。
  SET/RESET 使用结构化选项列表；列默认值按正文记录为“暂无实际意义”，没有编造 INSERT
  默认填充值的行为断言。移动模式复用 CREATE SCHEMA，视图复用 CREATE VIEW 两列源表。
- ALTER SEQUENCE 区分普通/LARGE 序列及 settings/owner 产生式。Fixture 明确调用 nextval，
  将已申请值固定为 101，再构造 MAXVALUE 必须大于 101 的边界；数值上限按 PDF 原页核实
  为普通序列 2^63−1、大序列 2^127−1。CACHE 极值只是静态候选，未在数据库尝试分配。
  MAXVALUE 相关候选保留顶层 autocommit 环境要求，不误引入 CREATE SEQUENCE 的其他可选项。
- ALTER INDEX 按普通、分区、REBUILD、表空间及可见性分支建模。分区用例使用真正的 LOCAL
  分区索引 Fixture；REBUILD 分支不带 IF EXISTS。表空间和角色要求外部预配置，不生成
  CREATE/DROP TABLESPACE、CREATE/DROP USER/ROLE 来擅自准备环境。
- VISIBLE/INVISIBLE 保留升级阶段和禁用关键字条件。GSIVALID/GSIUSABLE 等内部维护说明
  未被猜测成普通正向 SQL；rowid、完整存储参数和并行限制继续保留可追溯缺口。
- 13 条负向候选分别针对一个目标规则，错误身份仍为 `needs_verification`；没有凭空指定
  SQLSTATE，也没有将“任意执行错误”作为通过标准。

本段没有修改 V1 模型、核心生成器或数据库执行接口。新增 11 个纯生成层测试，检查数值边界、
独立重算序列 pair 集、COMPILE/REBUILD 分支、Fixture 拓扑与清理顺序、环境门禁和负向身份。
全库回归日志：`work/doc2spec/batches/batch_03/verification/tests_alter_final.log`。
最终运行 `python3 -m unittest discover -s tests`：**179/179 通过（278.027 秒）**。

本批审计分母固定为 20 个新包：来源账本 **20/20**、有限域生成 **20/20**、严格静态覆盖
**3/20**、行为覆盖 **0/20**。本地队列另含 14 个既有提供者，所以共 34 项：
3 项 `static_complete` 且快照未陈旧，31 项 `needs_review`，0 项 pending/in_progress/failed。
其中三个 ALTER 的来源信封、严格加载和生成检查均成功，审计因上述真实缺口返回待审核，
没有强行改成静态完成。没有连接数据库，没有提交或推送改动。

## 上一段记录：从 10/20 扩到 17/20

本段新增 **7 个包、28 个 manifest、178 条 SQL 候选（153 正向、25 负向）**。
第三批累计 **17/20 个包、55 个 manifest、400 条候选**；尚未抽取的三章是
ALTER VIEW、ALTER SEQUENCE、ALTER INDEX。不能将“包落盘”写成数据库行为完成。

上一段结束时全库为 **32 个包、178 个 manifest、2044 个唯一 case_id、2017 种 SQL 文本**。
27 种 BEGIN 跨章节来源重叠仍单独报告。605 个 YAML 文件严格加载通过。

| 本段章节 | Manifest | SQL 候选 | 严格静态门禁 |
|---|---:|---:|---|
| CREATE SCHEMA | 5 | 33 | 待审核：嵌入子命令、字符集完整域、错误身份 |
| ALTER SCHEMA | 6 | 16 | 待审核：字符集完整域、错误身份 |
| DROP SCHEMA | 3 | 18 | 待审核：依赖拒绝与缺失模式错误身份 |
| VALUES | 7 | 66 | 待审核：通用类型推导、分页组合、错误身份 |
| PREPARE | 3 | 17 | 待审核：通用参数类型解析、重名错误身份 |
| EXECUTE | 3 | 22 | 待审核：完整参数兼容域、错误身份 |
| DEALLOCATE | 1 | 6 | 静态审计通过；行为未执行 |

这七章共 **640 行正文、161 个 source unit**。逐行来源账本、原子性检查和有限值域生成
均通过；要求的可行 pair 无遗漏。`generation_model_complete` 是已建模有限域的结论，
不表示任意类型、任意嵌套深度、无限列表长度或所有文档行为全覆盖。
本段增加 23 个 planned scenario，未把场景文件数量算作执行覆盖。

### 本段的结构与前置条件

- CREATE SCHEMA 用 AST 区分按名称、按所有者、字符集三种产生式。内嵌命令只实现
  TABLE 和 TABLE → VIEW，视图显式引用 `fp_cs_new.t_cs_inline`，其余嵌入命令保留覆盖缺口。
- ALTER/DROP SCHEMA 通过 `requires_fixture_refs` 复用 CREATE SCHEMA 普通模式前置对象；
  非空模式、重名、缺失模式分别进入单规则负向。防篡改和 B/UTF8 字符集使用环境门禁，
  不创建数据库、不修改 GUC、不修改系统模式，也不自动创建或清理角色。
- VALUES 使用 AST 行列表、列列表、ORDER BY 列表与可选分页节点。当前为一/两行、一/两列
  代表域；约束跨行列数一致，DEFAULT 只进入 INSERT 上下文。未将类型名称相等当成完整公共类型推导。
- PREPARE 使用六个语句族分支和一/二参数类型列表，参数表达式有显式 INTEGER 上下文。
  VALUES 语法事实使用包级引用；EXECUTE/DEALLOCATE 复用 PREPARE 的固定签名与会话 Fixture。
- EXECUTE 保留原文“零参数预备语句忽略合法绑定”的特例；有声明参数才检查有限兼容契约。
  ROWNUM 单独生成负向，不与参数数量错误混为一个目标。
- 预备语句 Fixture 中的 `DEALLOCATE ALL` **只允许新建独占测试连接**，不得在共享/业务会话运行。
  SQL 快照保留 `session_ownership` 环境门禁，但注释不是执行器的强制隔离机制；未来实机执行仍需
  同一连接完成 setup/test/teardown，并落实独占连接和测试对象命名空间。
- PREPARE 的回滚后存活、EXECUTE 插入结果、DEALLOCATE 释放前后系统视图结果已写成 planned
  场景与明确结果集断言；没有声称这些 Oracle 已在数据库验证。

本段未修改 V1 模型、核心生成器或执行接口。新增 10 个纯生成层回归测试，包含独立重算
PREPARE 的 24 个有限组合的 pair 集、零参数绑定特例、行列契约、跨包 Fixture 顺序和环境门禁。
全库最终回归：`python3 -m unittest discover -s tests`，**168/168 通过（258.086 秒）**。
日志为 `work/doc2spec/batches/batch_03/verification/tests_schema_prepared_final.log`。
34 项本地队列中：3 项严格静态完成且快照未陈旧（ROLLBACK、ABORT、DEALLOCATE），
28 项 needs_review（含 14 个既有提供者），3 项 pending（剩余三个 ALTER）。
没有连接数据库，没有提交或推送改动。

## 上一段记录：从 1/20 扩到 10/20

本轮新增 **9 个因子包、26 个 manifest、219 条 SQL 候选**。
加上此前的 ROLLBACK，第三批已有 **10/20 个包落盘、222 条候选**。
这不是 20 章全部完成，也不是数据库验收通过。

本轮九章共 644 行正文、178 个 source unit。每章均通过来源映射、原子性、
有限值域生成和要求的可行 pair 审计；严格静态完成还要求解决未确认事实与负向 Oracle。
源行覆盖包含已映射单元、可解释的排版忽略和导航/示例收尾，不代表每行都生成 SQL。

上一段结束时全库为 **25 个包、150 个 manifest、1866 个唯一 case_id、1839 种 SQL 文本**。
27 种 BEGIN SQL 同时出现在 BEGIN 与 START TRANSACTION 章节，单独报告来源重叠，
不算生成错误，也不能据此声称多了 27 种独立 SQL 行为。

| 第三批已落地章节 | Manifest | SQL 候选 | 严格静态门禁 |
|---|---:|---:|---|
| ROLLBACK（此前） | 1 | 3 | 通过；行为未执行 |
| ABORT | 1 | 3 | 通过；行为未执行 |
| START TRANSACTION | 1 | 92 | 待审核：属性重复边界、语法/示例及跨章差异 |
| SAVEPOINT | 1 | 1 | 待审核：错误身份与故障场景前置条件 |
| RELEASE SAVEPOINT | 2 | 4 | 待审核：目标错误身份 |
| ROLLBACK TO SAVEPOINT | 2 | 12 | 待审核：目标错误身份 |
| SET TRANSACTION | 4 | 30 | 待审核：语法段和示例的联合属性写法 |
| DROP VIEW | 3 | 18 | 待审核：缺失对象和依赖拒绝错误身份 |
| DROP SEQUENCE | 7 | 35 | 待审核：遗漏 LARGE、依赖拒绝错误身份 |
| DROP INDEX | 5 | 24 | 待审核：在线限制、缺失对象错误身份 |

九个新包的 219 条中，187 条为正向候选、32 条为负向候选。负向均针对一个指定规则，
保留 `oracle_status: needs_verification`，没有凭空填写 SQLSTATE，也没有用“任意报错”验收。
全部包保留 `needs_review`。队列的 `static_complete` 与因子包的行为准备状态是不同概念。

## 抽取与生成中的关键处理

- START TRANSACTION 使用 AST 表达四种命令前缀与属性列表。当前有限域为不指定、
  单隔离级别、单访问模式、一个隔离级别与一个访问模式的两种顺序，共 23 种属性形态；
  四种前缀生成 92 条。重复同类属性、冲突属性、三个以上属性未被宣称全覆盖。
- SET TRANSACTION 的语法段只列一种属性，示例却同时指定两种。本轮仅生成单属性；
  B 兼容与 SESSION 简写所需 GUC 以 `environment_requirements` 保留。GLOBAL 会修改数据库
  后续会话默认值，没有独占环境、旧值恢复方案及执行授权时不得执行。
- 保存点组复用 START/BEGIN 的事务与表 Fixture，释放/回滚到保存点复用 SAVEPOINT 前置状态。
  跨包 Fixture 经本包 `requires_fixture_refs` 入口接入，不复制上游表结构；
  setup 按依赖顺序，teardown 逆序。SET TRANSACTION 的活动事务也复用 START Fixture。
- DROP VIEW/SEQUENCE/INDEX 使用 AST repeat 表达名称列表，当前只选一对象与两对象代表域。
  LARGE、缺失对象容忍、依赖拒绝、CONCURRENTLY 单索引/无 CASCADE 由约束过滤和单规则负向清单区分。
  不把两对象列表覆盖宣称为任意长度、任意标识符或全部对象形态覆盖。
- DROP INDEX 在线候选显式要求 autocommit；临时表、多会话、锁超时、死锁、取消与非法索引清理
  单列 planned scenario，未冒充普通表 Fixture 已覆盖这些行为。
- 九个新包登记 42 个 planned scenario。权限矩阵、可见性调度、资源观测和错误校准还需实现/验证；
  尤其“数据保留”不能证明 RELEASE 的内部资源已释放，所以资源观测单独列为待实现场景。

## 本轮对工具的最小修正

没有改变 V1 模型、组合算法或数据库执行接口。

`scripts/generate_factor_package_sql.py` 原先把 SQL 文本作为全库唯一性条件，导致两个正文都列出
BEGIN 时全库生成失败。现在仍要求 case_id 全局唯一、同一因子内 SQL 不重复；
跨因子的相同 SQL 在 `cross_factor_sql_overlaps` 中列出 factor/manifest/case 来源，
并增加 `distinct_sql_count`。不删文档分支、不静默去重，也不推断不同前置状态的行为等价。

SQL 快照现在同时输出环境门禁注释，避免 JSON 中的 B 模式或 autocommit 条件在导出时丢失。
注释不是数据库执行防护；这些文件仍标记 `static_only: true`。

## 验证与产物

- 全库严格加载通过；全量重新生成成功。
- 本轮 13 个新增测试覆盖：原子来源映射、Fixture 顺序、选项渲染、单属性边界、
  环境门禁、LARGE、负向未校准身份、独立重算 DROP INDEX 可行 pair，以及跨因子 SQL 来源重叠。
- 全库回归：`python3 -m unittest discover -s tests`，158 个测试通过。
- 没有连接数据库，没有执行 setup/test/teardown，没有提交或推送本轮改动。

可重跑：

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 -m unittest tests.test_batch_03_packages tests.test_generation_sql_provenance
python3 -m unittest discover -s tests
python3 scripts/manage_extraction_queue.py --state work/doc2spec/batches/batch_03/queue.json summary
```

产物位置：

- 规格：`specs/tcl/`、`specs/utility/set_transaction/`、`specs/ddl/drop_{view,sequence,index}/`。
- SQL：`generated/factor_packages/<factor>/manifest_*.sql`。
- 全库汇总及交叉来源：`generated/factor_packages/generation_report.json`。
- 各包覆盖结论：`generated/factor_packages/<factor>/coverage_audit.json`。
- 本地来源信封与队列检查证据：`work/doc2spec/batches/batch_03/verification/<factor>/`。

## 下一步

第三批不再有未抽取的新章节。下一批可继续选择 20～30 个代表性章节，并纳入实际依赖正文；
本批已登记的文档歧义、有限域缺口和行为场景单独进入审核队列，不阻塞简单章节继续抽取。
不可将这些待审核项改成“环境不支持”来消除缺口，也不可将静态生成候选视为数据库验收结果。
