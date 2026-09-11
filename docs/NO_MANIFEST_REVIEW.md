# 无普通manifest包：如何理解和继续处理

2026-09-10局部复核。当前317个注册包中，264个有manifest，53个没有。
本页已完成53个包的“不生成原因与资产边界”原文复核；不是全章事实覆盖精审。
这不是53个包都不支持，也不是264个包都已通过实机测试。

## 已核对的原因

| 原因 | 包 | 依据及处理方式 |
| --- | --- | --- |
| 当前产品形态明确不可用（6） | CREATE LANGUAGE、ALTER LANGUAGE、DROP LANGUAGE、CREATE GLOBAL INDEX、LOCK BUCKETS、MARK BUCKETS | 当前集中式PDF各章明确写明形态不支持。保留原文和待处理状态；不虚构缺失语法，不推广为其他版本/部署形态也不支持 |
| 内核上下文（2） | CREATE CONVERSION、EXPLAIN AUTOHINT | 内部创建或内核任务专属。普通会话、示例ID、现成表不能替代内部上下文；先有权威集成合同，再决定是否生成 |
| 工具调用上下文（2） | DROP GROUP、EXPDP PLUGGABLE DATABASE | 前者是管理工具接口且文档不建议直接调用；后者要求备份恢复工具/auxdb上下文。不是换一个用户名或填目录字符串就能解决 |
| 模型生命周期资产（3） | CREATE MODEL、PREDICT BY、DROP MODEL | 已有真实八列十五行输入fixture和输入投影；仍缺受限训练、成功模型身份、预测Oracle与模型清理归属。这三包不是不支持 |
| 文件系统资产（3） | CREATE TABLESPACE、ALTER TABLESPACE、DROP TABLESPACE | 需要真实目录、对象归属、非事务执行及部分失败恢复；新Schema不能隔离目录/软链接，也不能用回滚证明文件清理完成 |
| 全局安全策略（2） | CREATE WEAK PASSWORD DICTIONARY、DROP WEAK PASSWORD DICTIONARY | CREATE修改系统字典，DROP清空全部弱口令；须保密基线、独占可销毁环境及精确恢复，不能把DROP作为单值测试的清理 |
| 查询探索历史（3） | AUTOHINT、AUTOHINT DROP MODEL、AUTOHINT PURGE | 前两者涉及实际查询执行/同一SQL历史身份；PURGE清空全部历史，需要另一层授权。三者不能用通用SELECT表或新Schema证明隔离 |
| 索引方法合同（1） | CREATE OPERATOR CLASS | 内部功能不建议用户直接使用；CREATE不检查全部支持函数是否完备。示例加法函数不能证明数组B-tree比较语义，且省略FAMILY可能自动建族，缺函数/策略/类型和依赖归属合同 |
| 密态驱动与外部密钥资产（5） | CREATE CLIENT MASTER KEY、CREATE COLUMN ENCRYPTION KEY、ALTER COLUMN ENCRYPTION KEY、DROP CLIENT MASTER KEY、DROP COLUMN ENCRYPTION KEY | 驱动能力、CMK/CEK元数据与外部密钥实体分别管理；DROP CMK不能删除外部实体，DROP CEK不能借CASCADE删除依赖加密列；不访问秘密或KMS来凑fixture |
| 全局TDE状态（1） | ALTER ASYNC ENCRYPTION KEY ROTATION | 双TDE开关、SYSADMIN、非M限制与实际数据密钥状态；删除示例表不代表撤销轮转，与局部CMK轮换分开 |
| 备份恢复工具阶段（8） | EXPDP DATABASE/TABLE、IMPDP DATABASE CREATE、IMPDP RECOVER、IMPDP TABLE/PREPARE、IMPDP PLUGGABLE DATABASE CREATE/RECOVER | 7项需要工具上下文；PDB CREATE更明确禁止普通直接调用，可能异常重启。准备/执行/修复阶段、物理文件身份和连接目标不能混用 |
| 权威升级上下文（3） | 一般GENERATED UPDATE SYSTEM OBJECT、M GENERATED UPDATE SYSTEM、REFRESH SYSTEM OBJECT | 真实OM/升级阶段和初始用户，不是手工设置GUC。M包已有fixture但执行状态not_implemented，属于阻塞声明，不是可用空fixture |
| 节点级恢复（1） | SHUTDOWN | 关闭当前连接的节点，影响连接与事务；需要可销毁独占节点、带外重启及故障恢复Oracle，独占一个数据库不够 |
| 外部模型服务登记（2） | CREATE LLM、DROP LLM | 真实HTTPS服务、CA、秘密注入和OBS加密文件；DROP仅删除库内登记，不删除外部模型，也不是CREATE MODEL训练对象 |
| 远端连接身份（3） | CREATE/ALTER/DROP DATABASE LINK | A库与非初始用户、GaussDB/Oracle后端、PUBLIC/PRIVATE与属主、凭证注入；创建不验证连接，修改选项也不能跨后端混用 |
| 多租资源生命周期（3） | CREATE/ALTER/DROP PLUGGABLE DATABASE INCLUDING DATAFILES | 真实多租安装、非PDB控制连接、资源指令、非事务DDL与文件归属；DROP不级联删除资源指令。CREATE允许目标M，但不能从M控制库执行 |
| 库回收站身份（1） | TIMECAPSULE DATABASE | 回收站实际对象、保留期/清理/磁盘能力；不支持PDB闪回，不能归入PDB恢复。原名找最新、系统名精确定位，且支持事务块 |
| 全局配置恢复（2） | ALTER/DROP GLOBAL CONFIGURATION | 初始用户与自身key的原始存在性/值、精确恢复；禁止weak_password/undostoragetype，不能作为弱口令字典恢复捷径 |
| 多租资源计划切换（1） | ALTER SYSTEM SET | 本章只定义resource_manager_plan，不是通用GUC写入；需真实多租/非PDB/非M控制身份与原计划恢复、租户影响控制 |
| 专属会话身份（1） | ALTER SYSTEM KILL SESSION | 真实被测会话的SID/SERIAL映射、存活/防重用控制；示例pid与SID映射待校准。连接断开不是事务回滚已验证 |

分类只用于安排工作，不自动改变factor的status、不增删manifest，也不是生成器已经消费的能力矩阵。
来源范围为本地GaussDB V2.0-10.0.0集中式PDF；不能与历史507版本或其他物理形态混用。

## 不能混淆的四件事

1. CREATE GLOBAL INDEX的GSI可与基表采用不同分布；它不是CREATE INDEX语法里的GLOBAL分区索引选项。不能用普通索引fixture把GSI包标成可生成。
2. 已有plpgsql过程可以执行，不表示可以CREATE LANGUAGE注册新过程语言。
3. PREDICT BY示例嵌在SELECT中，并引用训练完成的模型。`SELECT size, lot`只验证输入投影，不能算预测候选或预测成功。
4. EXPLAIN AUTOHINT直接调用可能无效，也可能被阻拦。文档的两个结果不能压成一个固定SQLSTATE或“任意报错都通过”。

## 下一步按依赖推进

- 明确形态不支持：保存事实与版本/形态范围，不补伪SQL；只有新的权威材料改变适用范围才重新评审。
- 工具或内部上下文：先定义真实调用入口、身份和恢复边界；普通fixture不能模拟全部条件。
- 资产缺口：优先复用已存在的输入数据，但把“输入存在”“操作成功”“对象归属”“Oracle已校准”分开。
- 53包已有缺口归类，但全部保留未解决状态；下一步优先从真实可复用资产推进，不能根据分类结果批量制造空fixture或把planned场景升级为可执行。

模型类的下一可复用节点，是一个有限算法的资源预算与模型身份合同；不是一口气实现所有算法，也不是逐条手写CREATE/PREDICT/DROP SQL。
数据库执行、训练和清理必须单独获得授权，静态通过不产生该授权。

## 本次规划修正不等于增加了执行能力

表空间、弱口令字典、AUTOHINT共8个已有planned场景增加了具体前置审查要求。
这些是后续实现的验收边界，**不是已经实现的运行时gate**，也没有新增普通manifest。
特别是：

- AUTOHINT的TEST会执行原查询与推荐查询；MEMSIZE小于32768时退为不限额的0，
  并依赖enable_memory_limit，不能把较小数值误认为更安全的预算。
- AUTOHINT DROP MODEL按SQL删除历史，不是删除CREATE MODEL训练的模型；
  0条删除与已有历史成功删除是不同场景。
- CREATE TABLESPACE注意事项允许gs_role_tablespace，OWNER说明又写仅管理员；
  后续权限分支必须保留这处待核实差异，不能只取一句扩大允许范围。
- 弱口令多值主语法与示例括号形态仍有冲突；待决事实已同时锚定两处，未猜语法。

因此本轮的价值是明确哪些资产不能被普通fixture冒充，防止后续生成失真；
不能把53项复核记成53个可生成或实机通过的包。六个密钥章节只明确资产边界，
没有创建驱动、外部密钥实体或运行时能力gate。

工具/升级批次还细化了12个planned场景的工具、文件、阶段、恢复要求，
并将PDB名称可选性冲突锚定到语法和参数两处。没有执行备份、升级或关机；
这些前置要求仍是设计验收项，不是已实现的执行器。详见[工具与升级边界](TOOL_UPGRADE_BOUNDARIES.md)。

## 本轮证据

本地工作目录`work/overnight_evolution_20260911_0900/`保存：

- `n2_reviewed_dispositions.json`：53包固定分母、13项显式分类、40项未复核，以及来源章节/片段哈希和后续合同。
- `n5_reviewed_dispositions.json`：延续而不覆盖旧证据，新增9项，累计22项复核/31项未复核；仍53个无普通manifest。
- `n6_reviewed_dispositions.json`：完成六个密钥章节的资产边界复核，累计28项/25项待复核；旧账本保留，53个缺口未被改成已解决。
- `n7_reviewed_dispositions.json`：新增12个工具/升级/节点边界复核，累计40项/13项待复核；M阻塞fixture的真实状态单独记录。
- `n8_reviewed_dispositions.json`：补齐其余13项，累计53项原因复核/0项待分类，但仍53项无普通manifest、53项未解决；保留章节和片段哈希。
- `n8_source_related/receipt.json`、`n8_acceptance.json`：DBLink矛盾来源两侧锚点回归及全库生成保全证据，不代表全量unittest或数据库验证。
- `n5_plans_related/receipt.json`、`n5_acceptance.json`：本次场景规划/来源回归与全库生成保全的独立证据。
- `n2_initial_review.md`、`n2_utility_review.md`、`n2_model_review.md`：人工判断与原文锚点。
- `n2_provenance_related/receipt.json`、`n2_model_related/receipt.json`：实际静态测试收据，时间和输入范围分别记录，不合并冒充全量回归。

工作目录是本地证据，不是另一份生成规格事实源。此页为有日期的局部复核说明；以最新注册表、生成报告及新鲜收据为准。
