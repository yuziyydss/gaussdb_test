# 文档索引

## 当前权威文档

| 文档 | 用途 |
|---|---|
| [PDF类型规则第二批：显式A整数](COMMON_TYPE_BATCH_02.md) | 9月11日下午：4 SELECT＋2 INSERT候选、九格类型单元检查；1,912项全量静态通过，旧5263候选保全；长度/精度实际消费者缺口独立评审，未执行数据库 |
| [PDF值存储与UNION/CASE首批](COMMON_TYPE_BATCH_01.md) | 9月11日：新增9条PG有限候选，1,903项全量静态回归通过；10组规则分层处理、实际DDL/输出类型检查、跨包fixture及旧SQL保全，实机仍未验证 |
| [9月9日至10日夜间演进](NIGHT_EVOLUTION_20260910.md) | 当前窗口：生成列、MERGE默认值、RETURNING输出列合同与M PREPARE/SET代表；数量及逐批真实收据见正文，历史全量单列 |
| [M STORED生成列共享合同](GENERATED_COLUMN_CONTRACT_20260909.md) | 夜间第一批：24项新增、108项相关回归；四类实际输入共用有限合同，全5061候选不变，写入待审21→17；不是实机验证 |
| [历史全项目静态验收节点](MILESTONE_STATIC_ACCEPTANCE_20260909.md) | 前一冻结版本171模块1339项通过；当时5061活跃候选＋1历史候选、21写入待审，不替代夜间新版本验证 |
| [9月9日全项目演进记录](PROJECT_EVOLUTION_20260909.md) | 十一批改进、来源和历史失败证据；较早1295项与后续专项不混算，当前终验见上行 |
| [候选回到待审与历史保全](CANDIDATE_REVIEW_RETIREMENT.md) | INSERT query/subquery歧义实例；撤销未证实硬规则、保留原SQL与错误假设，活跃与历史库存分开对账 |
| [实际选中值的环境前提](SELECTED_ENVIRONMENT_CAPABILITIES.md) | 索引可见性的A模式、关键字禁用状态、升级阶段约束；声明门不等于实机探测 |
| [双列MODIFY前置合同](MODIFY_COLUMN_PREREQUISITES.md) | 实际旧DDL、种子、VARCHAR扩长和NOT NULL前置检查；不推导统计信息或数据库结果 |
| [2026-09-09 双模式离线基线](STATIC_BASELINE_20260909.md) | 当日较早历史基线：317包、5060候选、1166项离线回归；不替代上方最新节点结果 |
| [写入合同循环本批验收](WRITE_CONTRACT_LOOP_RESULT_20260909.md) | 前一窗口201项相关回归；54份SQL字节不变；原40条补齐14条，同时暴露2条，当时剩余28条如实保留 |
| [冲突更新源列合同](CONFLICT_SOURCE_CONTRACT_ROUND_20260909.md) | VALUES/EXCLUDED 的有限列身份检查、一般/M 来源边界、149项相关回归与240条不变候选对账 |
| [M INSERT入口与新行合同](M_INSERT_ENTRY_CONTRACT_20260909.md) | 本批入口阶段：可选INTO与SET有限适配、172项相关回归及40条原始待审根因清单；最终统计见本批验收 |
| [冲突更新 DEFAULT 修复](DEFAULT_CONTRACT_ROUND_20260909.md) | 上一轮 DEFAULT 消费者漏检修复，含74项专项与有限检查边界 |
| [M 兼容命令首批](M_COMPAT_BATCH_01.md) | 六个独立 M 包、101 条有限候选、跨包依赖、共享检查修正及真实缺口；不冒充全文/实机完成 |
| [按包缺口收敛首批](PACKAGE_CLOSURE_FIRST_BATCH.md) | 168 包逐条缺口、56 包资产路线、INSERT 行结果计划与模型输入；不冒充生成/实机闭环 |
| [进度口径与共享列契约评审](PROGRESS_AND_SHARED_COLUMN_REVIEW.md) | 四阶段展示、DEFAULT/视图契约边界、迁移与验收条件 |
| [内部共享列契约首轮实现](SHARED_COLUMN_CONTRACT.md) | INSERT/UPDATE 共享 DEFAULT 与直接投影证据、失效边界、固定分母对账 |
| [56个无普通清单包的核查路线](NO_MANIFEST_REVIEW_ROUTES.json) | 五类成员、下一步与验收；分类不改变支持或执行状态 |
| [第三轮质量复核](QUALITY_ROUND_03.md) | 全量来源/待审 case 对账、补充正文持续失效与有限写入检查扩展 |
| [第二轮质量复核](QUALITY_ROUND_02.md) | 实际 SQL/fixture 形状检查、8 包 20 条复核及 15 章依赖验证 |
| [第一轮质量复核](QUALITY_ROUND_01.md) | 全库可执行待办、12 包有限域复核、修复与验收边界 |
| [PDF全书台账与基础规格双线Loop](PDF_LIBRARY_LOOP.md) | 全书书签登记、首批六个基础主题、依赖连接及持续工作边界 |
| [Factor Package Schema V1](FACTOR_PACKAGE_SCHEMA_V1.md) | V1文件类型、字段、引用和验收契约 |
| [Factor Package V1 冻结与批次推进规则](FACTOR_PACKAGE_V1_FREEZE_POLICY.md) | 冻结范围、版本化变更门禁和 10 章/20～30 章批次节奏 |
| [Factor Package V1.1 变更提案登记](FACTOR_PACKAGE_V1_1_CHANGE_PROPOSALS.md) | 第二批重复暴露的公共模型缺口、兼容方向和实现门禁 |
| [第二批 PDF Doc2Spec 抽取计划](BATCH_02_EXTRACTION_PLAN.md) | 第二批 10 章的固定选择、独立队列、命令与验收口径 |
| [第二批 PDF Doc2Spec 验收结果](BATCH_02_RESULT.md) | 第二批来源对账、生成指标、人工复核缺陷、诚实缺口与扩批结论 |
| [12 章跨因子依赖验证](CROSS_CHAPTER_DEPENDENCY_RESULT.md) | 真实引用、拓扑认领、Fixture SQL 顺序及隔离副本中的失效传播实验 |
| [第三批：20 个新章节与依赖正文](BATCH_03_EXTRACTION_PLAN.md) | 固定输入、章节选择与真实依赖边界 |
| [第三批阶段抽取结果](BATCH_03_EXTRACTION_PROGRESS.md) | 已落地章节、SQL 候选、待审核项及继续顺序 |
| [第四批：20 个新章节](BATCH_04_EXTRACTION_PLAN.md) | 完整批次输入、真实依赖与外部正文缺口 |
| [第四批抽取与有限域生成结果](BATCH_04_EXTRACTION_PROGRESS.md) | 20 章候选清单、静态检查证据与未关闭的审核项 |
| [第五批：程序对象、文本搜索与增量物化视图](BATCH_05_EXTRACTION_PLAN.md) | 20章新包、34章闭合来源输入与高风险能力门禁 |
| [第五批抽取与有限域生成结果](BATCH_05_EXTRACTION_PROGRESS.md) | 有限候选、依赖顺序、回归测试与明确保留的能力缺口 |
| [第六批：过程、触发器、规则和维护](BATCH_06_EXTRACTION_PLAN.md) | 20章固定输入、真实依赖与高风险边界 |
| [第六批抽取与有限域生成结果](BATCH_06_EXTRACTION_PROGRESS.md) | 无参数生成修复、专项测试与任务证据 |
| [第七批：类型、扩展与外部对象](BATCH_07_EXTRACTION_PROGRESS.md) | 26 个包的来源处置、有限 SQL 与支持性边界 |
| [第八批：数据库与工具命令](BATCH_08_EXTRACTION_PROGRESS.md) | 25 个包及无普通清单的运行时契约 |
| [第九批：身份、权限与安全标签](BATCH_09_EXTRACTION_PROGRESS.md) | 24 个包的角色、ACL 和专用对象生命周期 |
| [第十批：策略、事件与包](BATCH_10_EXTRACTION_PROGRESS.md) | 29 个包及密钥、DBLINK、外表的明确缺口 |
| [第十一批：分区、数据流与恢复](BATCH_11_EXTRACTION_PROGRESS.md) | 最后 25 个包、有限生成范围与未实现运行时 |
| [剩余129包交付结果](REMAINING_129_EXTRACTION_RESULT.md) | 95→224 包的最终对账、有限候选 SQL 与未关闭边界 |
| [PDF通用SQL进度与质量待办](PDF_GENERAL_EXTRACTION_BACKLOG.md) | 224章包已绑定、原文审计与未完成静态/行为验收的独立口径 |
| [Doc2Spec Extraction Rules V1](DOC2SPEC_EXTRACTION_RULES_V1.md) | 从产品原文抽取 source/factor/syntax/manifest 等文件的规则 |
| [PDF 到 Factor Package 权威流程](PDF_DOC2SPEC_PIPELINE.md) | 整本PDF目录、精确拆章、来源证据和五章校准门禁 |
| [内网批量 Doc2Spec 运行手册](INTRANET_AI_BATCH_EXTRACTION.md) | 文档不能外传时的语料切片、任务队列、AI协作和批量节奏 |
| [当前系统架构](ARCHITECTURE.md) | V1数据流、模块职责、覆盖结论和Legacy边界 |
| [路线图](ROADMAP.md) | 当前完成项、已知缺口和下一验收阶段 |

项目级快速开始见根目录 [README](../README.md)，内网 AI 的最短入口见 [INTRANET_AI_INSTRUCTIONS](../INTRANET_AI_INSTRUCTIONS.md)。

## Legacy 与历史资料

M 兼容历史批次：[环境准备与执行边界](M_COMPAT_ENVIRONMENT.md)、[第二批 18 章](M_COMPAT_BATCH_02.md)、[第三批进展](M_COMPAT_BATCH_03.md)、[第四批 20 章](M_COMPAT_BATCH_04.md)、[第五批及外部资产边界](M_COMPAT_BATCH_05.md)、[第六批：分区、Hint历史、回收站与OM审阅包](M_COMPAT_BATCH_06.md)、[六包生成缺口收敛](M_COMPAT_GENERATION_GAPS.md)、[共享合同及生成列消费者](SHARED_CONTRACT_INTEGRATION.md)。最新数量与验证范围见[当前演进记录](PROJECT_EVOLUTION_20260909.md)，不沿用早期批次1078条的旧数。GENERATED UPDATE SYSTEM仅供审阅，不加入普通用例或生成验收分子。M与通用模式独立统计；建包、有限生成、静态覆盖、实机验证不得混用，内部接口候选及未验证的文件/扩展资产单列。

以下文件保留用于理解和维护旧运行时，不再定义新的抽取格式：

| 文档 | 状态 |
|---|---|
| [Legacy V0三文件规格指南](SPEC_SPECIFICATION_GUIDE.md) | 仅维护 `grammars/matrices/manifests` |
| [Legacy V0 Doc2Spec指南](DOC2SPEC_EXTRACTION_GUIDE.md) | 旧提示词与旧输出目录 |
| [Legacy V0单文件因子指南](FACTOR_GUIDE.md) | 仅维护 `factors/` |
| [架构演进记录](EVOLUTION_PLAN.md) | 历史决策与当前落地对照 |
| [海量文档与GUC边界说明](LARGE_DOC_EXTRACTION_AND_GUC_GUIDE.md) | 当前入口和GUC未来建模边界 |

如当前权威文档与 Legacy 文档冲突，以 Factor Package Schema V1 和实际 Pydantic模型为准。
