# M 第五批：维护、资源标签与审计策略

本批选取本地 PDF 第二章的 20 章，共 2458 行原文。截至本次检查点，20 个包完成有限抽取、生成和静态验收。三个 EXTENSION 包仅为内部接口的条件候选，支持文件与组件尚未验证，不是普通用户可用声明。LOAD DATA 的真实本地输入资产已定义，但服务器部署未发生。数据库未连接、未执行；所有 SQL 快照引用独立 M 建库、重连与模式确认计划。

## 当前交付

| 命令 | SQL 数 | 有限范围 |
|---|---:|---|
| ANALYZE | 9 | 指定真实表、普通/多列统计、缺失列目标负向 |
| VACUUM | 29 | 普通、有序 ANALYZE、括号选项及列列表关联负向 |
| REINDEX | 8 | 指定 INDEX/TABLE、FORCE；在线形式独立环境门禁 |
| LOCK | 13 | TABLE/TABLES、同模式表列表、NOWAIT、未支持锁模式目标负向 |
| SELECT INTO | 12 | 永久目标表、单一前置 INTO、真实 INTEGER 直接投影 |
| CREATE RESOURCE LABEL | 12 | 表、列、Schema、视图、同类列表及有限混合资源 |
| ALTER RESOURCE LABEL | 8 | ADD/REMOVE 四类资源，前置成员状态分别构造 |
| DROP RESOURCE LABEL | 4 | 真实已有标签、IF EXISTS、单/双标签 |
| CREATE AUDIT POLICY | 16 | 单个完整 PRIVILEGES/ACCESS 操作、真实标签、过滤与启停 |
| ALTER AUDIT POLICY | 20 | ADD/REMOVE、MODIFY、DROP FILTER、COMMENTS、启停 |
| DROP AUDIT POLICY | 2 | 单个真实已有策略及 IF EXISTS |
| ALTER DEFAULT PRIVILEGES | 19 | 当前创建者、专用Schema、表/序列权限域、真实初始授权与1条域错配负向 |
| CREATE EXTENSION | 4 | 内部接口；security_plugin、IF NOT EXISTS、WITH、安装Schema合同 |
| ALTER EXTENSION | 2 | 内部接口；真实TABLE成员ADD/DROP及相反初始状态 |
| DROP EXTENSION | 4 | 内部接口；仅本case创建扩展、IF EXISTS、缺省/RESTRICT |
| COPY | 48 | 真实表/整数查询到STDOUT；原生选项和括号选项分离 |
| CHECKPOINT | 1 | 无参数语法，明确不可用Schema隔离实例级刷新 |
| DROP OWNED | 4 | 新建专用角色的真实权限回收，不作为通用清理 |
| LOAD DATA | 25 | 真实三行两列 INTEGER TSV；空表/冲突表、字段/列名、跳行、SET DEFAULT/常量及两条目标负向 |
| CLEAN CONNECTION | 2 | 显式物理 M 库与新建 NOLOGIN 用户，缺省/CHECK，不生成 FORCE |

本批新增 242 条 SQL。累计 M 为 82/93 包、927 条 SQL；固定剩余 69 队列中 58 项达到有限静态验收，11 项未完成。全库 306 包、4848 条用例，通用 224 包的 528 份 SQL 快照哈希保持不变。这些是本检查点数字，后续以累计报告为准。

## 前置条件与语义边界

- VACUUM fixture 用真实 INSERT/DELETE 制造待维护表，不执行全库维护，不包在事务内。维护物理效果仍需另行验证。
- LOCK setup 启动事务，teardown 先 ROLLBACK 再删除本 case 表。并发冲突和等待不是单会话静态生成能证明的结果。
- REINDEX 在线候选要求确认非 PCR 的 B-tree/UB-tree 环境及顶层执行；不能从默认表存储推断已经满足。
- SELECT INTO 只复制当前投影的名称和类型，不推导 DEFAULT/NOT NULL 继承。PDF 物理页 2270/2271 中重复 INTO、2231 中锁文字与矩阵差异均保留为 open question。
- 标签依赖真实 Schema → 表 → 视图；修改标签的 ADD 前未包含目标，REMOVE 前已包含且保留其他成员。FUNCTION 资源尚未进入普通域。
- 审计策略依赖真实标签。REMOVE fixture 先创建基线策略、再 ADD 待删除操作；启用/禁用测试使用相反初始状态，DROP FILTER 前已有过滤条件。
- 清理严格为策略 → 标签 → 视图 → 表 → Schema，不使用 DROP OWNED/CASCADE 兜底，不删除其他 case 的目标。
- 策略权限限定 SYSADMIN，enable_security_policy=on 是环境门禁，fixture 不自动 SET/ALTER SYSTEM。DROP 的真实建策略前置复用 CREATE 导出的开关事实。
- CREATE 审计策略的多操作示例与主语法、ALTER 过滤示例额外括号，以及安全开关段落“脱敏策略”用词，都保留原文差异。当前只生成明确的有限分支，不靠猜测消除问题。

固定对象名需要未来运行器独占隔离空间，并先确认对象不存在；setup 失败不得运行目标 SQL 或清理他人对象。快照是校对产物，不应作为一个脚本直接执行。

新增边界：

- 默认ACL按表/序列各自权限集合约束；REVOKE前显式GRANT对应权限及再授权。teardown先按专用Schema恢复默认ACL，再删Schema和新建角色，不改全局默认权限或其他创建者。
- 扩展名称security_plugin来自PDF示例，不证明实际支持文件存在。三个包都有内部工具、enable_extension、支持文件/组件清单、可安装至指定Schema、可丢弃库且起始未安装等门禁；ALTER另需support_extended_features。静态生成没有核验这些外部条件，证据明确`extension_assets_verified=false`。不捏造版本、更新脚本或relocatable能力，不操作默认plpgsql，不下载或安装扩展。
- COPY只导出STDOUT，需未来COPY流协议运行器，不能用普通fetchall假验结果。原生参数与括号参数分开，HEADER仅CSV FALSE，表/查询投影有真实INTEGER源。COPY关于空字符串、NULL标记的原文差异保留open question。
- CHECKPOINT仅在未来单独授权的可丢弃实例校验；表的teardown不能撤销实例刷新，不宣称事务回滚可以隔离。
- DROP OWNED仅作为受测命令：专用新角色已有真实表/Schema权限，清理仍定向DROP表/Schema/角色；不把它推广为角色残留兜底。更广所有权删除、跨库和共享对象效果未建模。
- LOAD DATA 增加最小 `provides.files` 合同，只支持本批真实 INTEGER TSV：相对资产路径、SHA256、行列数、部署目标和仅清理已核验所属文件的要求。严格加载和生成均校验内容、路径边界、类型和引用；用例及 SQL 快照明确 `deployed=false`。旧执行器在连接前拒绝文件依赖用例，不自动部署，也不以假路径替代资产。主键 id 的 nullable 必须为 false。
- CLEAN CONNECTION 从 M 环境计划取得物理库名，不用 M CREATE DATABASE 的 Schema 语义替代。setup 先校验 current_database，再创建专用 NOLOGIN 用户；当前只测空目标会话的有限语法，不能据此宣称已验证断连或其他会话检测。

## 可复现验证

```bash
GAUSSDB_ENABLED=false python3 scripts/build_m_compat_batch_05.py --update
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_audit_policies tests.test_m_compat_resource_labels tests.test_m_compat_maintenance -v
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_remaining.py
```

构建器输出可审阅补丁，不直接修改规格；本轮重跑无差异。首11包联合测试18/18（37.569秒）；新增默认权限/扩展7/7（11.741秒），COPY/CHECKPOINT/DROP OWNED 6/6（11.879秒）。最新全量生成与累计审计退出0：2700/2700 非恒定维度可行pair被覆盖，无重复case ID/包内SQL，通用快照无变化。所有有限规则与值域来自本地正文，源码未精审、原子性及Oracle缺口不因此标绿。

- 首五包独立证据：`generated/m_compat_batch_05/maintenance_test_evidence.json`。
- 标签与审计策略及首五包联合回归：`generated/m_compat_batch_05/labels_audit_policies_test_evidence.json`。
- 默认权限/扩展：`generated/m_compat_batch_05/default_privileges_extensions_test_evidence.json`。
- COPY/CHECKPOINT/DROP OWNED：`generated/m_compat_batch_05/copy_checkpoint_drop_owned_test_evidence.json`。
- LOAD DATA/CLEAN CONNECTION/文件合同：`generated/m_compat_batch_05/load_clean_file_contract_test_evidence.json`。专项联合 24/24；完整 V1 初轮 45/46（611.152 秒），唯一失败是快照测试截取首行，无法保留 SQL 字面量内换行。修正测试读取完整语句块后，该项及新增两个解析回归 3/3（16.067 秒）；没有声称完整套件重新执行通过。SQL 未为迎合测试而改写。
- 当前累计证据：`generated/m_compat_remaining/progress.json`。
- 固定队列：`work/m_compat_remaining_69_20260908/queue.json`。

没有声称数据库通过率。success 的范围是 syntax_only，NOTICE、审计日志、状态目录、锁行为和负向 SQLSTATE 等仍待独立授权与校准。

## 下一步

第六批剩余 11 章正文已经拆出并校验，共 3362 行，位于 `work/m_compat_batch_06/corpus`。来源就绪不算模型完成。接下来推进 ALTER TABLE、分区/子分区、AUTOHINT、回收站和升级专用命令的真实依赖；升级接口不得伪造 OM 环境或产物清理。每 10 分钟续工调度保持启用，直到全部 69 项验收或出现必须由用户处理的真实阻塞。
