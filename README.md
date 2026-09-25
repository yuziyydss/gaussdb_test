# GaussDB 规格驱动 SQL 测试生成系统

本项目把 GaussDB 产品文档转换为可追溯、可静态校验的 Factor Package V1，再通过约束感知的组合生成器输出 SQL 测试用例。当前阶段聚焦“文档抽取 → 规格建模 → SQL 生成 → 静态覆盖审计”，默认不连接数据库。

公司内网文档无法外传时，从 [内网 AI 执行入口](INTRANET_AI_INSTRUCTIONS.md) 开始。完整批量流程见 [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)。

## 当前能力

- Factor Package V1：每条 SQL 语句使用一个自包含目录，统一管理 source ledger、factor、syntax、manifest、matrix、fixture 和 scenario。
- 严格规格加载：未知字段、重复 ID、悬空引用、非法值域和无法编译的约束都会阻止加载。
- 有限展开的结构化 AST：支持顶层多产生式、choice、optional、repeat、subgrammar 和受控嵌套；不把有限层代表误报为递归语法域全覆盖。
- 结构契约：校验列数、列类型、GROUP BY/ORDER BY、集合运算、INSERT 输入和索引键能力。
- 约束感知 Pairwise：先计算可行组合，再覆盖全部可行参数对；生成后验证缺失 pair 和重复 case ID。
- Fixture 与目标错误 Oracle：生成 setup/test/teardown，并为负向用例保存目标错误类别、SQLSTATE 候选集或错误正则。
- Source Unit 覆盖账本：逐行记录原文处置，并审计 source unit 原子性、fact 消费和值域覆盖。
- 离线内网任务队列：支持 SHA-256 对账、任务认领、断点续跑、失败恢复和与 AI 厂商无关的任务文件。
- Web/API：浏览 V1 factor、manifest、覆盖报告和生成 SQL。
- 生成缺口诊断：在因子详情展开“为什么未完整”，区分条件取值、规则覆盖、生成异常和待校准Oracle；总览、API和Markdown同口径，见[诊断说明](docs/GENERATION_DIAGNOSTICS.md)。
---

## 项目当前记录（2026-09-14，更新于09-22；非全库验收结论）

### 规模

| 指标 | 数值 |
|---|---|
| PDF覆盖 | 5,686页 全部大部 |
| 参考事实记录 | 885条（67个YAML文件；8组裸ID重名，使用文件名::ID区分；不等于生成器已接入） |
| 因子包 | 317个（224 general + 93 M兼容） |
| manifest | 797份 |
| 候选SQL | 5,250条（静态生成，不代表实机通过） |
| M包source extraction | 93/93 完成 |
| Value gaps | 0条（生成模型闭合；8包保留no-manifest disposition） |

### 结构化知识库

| 类别 | Facts数 | 深度 |
|---|---|---|
| Oracle高级包（22个） | 170 | 接口签名+参数+行为示例 |
| Oracle PL/SQL语法 | 19 | 操作符/类型/控制/SQL/触发器 |
| Oracle系统函数 | 22 | 逐函数差异+SQL示例 |
| Oracle系统视图 | 17 | ALL→DB/DBA→ADM映射 |
| Oracle查询/JDBC/DDL | 22 | 含PRIOR/条件/驱动差异 |
| M模式数据类型 | 21 | 数值/日期/字符串/二进制 |
| M模式操作符 | 25 | 比较/逻辑/正则/索引走行 |
| M模式系统函数 | 35 | 逐函数差异+SQL示例 |
| M模式JSON/加密/转换 | 14 | CAST/COALESCE/JSON |
| M模式SQL DDL/DML | 14 | 逐语句差异 |
| M模式DCL/权限 | 11 | SET/GRANT/权限类型 |
| behavior_compat SQL | 26 | 设置前后完整对比 |
| MySQL B模式 | 18 | 完整兼容性 |
| 运行参数 | 116 | 6大类全覆盖 |
| 系统表/视图 | 78 | 核心目录+DBE_PERF |
| 存储过程 | 54 | 游标/基本/控制/动态/高级包 |

### 可执行验证脚本

| 脚本 | 测试数 | 用途 |
|---|---|---|
| `docs/minimal_validation_script.sql` | 10 | 核心链路验证（5分钟） |
| `docs/extended_validation_script.sql` | 100 | 全面功能验证（30分钟） |

```bash
gsql -d <dbname> -p <port> -f docs/minimal_validation_script.sql
gsql -d <dbname> -p <port> -f docs/extended_validation_script.sql
```

### 关键文档

| 文档 | 内容 |
|---|---|
| [FULL_DOCUMENT_CATALOG.md](docs/FULL_DOCUMENT_CATALOG.md) | 权威全书目录：5,637/5,637正文页覆盖、515个唯一章节、83个来源catalog |
| [EXECUTION_VALIDATION_PLAN.md](docs/EXECUTION_VALIDATION_PLAN.md) | 三阶段实机验证方案 |
| [PROJECT_DELIVERY_REPORT_20260914.md](docs/PROJECT_DELIVERY_REPORT_20260914.md) | 完整交付报告 |
| [FACT_INTEGRATION_PLAN.md](docs/FACT_INTEGRATION_PLAN.md) | Facts接入计划 |
| [VALUE_GAP_DISPOSITION_20260911.md](docs/VALUE_GAP_DISPOSITION_20260911.md) | 缺口处置记录 |
| [M_STRING_PACKAGES_20260915.md](docs/M_STRING_PACKAGES_20260915.md) | M INSERT/UPDATE 字符串合同：17条正式候选、来源与离线场景绑定；未执行数据库 |
| [SEMANTIC_REVIEW_20260915.md](docs/SEMANTIC_REVIEW_20260915.md) | 三包来源原子性、视图 DEFAULT 边界、CASE/UNION 独立类型审计 |
| [FOREIGN_OPTIONS_CONTRACT_20260915.md](docs/FOREIGN_OPTIONS_CONTRACT_20260915.md) | file_fdw TEXT/CSV 格式与 OPTIONS、真实本地文件、保留 BINARY/FIXED 缺口 |
| [INSERT_KEY_EXECUTION_PREPARATION_20260916.md](docs/INSERT_KEY_EXECUTION_PREPARATION_20260916.md) | PG同键元组与file_fdw有限合同的离线执行准备、目标所有权与Oracle身份校验；未执行数据库 |
| [PDF_QUALITY_BATCH_20260917.md](docs/PDF_QUALITY_BATCH_20260917.md) | DROP FOREIGN TABLE有限CASCADE语法代表；关闭值域缺口，保留依赖行为缺口 |
| [PDF_QUALITY_BATCH_20260917_ACTIVE_PAGES.md](docs/PDF_QUALITY_BATCH_20260917_ACTIVE_PAGES.md) | USTORE LOCAL索引ACTIVE_PAGES有限语法代表；关闭值域缺口，保留统计/执行行为缺口 |
| [PDF_QUALITY_BATCH_20260917_IO_PRIORITY.md](docs/PDF_QUALITY_BATCH_20260917_IO_PRIORITY.md) | CREATE RESOURCE POOL的IO_PRIORITY四值域；保留阈值冲突与MAX_DOP缺口 |
| [PDF_QUALITY_BATCH_20260917_ALTER_IO_PRIORITY.md](docs/PDF_QUALITY_BATCH_20260917_ALTER_IO_PRIORITY.md) | ALTER RESOURCE POOL的IO_PRIORITY四值域；保留90%阈值冲突与MAX_DOP缺口 |
| [PDF_QUALITY_BATCH_20260917_IO_LIMITS.md](docs/PDF_QUALITY_BATCH_20260917_IO_LIMITS.md) | ALTER RESOURCE POOL的IO_LIMITS上下界代表；不宣称全整数域或调度行为 |
| [PDF_QUALITY_BATCH_20260917_MEMORY_LIMITS.md](docs/PDF_QUALITY_BATCH_20260917_MEMORY_LIMITS.md) | CREATE RESOURCE POOL的MEMORY_LIMIT上下界与中间代表；不宣称内存行为 |
| [PDF_QUALITY_BATCH_20260917_ALTER_MEMORY_LIMITS.md](docs/PDF_QUALITY_BATCH_20260917_ALTER_MEMORY_LIMITS.md) | ALTER RESOURCE POOL的MEMORY_LIMIT三个standalone代表；保留多租与MAX_DOP缺口 |
| [PDF_QUALITY_BATCH_20260917_ACTIVE_STATEMENTS.md](docs/PDF_QUALITY_BATCH_20260917_ACTIVE_STATEMENTS.md) | ALTER RESOURCE POOL的ACTIVE_STATEMENTS边界与中间代表；不宣称并发行为 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_FDW.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_FDW.md) | COMMENT外部服务器与外表两个有限对象代表；保留FDW运行时与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_DOMAIN.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_DOMAIN.md) | COMMENT DOMAIN一个有限对象代表；保留domain行为与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TEXT_ALL.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TEXT_ALL.md) | COMMENT四类文本有限域闭合；保留目录Oracle与对象缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_OPERATOR.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_OPERATOR.md) | COMMENT OPERATOR一个双目INTEGER有限对象代表；保留其他arity和目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_CAST.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_CAST.md) | COMMENT CAST一个函数转换有限对象代表；保留转换行为与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TRIGGER.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TRIGGER.md) | COMMENT TRIGGER一个BEFORE INSERT有限对象代表；保留触发行为与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TSDICTIONARY.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TSDICTIONARY.md) | COMMENT TEXT SEARCH DICTIONARY一个Simple词典代表；保留词典行为与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_ROLE.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_ROLE.md) | COMMENT ROLE一个NOLOGIN/DISABLE独占角色代表；保留权限行为与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TSCONFIG.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TSCONFIG.md) | COMMENT TEXT SEARCH CONFIGURATION一个default解析器代表；保留分词/映射与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_FDW.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_FDW.md) | COMMENT FOREIGN DATA WRAPPER一个NO HANDLER/NO VALIDATOR代表；保留FDW行为与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_DATABASE.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_DATABASE.md) | COMMENT DATABASE一个独占新建数据库代表；保留模板/连接/回收站与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_EXTENSION.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_EXTENSION.md) | COMMENT EXTENSION一个事务内专用测试扩展代表；保留扩展脚本/依赖与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TABLESPACE.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TABLESPACE.md) | COMMENT TABLESPACE一个空RELATIVE表空间代表；保留磁盘/IO/目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TEXT_SEARCH_BUILTIN.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TEXT_SEARCH_BUILTIN.md) | COMMENT TEXT SEARCH PARSER/TEMPLATE两个内置对象代表；保留分词/模板与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_OPERATOR_CLASS_FAMILY.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_OPERATOR_CLASS_FAMILY.md) | COMMENT OPERATOR CLASS/FAMILY一个事务内btree代表；保留索引契约与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_TABLESPACE_FRESH_RELATIVE.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_TABLESPACE_FRESH_RELATIVE.md) | CREATE TABLESPACE一个专用RELATIVE代表；保留磁盘/IO/目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_OPERATOR_CLASS_FRESH_FUNCTION.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_OPERATOR_CLASS_FRESH_FUNCTION.md) | CREATE OPERATOR CLASS一个事务内FUNCTION 1代表；保留索引契约与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_TABLESPACE_FRESH_EMPTY.md](docs/PDF_QUALITY_BATCH_20260919_DROP_TABLESPACE_FRESH_EMPTY.md) | DROP TABLESPACE一个专用空RELATIVE代表；保留空表空间/目录清理与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_GROUP_FRESH_GROUP.md](docs/PDF_QUALITY_BATCH_20260919_DROP_GROUP_FRESH_GROUP.md) | DROP GROUP一个专用NOLOGIN/DISABLE组代表；保留管理工具上下文与目录Oracle缺口 |
| [PDF_QUALITY_BATCH_20260919_ALTER_TABLESPACE_FRESH_RENAME.md](docs/PDF_QUALITY_BATCH_20260919_ALTER_TABLESPACE_FRESH_RENAME.md) | ALTER TABLESPACE一个专用空RELATIVE重命名代表；保留属主/限额/文件生命周期缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_MODEL_FRESH_LOGISTIC.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_MODEL_FRESH_LOGISTIC.md) | CREATE MODEL一个静态logistic语法代表；保留训练/资源/所有权与预测缺口 |
| [PDF_QUALITY_BATCH_20260919_PREDICT_BY_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_PREDICT_BY_FRESH_SYNTAX.md) | PREDICT BY一个静态语法代表；保留训练模型、特征契约与预测行为缺口 |
| [PDF_QUALITY_BATCH_20260919_SHUTDOWN_FRESH_MODES.md](docs/PDF_QUALITY_BATCH_20260919_SHUTDOWN_FRESH_MODES.md) | SHUTDOWN三个静态模式语法代表；保留节点关闭、重启与恢复行为缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_MODEL_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_MODEL_FRESH_SYNTAX.md) | DROP MODEL一个静态语法代表；保留训练模型、目录身份与删除行为缺口 |
| [PDF_QUALITY_BATCH_20260919_ALTER_SYSTEM_SET_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_ALTER_SYSTEM_SET_FRESH_SYNTAX.md) | ALTER SYSTEM SET一个静态resource_manager_plan代表；保留多租切换与恢复缺口 |
| [PDF_QUALITY_BATCH_20260919_ALTER_GLOBAL_CONFIGURATION_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_ALTER_GLOBAL_CONFIGURATION_FRESH_SYNTAX.md) | ALTER GLOBAL CONFIGURATION一个静态键值代表；保留全局upsert与恢复缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_GLOBAL_CONFIGURATION_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_GLOBAL_CONFIGURATION_FRESH_SYNTAX.md) | DROP GLOBAL CONFIGURATION一个静态键名代表；保留存在性、删除与恢复缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_CLIENT_MASTER_KEY_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_CLIENT_MASTER_KEY_FRESH_SYNTAX.md) | DROP CLIENT MASTER KEY一个静态CMK名代表；保留存在性、依赖与外部密钥缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_COLUMN_ENCRYPTION_KEY_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_COLUMN_ENCRYPTION_KEY_FRESH_SYNTAX.md) | DROP COLUMN ENCRYPTION KEY一个静态CEK名代表；保留存在性、依赖列与外部密钥缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_LLM_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_LLM_FRESH_SYNTAX.md) | DROP LLM一个静态模型名代表；保留模型注册、所有权与目录身份缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_CLIENT_MASTER_KEY_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_CLIENT_MASTER_KEY_FRESH_SYNTAX.md) | CREATE CLIENT MASTER KEY一个静态user_token代表；保留驱动、管理器能力与外部密钥缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_COLUMN_ENCRYPTION_KEY_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_COLUMN_ENCRYPTION_KEY_FRESH_SYNTAX.md) | CREATE COLUMN ENCRYPTION KEY一个静态CEK代表；保留驱动、管理器兼容与长度边界缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_DATABASE_LINK_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_DATABASE_LINK_FRESH_SYNTAX.md) | DROP DATABASE LINK一个静态私有连接名代表；保留存在性、IF EXISTS与公共/私有行为缺口 |
| [PDF_QUALITY_BATCH_20260919_REFRESH_SYSTEM_OBJECT_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_REFRESH_SYSTEM_OBJECT_FRESH_SYNTAX.md) | REFRESH SYSTEM OBJECT一个固定命令静态代表；保留升级上下文与目录恢复缺口 |
| [PDF_QUALITY_BATCH_20260919_TIMECAPSULE_DATABASE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_TIMECAPSULE_DATABASE_FRESH_SYNTAX.md) | TIMECAPSULE DATABASE一个静态库名代表；保留回收站身份、跨连接恢复与权限缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_WEAK_PASSWORD_DICTIONARY_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_WEAK_PASSWORD_DICTIONARY_FRESH_SYNTAX.md) | DROP WEAK PASSWORD DICTIONARY一个固定命令静态代表；保留全局字典清空与恢复缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_WEAK_PASSWORD_DICTIONARY_FRESH_SINGLE.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_WEAK_PASSWORD_DICTIONARY_FRESH_SINGLE.md) | CREATE WEAK PASSWORD DICTIONARY一个单值静态代表；保留全局写入、去重与多值歧义缺口 |
| [PDF_QUALITY_BATCH_20260919_CREATE_PLUGGABLE_DATABASE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_CREATE_PLUGGABLE_DATABASE_FRESH_SYNTAX.md) | CREATE PLUGGABLE DATABASE一个无选项静态代表；保留资源生命周期与选项组合缺口 |
| [PDF_QUALITY_BATCH_20260919_DROP_PLUGGABLE_DATABASE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_DROP_PLUGGABLE_DATABASE_FRESH_SYNTAX.md) | DROP PLUGGABLE DATABASE一个破坏性语法静态代表；保留PDB关闭、资源指令与数据恢复缺口 |
| [PDF_QUALITY_BATCH_20260919_ALTER_PLUGGABLE_DATABASE_FRESH_OPEN.md](docs/PDF_QUALITY_BATCH_20260919_ALTER_PLUGGABLE_DATABASE_FRESH_OPEN.md) | ALTER PLUGGABLE DATABASE一个OPEN动作静态代表；保留PDB状态机与资源指令缺口 |
| [PDF_QUALITY_BATCH_20260919_EXPDP_TABLE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_EXPDP_TABLE_FRESH_SYNTAX.md) | EXPDP TABLE一个静态表导出语法代表；保留目录、备份工具与恢复契约缺口 |
| [PDF_QUALITY_BATCH_20260919_IMPDP_TABLE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_IMPDP_TABLE_FRESH_SYNTAX.md) | IMPDP TABLE一个静态表导入语法代表；保留目录、备份工具与恢复契约缺口 |
| [PDF_QUALITY_BATCH_20260919_IMPDP_TABLE_PREPARE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_IMPDP_TABLE_PREPARE_FRESH_SYNTAX.md) | IMPDP TABLE PREPARE一个静态准备语法代表；保留目录、备份工具与恢复契约缺口 |
| [PDF_QUALITY_BATCH_20260919_EXPDP_DATABASE_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260919_EXPDP_DATABASE_FRESH_SYNTAX.md) | EXPDP DATABASE一个静态数据库导出语法代表；保留目录、备份工具与恢复契约缺口 |
| [PDF_QUALITY_BATCH_20260923_STATIC_COVERAGE_CLOSURES_LXI.md](docs/PDF_QUALITY_BATCH_20260923_STATIC_COVERAGE_CLOSURES_LXI.md) | UPDATE/GRANT与剩余静态缺口收窄到原文边界；static coverage升至309/317，generation model 309/309 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LX.md) | ALTER DATABASE LINK补无凭据USING timeout语法；static coverage升至237/309 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LIX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LIX.md) | CREATE SECURITY LABEL收窄到原文确认负向错误；static coverage升至236/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LVIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LVIII.md) | CREATE CLIENT MASTER KEY扩展五种user_token算法；static coverage升至235/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LVII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LVII.md) | ALTER RESOURCE POOL补MAX_DOP语法代表并保留扩展边界；static coverage升至234/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LVI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LVI.md) | CREATE RESOURCE POOL补MAX_DOP语法代表并保留扩容边界；static coverage升至233/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LV.md) | CREATE OPERATOR CLASS用有限FUNCTION facet代表条件语法槽位；static coverage升至232/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LIV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LIV.md) | ALTER PACKAGE补四种COMPILE语法代表；static coverage升至231/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LIII.md) | EXPLAIN AUTOHINT补1个内核语法代表与2个原文负向错误；static coverage升至230/308 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LII.md) | CLUSTER确认首次省略USING的原文错误与运行时边界；static coverage升至229/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_LI.md) | REVOKE确认对象族与有效权限运行时边界；static coverage升至228/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_L.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_L.md) | CREATE TYPE、ALTER EXTENSION、COMMENT与CREATE TABLE确认环境或来源限制；static coverage升至227/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLIX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLIX.md) | CREATE PROCEDURE、M PREPARE、CREATE FUNCTION与VACUUM确认环境或来源限制；static coverage升至223/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLVIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLVIII.md) | ALTER PROCEDURE、CREATE OPERATOR、文本搜索字典与CREATE SYNONYM确认环境或来源限制；static coverage升至219/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLVII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLVII.md) | CLEAN CONNECTION、ALTER DATABASE、CREATE RULE与M SET确认环境或来源限制；static coverage升至215/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLVI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLVI.md) | CREATE ROLE、ALTER INDEX、CURSOR与ALTER TYPE确认环境或来源限制；static coverage升至211/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLV.md) | ALTER ROLE/USER、CREATE CAST与CREATE EXTENSION确认环境或来源限制；static coverage升至207/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLIV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLIV.md) | BEGIN、CREATE AGGREGATE、PDB与SELECT INTO确认环境或来源限制；static coverage升至203/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLIII.md) | CREATE FDW、SHOW、ALTER FUNCTION与ALTER USER MAPPING确认环境或来源限制；static coverage升至199/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLII.md) | CREATE RESOURCE LABEL、RLS、CREATE USER与DROP DATABASE确认环境或来源限制；static coverage升至195/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XLI.md) | CALL、CEK、CREATE EVENT与CREATE MASKING POLICY确认环境或来源限制；static coverage升至191/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XL.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XL.md) | SAVEPOINT、M SELECT与两个文本搜索维护包确认环境或来源限制；static coverage升至187/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXIX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXIX.md) | DROP SECURITY LABEL、ALTER FOREIGN TABLE、REPLACE与CREATE USER MAPPING确认环境或来源限制；static coverage升至183/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXVIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXVIII.md) | ALTER DEFAULT PRIVILEGES/EVENT/MASKING POLICY/SESSION确认环境或来源限制；static coverage升至179/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXVII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXVII.md) | CREATE TEXT SEARCH CONFIGURATION、CREATE TABLE PARTITION、INSERT ALL与COPY确认环境或来源限制；static coverage升至175/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXVI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXVI.md) | ALTER FDW、ALTER SERVER、CREATE AUDIT POLICY与SECURITY LABEL ON确认环境或来源限制；static coverage升至171/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXV.md) | PREPARE TRANSACTION、RESET、SNAPSHOT与LOAD DATA确认环境或来源限制；static coverage升至167/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXIV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXIV.md) | ALTER AGGREGATE、CREATE PACKAGE、COMMIT PREPARED与RENAME TABLE确认环境或来源限制；static coverage升至163/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXIII.md) | DROP RULE/TRIGGER/USER/USER MAPPING确认依赖或运行时环境限制；static coverage升至159/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXII.md) | CREATE WEAK PASSWORD DICTIONARY、DROP FUNCTION/RESOURCE POOL/ROLE确认环境或来源限制；static coverage升至155/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXXI.md) | CREATE LLM、DECLARE、DROP AGGREGATE与DROP FOREIGN TABLE确认环境或来源限制；static coverage升至151/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXX.md) | ALTER AUDIT/RLS POLICY、CREATE SERVER与CREATE DIRECTORY确认环境或来源限制；static coverage升至147/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXIX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXIX.md) | ALTER MATERIALIZED VIEW/SYNONYM/TRIGGER/GROUP确认环境或来源限制；static coverage升至143/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXVIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXVIII.md) | ALTER TABLE PARTITION、CREATE MODEL、CREATE TABLESPACE与ROLLBACK PREPARED确认环境或来源限制；static coverage升至139/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXVII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXVII.md) | M GENERATED UPDATE SYSTEM、DO、分区投影与DROP MASKING POLICY确认环境或来源限制；static coverage升至135/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXVI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXVI.md) | ALTER TABLE SUBPARTITION/TABLESPACE、AUTOHINT与IMPDP PDB CREATE确认环境或来源限制；static coverage升至131/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXV.md) | 文本搜索DROP、REFRESH MATERIALIZED VIEW与CREATE TABLE SUBPARTITION确认环境限制；static coverage升至127/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXIV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXIV.md) | PURGE、REASSIGN OWNED、SHOW EVENTS与TIMECAPSULE TABLE确认环境限制；static coverage升至123/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXIII.md) | DROP RESOURCE LABEL/弱口令字典、REFRESH SYSTEM OBJECT与TIMECAPSULE DATABASE确认环境限制；static coverage升至119/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXII.md) | DROP OWNED/PACKAGE/SERVER/TYPE确认依赖或作用域环境限制；static coverage升至115/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XXI.md) | DROP DBLink/EXTENSION/FDW/PDB确认依赖或破坏性清理环境限制；static coverage升至111/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XX.md) | DROP LLM/MODEL、PREDICT BY与SHUTDOWN确认运行时环境限制；static coverage升至107/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XIX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XIX.md) | 七个EXPDP/IMPDP包确认备份恢复环境限制；static coverage升至103/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XVIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XVIII.md) | AUTOHINT DROP MODEL、DROP CMK/CEK与DROP GLOBAL CONFIGURATION确认运行时环境限制；static coverage升至96/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XVII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XVII.md) | 四个参数化命令包复用有限语法代表并确认运行时环境限制；static coverage升至92/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XVI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XVI.md) | 四个固定命令包将运行时合同改为环境限制；static coverage升至88/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XV.md) | M TIMECAPSULE TABLE确认RENAME用于TRUNCATE的原文错误；static coverage升至84/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XIV.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XIV.md) | DROP TABLE将无界列表确认为有限两表代表；static coverage升至83/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XIII.md) | ALTER RESOURCE LABEL补REMOVE TABLE代表；DROP PROCEDURE补初始属主环境门；static coverage升至82/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XII.md) | CREATE GROUP显式NOLOGIN代表；DROP OPERATOR闭合行为语法形态；static coverage升至80/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XI.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_XI.md) | DROP CAST与DROP RLS POLICY补缺失目标IF EXISTS静态代表；static coverage升至78/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_X.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_X.md) | DROP AUDIT POLICY/DIRECTORY/EVENT补缺失目标IF EXISTS静态代表；static coverage升至76/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_IX.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_IX.md) | ALTER DIRECTORY与ALTER OPERATOR补专用NOLOGIN属主角色；static coverage升至73/307 |
| [PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_VIII.md](docs/PDF_QUALITY_BATCH_20260921_STATIC_COVERAGE_CLOSURES_VIII.md) | SET ROLE与SET SESSION AUTHORIZATION各增加一个专用角色静态切换代表；static coverage升至71/307 |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_VII.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_VII.md) | DROP GROUP闭合static coverage；管理工具上下文显式为authorized_isolated_tool_session |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_VI.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_VI.md) | CHECKPOINT与M SHOW闭合static coverage；不生成GUC分支或TABLE STATUS元数据Oracle |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_V.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_V.md) | M CREATE SEQUENCE与START TRANSACTION闭合static coverage；不生成默认边界、RESTART、重复属性或省略逗号 |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_IV.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_IV.md) | M COPY与M CREATE AUDIT POLICY闭合static coverage；不生成NULL输入、多操作示例或脱敏推导 |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_III.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_III.md) | 四个语法冲突/限制包闭合static coverage；不生成冲突括号、双INTO或多列子查询 |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_II.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES_II.md) | 五个文档冲突/映射包闭合static coverage；不生成冲突示例、分区分支或示例建库映射 |
| [PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_COVERAGE_CLOSURES.md) | 五个单阻断包闭合static coverage；来源限制不伪装成行为验证，M SET TRANSACTION补示例组合 |
| [PDF_QUALITY_BATCH_20260920_M_GENERATED_UPDATE_SYSTEM_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260920_M_GENERATED_UPDATE_SYSTEM_FRESH_SYNTAX.md) | M GENERATED UPDATE SYSTEM补一个固定命令静态代表；保留OM升级与回滚脚本Oracle缺口 |
| [PDF_QUALITY_BATCH_20260920_SET_TRANSACTION_COMBINED_EXAMPLES.md](docs/PDF_QUALITY_BATCH_20260920_SET_TRANSACTION_COMBINED_EXAMPLES.md) | SET TRANSACTION补齐LOCAL/SESSION/GLOBAL三个示例确认组合；静态覆盖闭合但行为不宣称通过 |
| [PDF_QUALITY_BATCH_20260920_M_TIMECAPSULE_TABLE_DDL_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_M_TIMECAPSULE_TABLE_DDL_NEGATIVE.md) | M TIMECAPSULE TABLE新增一个原文确认的TRUNCATE后DDL负向Oracle；保留恢复行为与RENAME错误身份缺口 |
| [PDF_QUALITY_BATCH_20260920_COPY_SERVER_FILE_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_COPY_SERVER_FILE_NEGATIVE.md) | COPY新增一个原文确认的服务器文件未授权负向Oracle；保留文件边界、冻结冲突与流导入缺口 |
| [PDF_QUALITY_BATCH_20260920_INSERT_ALL_MISSING_SUBQUERY_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_INSERT_ALL_MISSING_SUBQUERY_NEGATIVE.md) | INSERT ALL新增一个原文确认的缺失子查询负向Oracle；保留VALUES子查询与ELSE缺口 |
| [PDF_QUALITY_BATCH_20260920_INSERT_ALL_VIEW_TARGET_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_INSERT_ALL_VIEW_TARGET_NEGATIVE.md) | INSERT ALL新增一个原文确认的视图目标负向Oracle；保留VALUES子查询、缺失子查询与ELSE缺口 |
| [PDF_QUALITY_BATCH_20260920_INSERT_ALL_SUBQUERY_ALIAS_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_INSERT_ALL_SUBQUERY_ALIAS_NEGATIVE.md) | INSERT ALL新增一个原文确认的子查询别名引用负向Oracle；保留VALUES子查询、视图与ELSE缺口 |
| [PDF_QUALITY_BATCH_20260920_INSERT_ALL_MISSING_PROJECTION_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_INSERT_ALL_MISSING_PROJECTION_NEGATIVE.md) | INSERT ALL新增一个原文确认的WHEN缺失投影列负向Oracle；保留子查询与ELSE缺口 |
| [PDF_QUALITY_BATCH_20260920_INSERT_ALL_MULTI_ROW_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_INSERT_ALL_MULTI_ROW_NEGATIVE.md) | INSERT ALL新增一个原文确认的VALUES多行负向Oracle；保留子查询与投影列缺口 |
| [PDF_QUALITY_BATCH_20260920_INSERT_ALL_AGGREGATE_NEGATIVE.md](docs/PDF_QUALITY_BATCH_20260920_INSERT_ALL_AGGREGATE_NEGATIVE.md) | INSERT ALL新增一个原文确认的VALUES聚集函数负向Oracle；保留多行、子查询与投影列缺口 |
| [GENERATION_MODEL_REMAINING_20260920.md](docs/GENERATION_MODEL_REMAINING_20260920.md) | 剩余11个有manifest但生成模型未闭合包的阻断分类；JSON版接入生成报告、Web/API并阻止集合漂移 |
| [PDF_QUALITY_BATCH_20260920_GENERATION_VALUE_CLOSURE_II.md](docs/PDF_QUALITY_BATCH_20260920_GENERATION_VALUE_CLOSURE_II.md) | 四个已有manifest包补齐17个有限语法值；generation model complete升至295/306，行为缺口保留 |
| [PDF_QUALITY_BATCH_20260920_GENERATION_VALUE_CLOSURE.md](docs/PDF_QUALITY_BATCH_20260920_GENERATION_VALUE_CLOSURE.md) | 六个已有manifest包补齐16个有限语法值；generation model complete升至291/306，行为缺口保留 |
| [NO_MANIFEST_REMAINING_20260920.md](docs/NO_MANIFEST_REMAINING_20260920.md) | 剩余11个无manifest包的当前阻断分类；JSON版接入生成报告、Web/API并阻止集合漂移 |
| [PDF_QUALITY_BATCH_20260920_CREATE_LLM_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260920_CREATE_LLM_FRESH_SYNTAX.md) | CREATE LLM增加QUERY/EMBED/RERANK三个非秘密静态代表；保留外部服务、密钥注入与路径冲突缺口 |
| [PDF_QUALITY_BATCH_20260920_AUTOHINT_STATIC_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260920_AUTOHINT_STATIC_SYNTAX.md) | AUTOHINT与AUTOHINT DROP MODEL各增加一个无执行静态代表；保留探索、资源预算与历史归属缺口 |
| [PDF_QUALITY_BATCH_20260920_CREATE_DATABASE_LINK_FRESH_SYNTAX.md](docs/PDF_QUALITY_BATCH_20260920_CREATE_DATABASE_LINK_FRESH_SYNTAX.md) | CREATE DATABASE LINK增加4个无秘密正向代表与1个后端匹配负向代表；保留连通性、语法冲突与生命周期缺口 |
| [PDF_QUALITY_BATCH_20260920_PARAMETERIZED_STATIC_COMMANDS.md](docs/PDF_QUALITY_BATCH_20260920_PARAMETERIZED_STATIC_COMMANDS.md) | CEK轮转与三个IMPDP阶段包增加8个有限syntax_only代表；保留密钥、备份工具与恢复行为缺口 |
| [PDF_QUALITY_BATCH_20260920_STATIC_FIXED_COMMANDS.md](docs/PDF_QUALITY_BATCH_20260920_STATIC_FIXED_COMMANDS.md) | 四个固定命令包各增加一个syntax_only代表；保留TDE、AUTOHINT、OM升级与PDB恢复行为缺口 |
| [PDF_QUALITY_BATCH_20260918_COMMENT_TABLE_COLUMN_ALL.md](docs/PDF_QUALITY_BATCH_20260918_COMMENT_TABLE_COLUMN_ALL.md) | COMMENT TABLE/COLUMN有限域闭合；保留其他对象与目录Oracle缺口 |

### 连库执行工具（2026-09-14 新增）

| 文件 | 用途 | 使用方法 |
|---|---|---|
| `scripts/auto_validate.py` | 自动化验证（10条核心测试） | `python3 scripts/auto_validate.py --host H --port P --db D --user U` |
| `docs/ASSERTION_ENHANCEMENT_PLAN.md` | 276条facts分析→4类增强方案 | 参考 |
| `docs/ASSERTION_ENHANCEMENT_SQL.md` | 26组增强SQL（边界/错误/GUC/模式） | 按`\`sql`块逐条执行 |
| `docs/ERROR_DIAGNOSIS_HANDBOOK.md` | 错误码速查表 | 遇到错误按表操作 |
| `docs/minimal_validation_script.sql` | 10条核心验证 | `gsql -f docs/minimal_validation_script.sql` |
| `docs/extended_validation_script.sql` | 100条扩展验证 | `gsql -f docs/extended_validation_script.sql` |
| `docs/EXECUTION_VALIDATION_PLAN.md` | 三阶段验证方案 | 按Phase 1/2/3执行 |
| `docs/FACT_INTEGRATION_PLAN.md` | Facts接入计划 | 参考 |
| `docs/VALUE_GAP_DISPOSITION_20260911.md` | 25条gap处置记录 | 参考 |

### 连库后的执行顺序

```bash
# 1. Phase 1: 核心验证（5分钟）
python3 scripts/auto_validate.py --host $HOST --port $PORT --db $DB --user $USER

# 2. Phase 2: 扩展验证（30分钟）
gsql -d $DB -p $PORT -U $USER -f docs/extended_validation_script.sql

# 3. Phase 3: 增强SQL（按手册逐组执行）
# 打开 docs/ASSERTION_ENHANCEMENT_SQL.md，按顺序执行

# 4. 遇到错误查手册
# 打开 docs/ERROR_DIAGNOSIS_HANDBOOK.md

# 5. Web界面浏览
python3 -m uvicorn main:app --host 0.0.0.0 --port 8080
# 浏览器访问 http://localhost:8080
```

### 已知限制

- **数据库执行: 0条** — 所有结论均为静态
- 25条value gaps中18条为合法阻断（文档冲突/环境资产/语义设计）
- 深化不均匀：高级包/操作符/数据类型较深，部分子节为概要级
- 实机验证需单独授权和验收

### 下一步

1. **执行验证脚本** — 等有GaussDB环境后立即可用
2. **修复发现的问题** — 验证后根据结果改进
3. **Facts接入** — 按 FACT_INTEGRATION_PLAN.md 三步计划


首批五个 PDF 校准因子是 CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT 和
INSERT。仓库随后按独立批次加入代表性 DDL、DML、DCL 与 TCL 因子；当前数量、
生成用例和覆盖结论始终以严格 lint、生成报告和批次队列的实时输出为准，不在
README 中维护容易漂移的固定数字。

生成报告的 `package_inventory` 单独给出全库注册包数、一般/M命名空间拆分、
有manifest的包数、本次选择的包数，以及无manifest包的场景/fixture/待审事实引用。
`factor_coverage` 只包含本次选择的manifest所涉及的包，不能把它的长度当全项目包数。
即使使用 `--factor` 只生成一个包，全库分母也不会缩为1。无manifest不等于产品不支持，
有manifest也不等于有用例、完整覆盖或实机通过；物理模式仍须独立核实。

跨章依赖批次可通过 `python3 scripts/verify_cross_chapter_dependencies.py` 重跑，
需要当前 Python 安装 `pypdf` 且 PATH 中有 `pdftotext`；也可以使用
`--pdf-python /path/to/python` 指定单独的 PDF 运行环境。
批次选择、逐项证据和验收边界见 [12 章依赖验证](docs/CROSS_CHAPTER_DEPENDENCY_RESULT.md)。

按 [第三批抽取计划](docs/BATCH_03_EXTRACTION_PLAN.md) 选择的 20 个新章节均已形成包和 SQL 候选，
并纳入已有提供者及实际引用的补充正文。事务/保存点、ALTER/DROP VIEW/SEQUENCE/INDEX、
模式管理及预备语句子批已落盘；有限域生成完成不等于文档全特性覆盖或数据库行为验收。
见 [第三批阶段结果](docs/BATCH_03_EXTRACTION_PROGRESS.md)，实际进度看独立 `batch_03` 队列。

[第四批](docs/BATCH_04_EXTRACTION_PLAN.md) 的 20 个新章节均已落盘，并纳入实际依赖正文；
累计 70 个 manifest、470 条静态候选（437 正向 / 33 目标负向），原文映射与有限生成域检查通过。
完整特性和行为仍待审核：保留 72 个 open question 与 63 个 planned scenario，不将它们改成已验证。
见 [第四批阶段结果](docs/BATCH_04_EXTRACTION_PROGRESS.md)，不将选章完成或 SQL 生成冒充行为验收。

[第五批](docs/BATCH_05_EXTRACTION_PLAN.md) 已新增函数/聚集、文本搜索、增量物化视图等20个章节包。
默认仅生成有限域候选；内部功能授权、文件型词典、复杂函数与数据库行为继续单独留账。
候选数量与最新验证证据见 [第五批结果](docs/BATCH_05_EXTRACTION_PROGRESS.md)。

[第六批](docs/BATCH_06_EXTRACTION_PLAN.md) 继续新增过程、规则、触发器、两阶段事务和维护命令等20个包。
零参数固定语句已纳入生成回归；权限、凭据和高风险状态仍有明确待审核边界。
见 [第六批结果](docs/BATCH_06_EXTRACTION_PROGRESS.md) 和 [PDF剩余章节队列](docs/PDF_GENERAL_EXTRACTION_BACKLOG.md)。

后续按对象家族完成第七至十一批：
[类型与扩展](docs/BATCH_07_EXTRACTION_PROGRESS.md)、
[数据库与工具命令](docs/BATCH_08_EXTRACTION_PROGRESS.md)、
[身份与权限](docs/BATCH_09_EXTRACTION_PROGRESS.md)、
[策略及外部资源契约](docs/BATCH_10_EXTRACTION_PROGRESS.md)、
[分区、数据流与恢复](docs/BATCH_11_EXTRACTION_PROGRESS.md)。
整本 general SQL 的包绑定与尚未关闭的生成/行为缺口，以
[PDF 目录进度](docs/PDF_GENERAL_EXTRACTION_BACKLOG.md)及其可重算报告为准。
没有普通 manifest 的工具、外部资源或内部命令仍保留证据包，但不计作 SQL 生成通过。
本次补齐任务的固定验收快照见 [剩余129包交付结果](docs/REMAINING_129_EXTRACTION_RESULT.md)，
其中明确区分原文抽取、有限生成、未实现运行时和数据库行为验证。
后续质量改进见 [第三轮：全量对账与持续失效](docs/QUALITY_ROUND_03.md)、
[第二轮：真实写入契约](docs/QUALITY_ROUND_02.md)及
[第一轮质量复核](docs/QUALITY_ROUND_01.md)；历史批次报告保持冻结，不覆盖其旧验收数据。

## 当前验证基线

9月10日后续演进增加了[生成模型可解释诊断](docs/GENERATION_DIAGNOSTICS.md)，只修改展示与进度解释，不改变生成器、规格、SQL及原审计结论；对应相关回归与此前夜间全项目回归分开记账。

本轮最新状态见 [9月9日至10日夜间演进](docs/NIGHT_EVOLUTION_20260910.md)，包含生成列、MERGE默认值与RETURNING输出列共享合同，以及M PREPARE/SET等有限代表。前一完整全量回归保留在 [历史静态验收节点](docs/MILESTONE_STATIC_ACCEPTANCE_20260909.md)，不将旧测试数冒充本轮新代码全量验证；此前来源和修复证据见 [9月9日演进记录](docs/PROJECT_EVOLUTION_20260909.md)。活跃SQL与历史待审SQL独立计数；上面的历次抽取数字仅描述当时批次，不作为当前总量。

当前基线不再使用历史“226 个因子”作为分母。唯一产品证据是仓库中的冻结 PDF 与其 `catalog.json`；CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT、INSERT 是首批五章校准集。实时数量和结论由下列命令重算，README 不复制容易陈旧的 case 数：

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 scripts/audit_factor_coverage_v1.py
python3 scripts/audit_pdf_catalog_coverage.py \
  --source-catalog intranet_corpus/catalog.json \
  --spec-root specs \
  --queue work/doc2spec/queue.json \
  --output generated/audit/pdf_catalog_coverage.json
```

五章均已绑定 PDF 版本、父文档/章节哈希、完整书签路径和精确页内边界。静态生成的 SQL 是“文档驱动候选”，只有在 source、值域、feature domain、规则、Fixture 和目标 Oracle 的审计缺口全部关闭后，才可称为静态闭环；只有在指定 GaussDB 版本执行并通过行为/元数据 Oracle 后，才可称为数据库验证通过。Pairwise 100% 只证明已建模且可行的二元交互，不证明 PDF 全章、全值域或数据库行为覆盖。

## 架构

```text
冻结的产品 PDF
    │ 书签路径+页内坐标精确拆章
    ▼
PDF source catalog + 稳定章节文本
    │ 保留产品版本、父PDF/章节哈希、页码和坐标
    ▼
Doc2Spec 离线任务队列
    │ 一次认领一个章节；任意内网 AI 只写一个输出目录
    ▼
specs/<category>/<factor>/
    ├── *.source.yaml       原文单元覆盖账本
    ├── *.factor.yaml       事实、维度、值域、规则与引用索引
    ├── *.syntax.yaml       SQL结构化AST（有限展开）
    ├── manifests/          测试选择、策略和目标Oracle
    ├── matrices/           对象与语义能力Profile
    ├── fixtures/           setup/provides/teardown
    └── scenarios/          多步骤状态变化和行为断言
             │
             ▼
FactorPackageRegistry 严格加载、限定 Fact/Fixture 引用与依赖 DAG 校验
             │
       ┌─────┴────────┐
       ▼              ▼
约束感知SQL生成    因子级覆盖审计
       │              │
       └─────┬────────┘
             ▼
generated/factor_packages/ + Web/API
```

更详细的职责和数据流见 [当前架构说明](docs/ARCHITECTURE.md)。整本 PDF 入口见 [PDF 到 Factor Package 权威流程](docs/PDF_DOC2SPEC_PIPELINE.md)。

## 目录

```text
gaussdb_test/
├── specs/                         Factor Package V1 唯一写入位置
├── core/
│   ├── factor_package_model.py    V1严格模型与注册表
│   ├── factor_package_generator.py V1结构化AST与组合生成器
│   ├── factor_coverage_auditor.py V1因子级覆盖审计
│   ├── constraint_solver.py       约束DSL解析与求值
│   └── combinator.py              组合覆盖算法
├── scripts/
│   ├── lint_factor_packages_v1.py
│   ├── generate_factor_package_sql.py
│   ├── audit_factor_coverage_v1.py
│   └── manage_extraction_queue.py
├── prompts/                       内网 AI 单任务抽取模板
├── intranet_corpus/               内网章节语料；正文被 Git 忽略
├── generated/factor_packages/     确定性 SQL 快照与审计报告
├── web/                           FastAPI 页面与静态资源
├── tests/                         自动化测试
├── docs/                          当前规范、运行手册与历史资料
├── factors/                       Legacy V0兼容输入
├── grammars/                      Legacy V0兼容输入
├── matrices/                      Legacy V0兼容输入
└── manifests/                     Legacy V0兼容输入
```

根目录的 `factors/`、`grammars/`、`matrices/` 和 `manifests/` 属于 Legacy V0。现有兼容运行时仍可能读取它们，但新的文档抽取只写 `specs/`，禁止人工双写同一条规则。

## 快速开始

### 安装

```bash
git clone https://github.com/yuziyydss/gaussdb_test.git
cd gaussdb_test
python3 -m pip install -r requirements.txt
```

### 运行测试

```bash
python3 -m unittest discover -s tests
```

测试数量会随 PDF 校准持续变化；以命令退出码和本次完整输出为准，不在文档中固定一个会陈旧的数字。

### 严格加载 V1

```bash
python3 scripts/lint_factor_packages_v1.py specs
```

### 生成 SQL

生成所有 V1 manifest：

```bash
python3 scripts/generate_factor_package_sql.py
```

只生成一个 factor：

```bash
python3 scripts/generate_factor_package_sql.py --factor create_view
```

SQL默认写入 `generated/factor_packages/<factor>/`，总报告写入 `generated/factor_packages/generation_report.json`。

### 审计静态覆盖

```bash
python3 scripts/audit_factor_coverage_v1.py --factor create_view
```

CI严格模式：

```bash
python3 scripts/audit_factor_coverage_v1.py --factor create_view --fail-on-gaps
```

严格模式失败表示存在静态覆盖缺口，不代表脚本异常。报告会分别给出 source、generation、static 和 behavior 四种结论。

### 启动 Web

```bash
python3 -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

浏览器打开 `http://127.0.0.1:8000/`。

## 内网批量抽取

准备章节语料：

```text
intranet_corpus/
  general/ddl/create_table.txt
  general/dml/update.txt
  m_compat/dml/select.txt
```

输入是含书签的整本 PDF 时，先生成 source catalog 和章节文本：

```bash
python3 scripts/extract_pdf_sections.py \
  --pdf gaussdb-rf-cent.pdf \
  --output-root intranet_corpus
```

创建队列并认领任务：

```bash
python3 scripts/manage_extraction_queue.py inventory \
  --corpus-dir intranet_corpus \
  --source-catalog intranet_corpus/catalog.json
python3 scripts/manage_extraction_queue.py claim --worker company-ai-01 --render
```

AI生成候选 V1 package 后：

```bash
python3 scripts/manage_extraction_queue.py update \
  --task-id <TASK_ID> \
  --status generated

python3 scripts/manage_extraction_queue.py verify --task-id <TASK_ID>
```

`static_complete` 只能由任务信封对账和三道静态程序门禁共同写入。它不代表数据库行为已验证。

## 文档入口

当前文档索引见 [docs/README.md](docs/README.md)。最重要的五份文档是：

- [Factor Package Schema V1](docs/FACTOR_PACKAGE_SCHEMA_V1.md)
- [Factor Package V1 冻结与批次推进规则](docs/FACTOR_PACKAGE_V1_FREEZE_POLICY.md)
- [Doc2Spec Extraction Rules V1](docs/DOC2SPEC_EXTRACTION_RULES_V1.md)
- [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)
- [当前架构说明](docs/ARCHITECTURE.md)

## 下一步

首批五章校准和后续分批抽取已经推进，不再把“开始第二批”当作当前任务。后续以实时审计缺口为入口：

1. 保持 Factor Package V1 公共模型和生成接口稳定；先重算目录、原文、有限生成域与行为四种口径。
2. 按 `needs_profile` 与 `open_question` 分类补值域、列契约、外部资源和权限场景，不重抽已经有来源证据的章节。
3. 先选择已有受控 Fixture 的候选做独立数据库验证，记录具体环境和目标 Oracle；未执行不得标为 verified。
4. 外部文件、密钥、模型训练、后台任务和库级恢复需先实现运行时契约，不为提高通过率删除事实或改成任意错误通过。
5. 对 PDF 或依赖包变化执行哈希失效与定向回归，继续区分包已存在、原文已处置、能生成、静态闭环和行为已验证。

冻结边界见 [Factor Package V1 冻结与批次规则](docs/FACTOR_PACKAGE_V1_FREEZE_POLICY.md)，完整路线见 [ROADMAP.md](docs/ROADMAP.md)。
