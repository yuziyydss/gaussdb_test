# 文档索引

## 当前权威文档

| 文档 | 用途 |
|---|---|
| [Full-Document Catalog V1](FULL_DOCUMENT_CATALOG.md) | 83个本地catalog合并后的权威全书目录：5,686页、49页front matter、5,637/5,637正文页、515个唯一章节与来源哈希审计 |
| [Non-SQL Reference Schema V1](NON_SQL_REFERENCE_SCHEMA_V1.md) | 67个非SQL参考YAML、885条facts的类型化Schema：分类、来源哈希、状态审计与3条未决项 |
| [GUC Reference Schema V2](GUC_REFERENCE_SCHEMA_V2.md) | 权威7.3全章GUC参考目录：1,177个定义、1,175个唯一参数、82个小节、20/20 V1 pilot对齐与重复定义显式保留 |
| [GUC Candidate Matrix V1](GUC_CANDIDATE_MATRIX_V1.md) | 从GUC V2派生的候选准入矩阵：158个布尔USERSET候选、7个confirmed fact下一批评审项、1个needs_verification延期项 |
| [GUC Environment V2](GUC_ENVIRONMENT_V2.md) | 20项V1试点扩展至27项；新增5个session overlay、2个人工复核参数，保留捕获/应用/验证/恢复安全边界 |
| [GUC Overlay Plan Export V1](GUC_OVERLAY_PLAN_EXPORT_V1.md) | 19个session overlay计划、95个SQL步骤、8个排除项与来源哈希；静态计划不是执行收据 |
| [GUC API V1](GUC_API_V1.md) | `/guc` 页面与 `/api/guc/v2/*` 路由：参数过滤、计划JSON与SQL导出；不连接数据库 |
| [GUC V2 Audit](GUC_V2_AUDIT.md) | 14项跨层静态检查：参数身份、候选对齐、计划覆盖、策略隔离与SQL边界 |
| [GUC V2 Preflight](GUC_V2_PREFLIGHT.md) | 27个只读current_setting查询、值域匹配与失败关闭结果；不修改GUC、不执行目标SQL |
| [GUC V2 Preflight Audit](GUC_V2_PREFLIGHT_AUDIT.md) | Preflight结果与计划身份、查询SQL、计数和状态边界的独立审计 |
| [GUC V2 Evidence Bundle](GUC_V2_EVIDENCE_BUNDLE.md) | 15个证据产物、11个当前存在、4个缺失，静态/Preflight/Runtime三层完整性清单 |
| [GUC V2 Capability Adapter](GUC_V2_CAPABILITY_ADAPTER.md) | 19个session overlay能力、38个允许值、runtime fact绑定与overlay计划；尚未写入Factor Package |
| [GUC V2 Requirement Adapter](GUC_V2_REQUIREMENT_ADAPTER.md) | 9个可转换环境门禁、8个缺fact阻断、2个空值阻断；不修改specs |
| [GUC V2 Requirement Resolver](GUC_V2_REQUIREMENT_RESOLVER.md) | 场景`guc_*`门禁静态解析、Capability Plan绑定与失败关闭；不执行SQL |
| [GUC V2 Execution Selector](GUC_V2_EXECUTION_SELECTOR.md) | 从已解析门禁选择具体GUC值并生成五步overlay计划；仍不执行SQL |
| [Advanced Package Evidence Bundle](ADVANCED_PACKAGE_EVIDENCE_BUNDLE.md) | 高级包Pilot V1证据清单：22/22个支持包、251个接口、27个runtime候选与缺失receipt |
| [Advanced Package Runtime Plan API](ADVANCED_PACKAGE_RUNTIME_PLAN.md) | `/api/advanced-package/runtime-plan`：29个单元、37个SQL步骤与授权边界；只读dry-run |
| [Advanced Package Runtime Candidate Coverage API](ADVANCED_PACKAGE_RUNTIME_CANDIDATE_COVERAGE.md) | `/api/advanced-package/runtime-candidate-coverage`：39个候选接口、39个已覆盖接口、0个覆盖缺口 |
| [Advanced Package Static Chain](ADVANCED_PACKAGE_CHAIN.md) | 一键重建Runtime Dry Run与Evidence Bundle，并用`--check`校验哈希；不执行SQL |
| [Advanced Package Execution Gate](ADVANCED_PACKAGE_EXECUTION_GATE.md) | 静态证据、runtime plan、授权与数据库启用分层门禁；不伪造执行许可 |
| [Advanced Package Candidate Matrix](ADVANCED_PACKAGE_CANDIDATE_MATRIX.md) | 22个DBE包扩展矩阵：22个已建模、0个未建模、294个相关facts |
| [Advanced Package Policy Audit](ADVANCED_PACKAGE_POLICY_AUDIT.md) | 新增8包覆盖与策略复审：99/99 distinct callable、126/126签名已建模、38个已case化runtime candidate、6个首批block |
| [Advanced Package Runtime Preflight](ADVANCED_PACKAGE_RUNTIME_PREFLIGHT.md) | 27个runtime case的只读前置计划与Result/Audit模型：8个SELECT查询、77个candidate接口 |
| [Core Type & Expression Extraction V1](CORE_TYPE_EXPRESSION_EXTRACTION_V1.md) | 1.3类型、1.7表达式、1.8伪列、1.9类型转换细抽取：38章、122页、99个facts |
| [Core Function & Operator Extraction V1](CORE_FUNCTION_OPERATOR_EXTRACTION_V1.md) | 1.6核心函数与操作符细抽取：16章、312页、102个facts |
| [Core Function & Operator Wave 2A](CORE_FUNCTION_OPERATOR_WAVE2A_V1.md) | 1.6剩余高价值函数抽取：13章、112页、45个facts |
| [Core System Management Wave 2B-1](CORE_SYSTEM_ADMIN_WAVE2B1_V1.md) | 1.6.27配置/文件/信号函数细抽取：5页、20个facts |
| [Core System Management Wave 2B-2](CORE_SYSTEM_ADMIN_WAVE2B2_V1.md) | 1.6.27备份/恢复/容灾控制函数细抽取：21页、30个facts |
| [Core System Management Wave 2B-3](CORE_SYSTEM_ADMIN_WAVE2B3_V1.md) | 1.6.27容灾查询/快照/对象函数细抽取：12页、20个facts |
| [Core System Management Wave 2B-4](CORE_SYSTEM_ADMIN_WAVE2B4_V1.md) | 1.6.27咨询锁/逻辑复制基础细抽取：16页、28个facts |
| [Core System Management Wave 2B-5A](CORE_SYSTEM_ADMIN_WAVE2B5A_V1.md) | 逻辑复制area changes/槽状态/并行解码细抽取：21页、21个facts |
| [Core System Management Wave 2B-5B](CORE_SYSTEM_ADMIN_WAVE2B5B_V1.md) | 1.6.27.10剩余replication origin/SQL apply/回放跳过：14页、29个facts |
| [Core System Management Wave 2B-6](CORE_SYSTEM_ADMIN_WAVE2B6_V1.md) | 段页式存储函数细抽取：22页、25个facts |
| [Core System Management Wave 2B-7](CORE_SYSTEM_ADMIN_WAVE2B7_V1.md) | hashbucket与Undo系统函数细抽取：19页、28个facts |
| [Core System Management Wave 2B-8](CORE_SYSTEM_ADMIN_WAVE2B8_V1.md) | 行存压缩与HTAP系统函数细抽取：23页、17个facts |
| [Core System Management Wave 2B-9](CORE_SYSTEM_ADMIN_WAVE2B9_V1.md) | 1.6.27.16 NVMe系统函数细抽取：9页、11个facts |
| [Core System Management Wave 2B-10](CORE_SYSTEM_ADMIN_WAVE2B10_V1.md) | 1.6.27.17其它函数首批：计划缓存、会话线程、WDR/ASP与I/O诊断细抽取：10页、29个facts |
| [Core System Management Wave 2B-11](CORE_SYSTEM_ADMIN_WAVE2B11_V1.md) | 1.6.27.17其它函数第二批：刷脏、buffer、回放、全局SQL与COPY错误表细抽取：9页、35个facts |
| [Core System Management Wave 2B-12](CORE_SYSTEM_ADMIN_WAVE2B12_V1.md) | 1.6.27.17其它函数第三批：功能开关、页面解析、Xlog dump、UBTree与WAL统计细抽取：13页、26个facts |
| [Core System Management Wave 2B-13](CORE_SYSTEM_ADMIN_WAVE2B13_V1.md) | 1.6.27.17其它函数第四批：目录文件、AntiCache/Vlog、UStore统计、页面重放与GIN清理细抽取：12页、25个facts |
| [Core System Management Wave 2B-14](CORE_SYSTEM_ADMIN_WAVE2B14_V1.md) | 1.6.27.17其它函数第五批：空间/膨胀率估算与备机WAL接收写入统计细抽取：8页、13个facts |
| [Core System Management Wave 2B-15](CORE_SYSTEM_ADMIN_WAVE2B15_V1.md) | 1.6.27.17其它函数第六批：GSTrace、主降备耗时与tcache清理收尾：10页、21个facts |
| [Core System Management Wave 2B Summary](CORE_SYSTEM_ADMIN_WAVE2B_SUMMARY_V1.md) | 1.6.27系统管理函数Wave 2B汇总：213页全覆盖、17个子节、378个facts、33个open questions |
| [Core SPM Plan Management Wave 3-1](CORE_SPM_PLAN_WAVE3_1_V1.md) | 1.6.28 SPM计划管理函数首轮抽取：9页、9个接口、21个facts |
| [Core Statistics Functions Wave 4-1](CORE_STATISTICS_WAVE4_1_V1.md) | 1.6.29统计信息函数首批：恢复冲突、复制、锁、数据库/表统计与autovacuum：10页、33个facts |
| [Core Statistics Functions Wave 4-2](CORE_STATISTICS_WAVE4_2_V1.md) | 1.6.29统计信息函数第二批：会话/后端统计、重置、控制组、黑匣子与plan trace：14页、45个facts |
| [Core Statistics Functions Wave 4-3](CORE_STATISTICS_WAVE4_3_V1.md) | 1.6.29统计信息函数第三批：VACUUM进度、负载/会话统计、Unique SQL、Paxos与WLM：9页、36个facts |
| [Core Statistics Functions Wave 4-4](CORE_STATISTICS_WAVE4_4_V1.md) | 1.6.29统计信息函数第四批：DBE_PERF全局/汇总统计、文件I/O、复制、线程池与按需读队列：10页、55个facts |
| [Core Statistics Functions Wave 4-5](CORE_STATISTICS_WAVE4_5_V1.md) | 1.6.29统计信息函数第五批：回放耗时、Xlog类型统计、内存上下文、线程栈与火焰图采集：12页、20个facts |
| [Core Statistics Functions Wave 4-6](CORE_STATISTICS_WAVE4_6_V1.md) | 1.6.29统计信息函数第六批：火焰图查询/清理与性能抖动监控：11页、23个facts |
| [Core Statistics Functions Wave 4-7](CORE_STATISTICS_WAVE4_7_V1.md) | 1.6.29统计信息函数第七批：线程内存/线程池统计、会话GUC、WAL预解析与资源池统计：7页、24个facts |
| [Core Statistics Functions Wave 4-8](CORE_STATISTICS_WAVE4_8_V1.md) | 1.6.29统计信息函数第八批：WLM空间/会话、极致RTO、回放冲突与WAL统计：9页、19个facts |
| [Core Statistics Functions Wave 4-9](CORE_STATISTICS_WAVE4_9_V1.md) | 1.6.29统计信息函数第九批：延迟DDL、PL/SQL内存统计与分区汇总统计：8页、14个facts |
| [Core Statistics Functions Wave 4-10](CORE_STATISTICS_WAVE4_10_V1.md) | 1.6.29统计信息函数第十批收尾：单字段分区统计、ALT状态、内存profiling与jemalloc：4页、21个facts |
| [Core Statistics Functions Wave 4 Summary](CORE_STATISTICS_WAVE4_SUMMARY_V1.md) | 1.6.29统计信息函数Wave 4汇总：89页全覆盖、10个批次、290个facts、20个open questions |
| [Core System Function Extraction Summary](CORE_SYSTEM_FUNCTION_EXTRACTION_SUMMARY_V1.md) | 1.6.26–1.6.29系统函数跨章节汇总：341页全覆盖、31个批次、811个facts、63个open questions |
| [Core System Information Functions Wave 5-1](CORE_SYSTEM_INFO_WAVE5_1_V1.md) | 1.6.26系统信息函数首批：上下文、会话/连接、版本/节点、编码与内存明细：12页、37个facts |
| [Core System Information Functions Wave 5-2](CORE_SYSTEM_INFO_WAVE5_2_V1.md) | 1.6.26系统信息函数第二批：对象/角色/ANY权限查询：8页、22个facts |
| [Core System Information Functions Wave 5-3](CORE_SYSTEM_INFO_WAVE5_3_V1.md) | 1.6.26系统信息函数第三批：模式可见性、对象定义、类型/序列/表空间与注释：8页、32个facts |
| [Core System Information Functions Wave 5-4](CORE_SYSTEM_INFO_WAVE5_4_V1.md) | 1.6.26系统信息函数第四批收尾：事务ID/快照、控制状态、内存/文件/WLM与内核信息：7页、31个facts |
| [Core System Information Functions Wave 5 Summary](CORE_SYSTEM_INFO_WAVE5_SUMMARY_V1.md) | 1.6.26系统信息函数Wave 5汇总：33页全覆盖、4个批次、122个facts、8个open questions |
| [Core Expression Candidate Chain V1](CORE_EXPRESSION_CANDIDATE_CHAIN_V1.md) | Wave 1A/1B/2A事实→fixture→静态SQL候选：246个facts、171个candidates |
| [Core Expression Probe Plan V1](CORE_EXPRESSION_PROBE_PLAN_V1.md) | 静态SQL probe第一批dry-run：150筛94、无fixture、只读 |
| [Core Expression Probe Batches V1](CORE_EXPRESSION_PROBE_BATCHES_V1.md) | 94个SQL probe拆成4个授权审查批次：dry-run only |
| [Core Expression Batch 01 Execution V1](CORE_EXPRESSION_BATCH01_EXECUTION_V1.md) | Batch 01执行计划与receipt audit：23步、dry-run only |
| [Core Expression Batch Execution Plans V1](CORE_EXPRESSION_BATCH_EXECUTION_PLANS_V1.md) | 四个probe批次的统一execution plan与receipt audit schema |
| [Core Expression Oracle Draft V1](CORE_EXPRESSION_ORACLE_DRAFT_V1.md) | 94个SQL probe的expected oracle草案：0个具体值声明 |
| [Core Expression Oracle Review Sheet V1](CORE_EXPRESSION_ORACLE_REVIEW_SHEET_V1.md) | 94个oracle草案的人工复核清单：14个能力域、94个pending |
| [Core Expression Oracle Review Decisions V1](CORE_EXPRESSION_ORACLE_REVIEW_DECISIONS_V1.md) | 94项oracle决策登记：基线94 pending、0 confirmed |
| [Core Expression Oracle Promotion V1](CORE_EXPRESSION_ORACLE_PROMOTION_V1.md) | executable oracle promotion：0 confirmed、0 promoted、94 excluded |
| [Core Expression Oracle Assertion Authoring V1](CORE_EXPRESSION_ORACLE_ASSERTION_AUTHORING_V1.md) | executable oracle断言编写清单：0 promoted、4类允许断言 |
| [Core Expression Oracle Capture V1](CORE_EXPRESSION_ORACLE_CAPTURE_V1.md) | 94个SQL probe的标准evidence capture槽位：94 pending |
| [Core Expression Oracle Capture Ingestion V1](CORE_EXPRESSION_ORACLE_CAPTURE_INGESTION_V1.md) | 已审计batch receipt到capture slots的转换与hash |
| [Advanced Package Runtime Plan API](ADVANCED_PACKAGE_RUNTIME_PLAN.md) | `/api/advanced-package/runtime-plan`：29个单元、37个SQL步骤与授权边界；只读dry-run |
| [Advanced Package Runtime Candidate Coverage API](ADVANCED_PACKAGE_RUNTIME_CANDIDATE_COVERAGE.md) | `/api/advanced-package/runtime-candidate-coverage`：39个候选接口、39个已覆盖接口、0个覆盖缺口 |
| [GUC V2 Static Chain](GUC_V2_CHAIN.md) | 一键重建8层静态证据链；不连接数据库、不执行Preflight或Runtime Pilot |
| [GUC V2 Readiness](GUC_V2_READINESS.md) | 静态、Preflight、授权与运行时证据四层分离；当前ready_for_authorized_execution=false |
| [GUC V2 Runtime Pilot](GUC_V2_RUNTIME_PILOT.md) | 19个GUC overlay单元、95个SQL步骤、显式授权与恢复边界；当前仅dry-run，不是执行回执 |
| [GUC V2 Runtime Receipt Audit](GUC_V2_RUNTIME_RECEIPT_AUDIT.md) | 回执与计划哈希、单元/步骤计数、恢复边界和SQL安全审计；当前无回执 |
| [GUC V2 Execution Gate](GUC_V2_EXECUTION_GATE.md) | 技术就绪、显式授权与数据库可用三层门禁；当前因Preflight缺失而阻断 |
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
