# 第四批抽取与有限域生成结果（2026-09-05）

## 结论与分母

**20/20 个新章节均已落盘并生成有限域候选。** 这次补齐剩余 13 章，没有另开下一批。
以本地冻结 PDF 为唯一正文依据；没有连接数据库、执行 SQL、修改实例或提交/推送 Git。

| 本批指标 | 数量 |
|---|---:|
| 主章原文行 | 2628 |
| source unit | 697 |
| confirmed fact | 724 |
| open question（含待实现的能力域） | 72 |
| manifest | 70 |
| SQL 候选 | 470 |
| 正向 / 目标负向 | 437 / 33 |
| planned scenario | 63 |
| 来源账本检查 / 有限生成域检查 | 20/20 / 20/20 |
| 严格全特性静态完成 / 数据库行为完成 | 0/20 / 0/20 |

来源检查指逐行账本、哈希、原子性及事实消费类型检查，不是“产品所有语义已经独立证明完整”。
有限生成域检查只针对本次选入 manifest 的值域和约束。Pairwise 覆盖所有可行参数对，
**不等于覆盖所有笛卡尔积组合，也不保证任意多参数交互或数据库执行成功**。
没有足够变化维度的清单使用 N/A，不伪报有交互覆盖。

## 20 个包的结果

| 新包 | Manifest | 候选 | 正向 / 负向 |
|---|---:|---:|---:|
| DECLARE | 2 | 8 | 8 / 0 |
| FETCH | 7 | 57 | 51 / 6 |
| MOVE | 7 | 74 | 65 / 9 |
| CLOSE | 3 | 4 | 3 / 1 |
| SHOW | 3 | 8 | 8 / 0 |
| SET | 11 | 77 | 75 / 2 |
| RESET | 1 | 6 | 6 / 0 |
| LOCK | 2 | 37 | 36 / 1 |
| SET CONSTRAINTS | 4 | 8 | 7 / 1 |
| CREATE TABLE AS | 5 | 37 | 36 / 1 |
| SELECT INTO | 1 | 26 | 26 / 0 |
| CREATE SYNONYM | 2 | 11 | 11 / 0 |
| ALTER SYNONYM | 1 | 1 | 1 / 0 |
| DROP SYNONYM | 4 | 15 | 11 / 4 |
| CREATE MATERIALIZED VIEW | 2 | 7 | 6 / 1 |
| REFRESH MATERIALIZED VIEW | 1 | 2 | 2 / 0 |
| DROP MATERIALIZED VIEW | 4 | 15 | 11 / 4 |
| ANALYZE / ANALYSE | 3 | 14 | 13 / 1 |
| REINDEX | 3 | 11 | 10 / 1 |
| EXPLAIN | 4 | 52 | 51 / 1 |
| 合计 | 70 | 470 | 437 / 33 |

本轮新增 13 包：1933 行正文、480 个 unit、503 个 confirmed fact、48 个 open question，
36 个 manifest、236 条候选（221 正向 / 15 负向）、30 个 planned scenario。
前轮七包的 234 条候选作为保留基线，不重复算为本轮新增成果。

全库重新生成结果：**55 个包、279 个 manifest、2653 个唯一 case_id、2626 种 SQL 文本**。
全库严格加载 942 个 YAML 文件。原有 27 种跨因子 BEGIN 文本重叠保留来源信息；
没有通过删除同文本的跨章证据来制造唯一性。

## 本轮关键实现与校对

### 事务约束

- LOCK 采用重复目标与八种锁模式；冲突矩阵对照 PDF 原页逐格记录，测试独立核对 64 格和对称性。
  普通正向候选实际编译 BEGIN/ROLLBACK；事务外负向使用独立表，不能只在参数上写一个状态标签。
- SET CONSTRAINTS 的事务外行为是“无效果”，不是和 LOCK 一样报错。
  DEFERRED → IMMEDIATE 的目标负向先创建可延迟唯一约束、插入待检查重复值，再测试转换；
  不把 setup 阶段失败算成目标约束报错。ALL 与具名列表使用不同 AST 分支。
- 锁模式正文与表格的两处表述差异、TRUNCATE 示例注释疑点、SQLSTATE 等仍保留问题。

### 查询建表

- CTAS 的表修饰符、别名、ENGINE、存储参数、ON COMMIT、查询及 DATA 子句按原文次序拼接。
  当前生成 SELECT/VALUES 两列整数域；EXECUTE 分支未纳入 PREPARE 正文，明确留在 needs_profile。
- ON COMMIT 候选只放临时表清单；ENGINE 单独要求既有 B 模式。
  同名对象正向 NOTICE 与目标负向分别建清单，不能靠 OR REPLACE 或吞异常蒙混。
- WITH NO DATA 的计划场景验证空数据、保留结构；CTAS 只复制第一次结果，不继承源表约束。
- SELECT INTO 的 INTO 位于投影之后、FROM 之前。重复投影始终两列，排序使用输出位置避免别名漂移。
  有限 LIMIT 样例要求确定排序，这只是 manifest 选样规则，不被写成数据库禁止无序 LIMIT 的规则。
- SELECT INTO 通过 Fixture 和限定 Fact 引用实际依赖 CREATE TABLE AS，不复制源表定义。
  ILM、TDE/自动清理完整参数域、M 隐式转换及复杂 INTO 查询组合保留缺口。

### 同义词

- CREATE SYNONYM 允许目标对象暂不存在；缺失目标仍为正向候选，不为提高通过率偷偷补对象。
- CREATE OR REPLACE 使用真实既有同义词前置；DROP 的 RESTRICT 负向使用真实依赖视图。
- ALTER SYNONYM 的目标新所有者和 Schema CREATE 权限由环境提供，不自动创建用户/角色。
  PUBLIC、远程引用及复杂对象类别不塞入普通正向集合。
- DROP SYNONYM 文档中的 DROP ANY SEQUENCE 权限名称疑点保留，没有凭经验改正文。

### 物化视图

- 基表显式为 ASTORE、segment=off，不依赖 CREATE TABLE 的默认存储类型。
  冻结 V1 的 provides 只表达普通表列契约；视图创建及存储属性通过 explicit SQL 和独立测试核对，
  没有临时增加加载器不支持的 views/storage 字段。
- CREATE MATERIALIZED VIEW 只列出 WITH DATA；没有套用 CTAS 的 WITH NO DATA。
  别名数量必须匹配查询列数，单别名/两投影列作为目标负向。
- REFRESH 同时准备全量与增量物化视图，再插入基表数据，保证真的存在“尚未刷新”状态。
  增量对象的定义引用本批 CREATE INCREMENTAL MATERIALIZED VIEW 补充正文。
- 实际依赖链为创建源表/全量视图 → REFRESH 的增量视图及变更数据 → DROP 的依赖视图。
  清理按逆序；同一 SQL 的不同状态不被混作同一个生成结果。

### 维护与计划

- ANALYZE 普通列统计与双括号联合统计分开；页面校验矩阵每行的三种校验能力分别记录事实。
  单索引不能加 CASCADE；VERIFY 只生成小型普通表/索引候选，带无并发业务 DML 的门禁。
  原文单括号示例与双括号联合统计语法存在歧义，未声称二者等价。
- REINDEX 普通域只用独占 Astore B-tree；CONCURRENTLY 正向不放事务内，
  事务内目标负向使用另一条真实索引，并有同一状态下普通 REINDEX 的正向对照；事务内本身不是非法值。整库/系统维护、故障注入和按后缀清实例对象没有生成。
- EXPLAIN 括号选项与传统顺序/ PERFORMANCE 分开。运行统计选项的正向组合要求启用 ANALYZE。
  所有受控目标（含 INSERT/UPDATE/DELETE）在事务中生成并配 ROLLBACK。
  不把 EXPLAIN ANALYZE 误当纯只读，不把计划开销和耗时写死成 Oracle。
- PLAN、OPTEVAL、完整 Hint/高级计划模式、复杂 statement 的覆盖仍需后续能力域与环境。

### 作者阶段发现并修正的问题

- 未渲染的“状态维度”不会自动消费其 Fixture；已将状态附在实际消费的目标值或清单引用上。
- explicit fixture 缺分号会导致导出的 SQL 脚本粘连：本轮全部补齐，并加独立回归测试。
- 拆分 EXPLAIN 可选项和多行示例的 source unit；矩阵表头与具体单元格分开，未用统一理由批量豁免。
- V1 不支持的 fixture 字段和 AST 属性读取在严格加载时暴露，改用已有模型及 AST choice，
  没有放宽 extra=forbid、约束校验或审计门槛。
- 作者重试次数未完整计数，不能报告零重试率；本轮没有独立盲审抽样，不虚报人工错误率。

## 前轮七包保留的保证

游标方向、NO SCROLL 及游标位置 Oracle 分开；回扫取决于计划，带环境门禁。
MOVE/FETCH/CLOSE 通过真实 Fact/Fixture 依赖 DECLARE，不用相关链接制造循环。
SET 各赋值分支不会漏出未选槽位，普通 GUC 右值匹配是局部选样规则；
RESET 是配置缺省值而非任意“恢复测试前值”。事务清理先回滚，再清理 CREATE SCHEMA 提供的对象。
完整 GUC、COLLATE、用户变量断开连接清理及 B 模式限定范围仍保留。

## 验收证据与边界

- 新增 13 包定向测试：**24/24 通过（4.213 秒）**，日志 `work/doc2spec/batches/batch_04/tests_remaining.log`。
- 最终全量测试（REINDEX 组合修正之后）：**229/229 通过（384.611 秒）**。
  日志：`work/doc2spec/batches/batch_04/tests_final_reindex_contract.log`。
  第一轮 `tests_final.log` 的 229/229（391.074 秒）仅作历史结果，不冒充最后一次验收。
- 全库严格加载：**942 文件 / 55 包**；全库重新生成：**279 manifest / 2653 唯一 case_id / 2626 种 SQL**。
- 第四批队列 43 项（20 新章 + 23 既有提供者）：**43 needs_review，0 pending/failed/blocked/in_progress**。
  本批 20 新章均正式复核过，task_envelope/lint/generate 返回 0，严格 audit 返回 1 并保留原因。
- 20 章逐包验证报告中的 70 个 manifest，其完整 cases（含前置/清理）与正式生成报告一致。
- 最终机器结果：`work/doc2spec/batches/batch_04/final_task_results.json`，记录逐包计数、依赖、问题、
  四阶段返回码、源/规格/生成报告/测试日志哈希；所有计数从实际产物重算并断言对账。
- 逐章证据：`work/doc2spec/batches/batch_04/verification/<factor>/`。
  SQL：`generated/factor_packages/<factor>/manifest_*.sql`。


所有新包保持 needs_review；全部 63 个场景保持 planned。严格 audit 返回 1 不是被隐藏的成功，
也不是“生成管道运行异常”：报告明确区分来源/有限域通过与完整特性/行为未完成。
目标负向有规则和错误类别，但 SQLSTATE/消息未实测，不标错误 Oracle 已验证。

可重跑：

```bash
python3 scripts/prepare_batch_03.py --batch-root work/doc2spec/batches/batch_04 --plan tests/data/batch_04.json
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 -m unittest discover -s tests -p 'test_batch_04*.py' -v
python3 -m unittest discover -s tests
```

SQL 在 `generated/factor_packages/<factor>/manifest_*.sql`。文件含 setup/test/teardown 和环境门禁，
是静态候选与目标负向合集，**不是可不加区分直接在共享数据库运行的整库脚本**。
章节范围见 [第四批计划](BATCH_04_EXTRACTION_PLAN.md)。本批处理结束后，可另行选择下一批；
不要为了把 strict coverage 改成 100% 而删除问题、降低 Oracle 或扩大默认执行权限。
