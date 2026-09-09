# M 第六批：分区、Hint 历史与回收站

本页数字记录本批和OM审阅包收尾时的历史状态；后续6包修正及最新1070条M普通SQL见[生成缺口收敛](M_COMPAT_GENERATION_GAPS.md)。旧专项证据保持原始结果。

本地 PDF 第二章剩余 11 章已定位并阅读，来源共 3362 行，11个命令均已正式建包。其中10包完成有限模型和累计静态审计；GENERATED UPDATE SYSTEM仅供审阅，缺少外部OM合同，不计入有限生成验收。没有连接或执行数据库，没有执行全局维护、升级或清理操作。

| 包 | SQL 数 | 本次有限范围 |
|---|---:|---|
| AUTOHINT | 6 | 两个真实整数表连接聚合、ANALYZE探索/历史、VERBOSE/DEBUG；TEST与SQLPATCH显式FALSE |
| AUTOHINT DROP | 2 | 两个精确查询签名；前置真实AUTOHINT探索，不伪称模型必然已创建 |
| AUTOHINT PURGE | 1 | 仅独占可丢弃实例，明确全历史作用范围，不用作fixture清理 |
| PURGE | 1 | 新建Schema→表→两行数据→DROP后，清理指定回收站表 |
| TIMECAPSULE TABLE | 4 | 真实BEFORE DROP/BEFORE TRUNCATE；DROP改名；TRUNCATE改名目标负向 |
| CREATE TABLE PARTITION | 30 | INTEGER/ASTORE；RANGE LESS THAN、START/END、LIST、HASH/KEY显式或自动分区；逆序上界目标负向 |
| CREATE TABLE SUBPARTITION | 22 | RANGE/LIST × HASH/KEY，单列键；显式/自动/隐式子分区；数量不匹配目标负向 |
| ALTER TABLE PARTITION | 19 | 真实三段RANGE源表；ADD/DROP/TRUNCATE/ANALYZE/RENAME/SPLIT/MERGE；逆序ADD目标负向 |
| ALTER TABLE SUBPARTITION | 6 | 真实RANGE-HASH源表；按名称或两个键值TRUNCATE/RENAME；每父分区一个子分区使种子归属确定 |
| ALTER TABLE | 41 | ADD/MODIFY/CHANGE、DEFAULT、NULL、CHECK、DROP、fillfactor、COMMENT、RENAME与SET SCHEMA；CHECK违反已有行目标负向 |
| GENERATED UPDATE SYSTEM | 0 普通用例；1 条审阅文本 | 内部OM接口；语法及已知环境限制正式入库，fixture未实现、scenario待执行、无ordinary manifest |

本批普通用例仍为132 SQL；M累计正式建包93/93，其中92包有通过有限审计的生成域，共1059 SQL。固定69项均已建包，68项通过有限模型验收、1项仅供审阅。全库注册317包，普通生成4980 case；通用224包、528 SQL快照哈希无变化。审阅文本不加入case计数；不能将建包齐全解释为全章因子、规则或数据库行为全覆盖。

## 真实前置与限制

AUTOHINT 的两表查询分别声明 `source_columns_by_table`，现有多表校验器会拒绝仅提供混合列清单。fixture 建表并插入真实数据，再以完全相同的查询执行探索候选，为 ANALYZE FALSE / DROP 提供历史生产步骤。实际是否产生模型、模型数量及推荐内容仍须未来运行器确认；没有把小数据集推断为必有性能提升。TEST FALSE 只关闭推荐结果验证，不保证探索不执行查询；SQLPATCH 是输出指令，不代表已安装补丁。

清理只使用精确查询的 AUTOHINT DROP，绝不用 AUTOHINT PURGE 兜底。文档的“0 MODELS REMOVE / 删除失败”未提供已校准 SQLSTATE，保留协议状态疑问，不把任意错误当作通过。全局 PURGE 候选要求整个实例无其他用户历史，Schema 隔离不足以满足这个条件。

PURGE fixture 在 setup 末尾 DROP 表，因此不把该表继续放进活表 `provides.tables`。TIMECAPSULE 的 DROP 与 TRUNCATE 使用不同前置状态；恢复后通过准确表名的 DROP TABLE ... PURGE 清理，避免再次入回收站。两个可用名称都须事先不存在，setup 失败不获准删除他人对象。若目标恢复失败，回收站残留必须另报，不能以 DROP SCHEMA 成功假定无残留。

CSN/TIMESTAMP 恢复必须运行时捕获真实恢复点及确认 UNDO 保留，当前未照抄 PDF 旧时间戳/CSN。TRUNCATE + RENAME 是按明确限制生成的负向用例，SQLSTATE 待校准。索引 PURGE 示例中的结果列表与操作存在疑点，未转换为固定成功断言。

CREATE TABLE PARTITION 显式 ASTORE，避免把默认 Ustore 与相关监控开关假设藏在 fixture 中。RANGE 上边界保持整数、升序；LIST 键集合不重叠，HASH/KEY 的显式数量匹配定义数。START(0) 会隐式创建 MINVALUE→0 分区，因此本例 3 个声明项对应预期 4 个实际分区，而不是直接按字符串计数。这个目录预期尚未实机验证。表空间、多列键、生成列、外键和索引交互仍独立保留缺口。

## 验证证据

- AUTOHINT/回收站专项联合 11/11，25.450 秒；CREATE PARTITION 专项 5/5，12.015 秒。
- 最新全量生成退出 0，4980 case。累计审计退出 0，3022/3022 非恒定维度可行 pair 被覆盖；全局 ID、包内 SQL、来源哈希及通用快照对账通过。
- 新增分区维护联合专项11/11（含原CREATE PARTITION 5项），ALTER TABLE专项6/6。首次ALTER加载因syntax事实误供scenario被严格拒绝；修正为DEFAULT维度值消费该事实，没有降低引用类型门禁。
- 完整M静态回归166/166，350.751秒，退出0；最新四包证据为 `generated/m_compat_batch_06/partition_alter_table_test_evidence.json`。这里的通过不是数据库实测。
- 第一次构建因来源锚点超出 EOF 被拒绝，改为实际 4 行；随后多表 profile 缺少逐表列契约被拒绝，修正规格，不降低生成门禁。
- `generated/m_compat_batch_06/utility_create_partition_test_evidence.json` 保存命令、作业、结果、失败与输入哈希。
- `generated/m_compat_remaining/progress.json` 是当前累计报告，`work/m_compat_remaining_69_20260908/queue.json` 保持固定 69 项分母。

```bash
GAUSSDB_ENABLED=false python3 scripts/build_m_compat_batch_06.py --update
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_autohint tests.test_m_compat_recyclebin tests.test_m_compat_create_partition -v
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_remaining.py
```

构建器仅输出待审补丁，需审阅应用；其余两个脚本只生成/审计离线产物。不得将 SQL 校对快照作为一个脚本整段执行。

## 新增 DDL 的契约边界

分区维护引用CREATE包的真实共享fixture，通过依赖拓扑只建一次表、逆序清理。RANGE源表上界10/20/30，ADD成功候选为40，负向为15；SPLIT点15位于中间分区内；MERGE只合并相邻分区。子分区FOR同时提供父键和子键，不猜测哈希路由；未将没有完整对象契约的EXCHANGE、表空间和全局索引维护混入成功域。

ALTER TABLE使用Schema限定的真实INTEGER表和两行数据；MODIFY扩到BIGINT、CHECK正向匹配种子，负向只违反指定CHECK。SET SCHEMA另有目标Schema fixture，清理覆盖移动后对象并逆序回收。fillfactor初始80支持真实RESET前置。仅对SET DEFAULT值引用CREATE TABLE的共享语法事实，不用它替代视图DEFAULT的M模式行为。

CHECK中NULL的描述差异、ADD DEFAULT是否重写的文案差异继续保留open question。生成列、字符集转换、所有权、分布节点和复杂依赖没有声称覆盖。目标错误类别保留，SQLSTATE仍待未来实机校准。

## 唯一剩余命令：GENERATED UPDATE SYSTEM

已读完整命令章并视觉核对PDF物理页2211，M语法没有通用模式的OBJECT后缀。另查upgrade_mode与gs_upgradectl章节：命令只供初始用户在真实OM升级阶段使用，并生成回滚脚本文件；文档警告不要自行修改upgrade_mode。现有PDF未明确该接口的产物路径/命名/归属、部分失败处理与可安全清理合同。

按用户确认，已将已知部分正式入库，不再让执行合同缺失阻止建包：

- `specs/utility/m_generated_update_system/`：factor、syntax、source、matrix、fixture、scenario共6个规格文件。没有参数可选项，不虚构组合维度。
- fixture明确为`planned / not_implemented`，setup/teardown不填伪SQL；生成器尝试编译该fixture时必须拒绝。
- matrix的OM升级与回滚文件特性均为`needs_profile`，scenario为`planned`。M建库/重连计划只是基础引用，不等同于真实OM升级前置。
- `generated/m_compat_review_only/m_generated_update_system/review.json`保存从正式AST渲染的SQL和环境限制；同目录`review.sql`整文件为注释，防止批量误执行。没有case_id、普通manifest或成功预期，不混入1059条测试SQL。
- 累计审计分别提供`registered_packages`与`registered_finite_packages`，本包只进入`registered_unaccepted_packages`。同时修正空manifest/零case被判生成完整的空集合漏洞。

可复建审阅产物：`GAUSSDB_ENABLED=false python3 scripts/generate_m_compat_review_only.py`。构建器、审阅导出、测试、累计审计都不执行数据库。

本次新6项与完整Factor Package V1回归联合54/54通过（676.654秒）；严格加载通过，新包6文件、6条已知事实、2项open question，14行来源均已入账（不等于原子性精审完成）。全量重新生成731个manifest、4980个case；累计审计核验93包注册、92包有限验收、1059条M普通SQL，通用528份SQL快照不变。`generated/m_compat_batch_06/generated_update_system_review_test_evidence.json`保留命令、输入哈希及首次5/6失败到修复后通过的证据。旧166项M回归属于上一轮，不声称在此轮重新运行。

仍需权威OM集成测试规范补齐前置阶段、文件产物及生命周期归属；这不是请求数据库执行授权。调查证据保存在 `work/m_compat_remaining_69_20260908/generated_update_system_review.json`，保留历史，不改写为已经完成全部验收。循环保持暂停，未擅自恢复。
