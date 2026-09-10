# 2026-09-09 全项目限时演进

本窗口按用户要求持续到 **2026-09-09 17:00（北京时间）**，每10分钟续工。一个小批次完成后继续下一真实缺口，不自动停止整个窗口。只有本地生成和静态测试，没有数据库执行或Git提交推送。

**15:28用户变更：继续至一个大节点完成。** 当前节点定为本轮全项目静态验收：全部171测试模块在同一冻结输入上通过、全库生成/库存证据对齐、交付当前基线和真实缺口；完成后停止续工，不按原17点自动截断，也不无限扩张功能。该节点不是全书语义完整或数据库验证。

## 第一批：视图冲突更新目标限制

本地PDF一般INSERT的视图/子查询限制第7项，以及M INSERT的视图限制第6项，明确禁止ON DUPLICATE KEY UPDATE。原检查器仅在赋值含DEFAULT/VALUES/EXCLUDED时检查冲突分支：已知的3条负例只能得到待审；使用常量赋值的同类输入甚至得到有限checked。

现在增加独立目标守卫，复用实际fixture建立的有限视图身份或一般直接投影派生目标身份，不根据表名猜测。检查发生在输入DEFAULT解析前，且使用顶层子句定位，字符串及嵌套表达式不能伪造触发条件。M派生目标和未知来源范围仍待审，不借一般章节证据；旧DDL失效规则保持有效。

新增11项回归先复现14个失败分支；同步拆分两个历史断言，保留普通视图DEFAULT仍待审，只将文档明确禁止的组合认定为静态矛盾。随后20个相关模块 **214项通过，132.244秒**。这是本批源码指纹下的专项结果，不是全项目或数据库验收。

重新生成6包54manifest、272条用例，完整序列化字段与54份SQL快照字节均不变，Pairwise完整且ID无重复。独立核对全库5060条，仅以下3条既有负例的写入审计从needs_review变为rejected：

- manifest_insert_duplicate_view_negative_0e42d6d2bcf6
- manifest_insert_duplicate_view_negative_4ecaaefa7cd0
- manifest_m_insert_view_duplicate_negative_ff932306dd68

本批审计：4774不适用、252有限checked、25needs_review、9rejected；正向rejected=0。所有expected、生命周期、候选ID及SQL保留。**静态识别禁止组合不证明实际SQLSTATE或目标错误Oracle命中。**

证据：本地work/project_evolution_20260909_1700/view_conflict_audit.json，以及work/write_contract_loop_20260909/project_1700_view_conflict_verification.json。一般/M INSERT正文SHA与source.yaml一致，源码、审计及再生成报告哈希已对账。

## 后续队列与边界

第二批复现并修复了查询输出共享helper使用zip时静默截短类型列表的问题；独立渲染SUM入口此前可漏检后续投影。主生成器结构层已经检查长度，不能据此说已有SQL生成错误。两个共享函数各增加投影/输出类型及源列/源类型的长度保护，不改变函数身份、模式、类型推断或公共YAML模型。

新增8项测试先复现8个失败分支，再通过；9模块相关消费者回归 **77项通过，55.921秒**，包括M SUM实际fixture/来源、直接投影、INSERT SELECT、共享列及视图目标。与第一批214项有重叠且源码指纹不同，不能简单累加为291项独立最终回归。

本批重新生成8包73manifest、407条用例，完整字段与73份SQL快照字节不变；Pairwise完整、ID无重复。包括第一批6个写入包及select、m_select。证据在本地work/project_evolution_20260909_1700/query_batch_verification.json；第一批证据保留原源码指纹，不覆盖。

之后按真实影响选择一般/M包级缺口、有限REPLACE新行顺序、视图DEFAULT来源、查询输出、索引能力、Fixture与目标Oracle。登记、能生成、有限静态、实机状态分开展示。16:30开始收尾验证；17:00保存剩余工作并暂停续工。

## 第三批：一般CREATE INDEX的受限可见性代表

新增一个清单、两个候选：在A模式、关键字禁用列表为空、完全非升级中，创建普通ASTORE整数BTREE索引，分别指定VISIBLE和INVISIBLE。使用独占新schema中的新表；无预DROP/CASCADE，无GUC修改，不执行数据库。具体声明规则见[选中值环境前提](SELECTED_ENVIRONMENT_CAPABILITIES.md)。

原文L666–683的定义、模式、关键字禁用、升级阶段已分别落到事实；原两个各含3条环境条件的source unit拆开，账本209→213，899行正文和来源SHA不变。保留原宽泛conditional取值，新增明确受限的两个valid facet，不放宽positive加载规则、不通过换suite绕过检查。因此一般全部候选包的76个宽域取值缺口仍为76；不能把两条代表说成可见性全域完成。

全库已重新生成 **773份快照、5062条唯一用例**，其中一般3954、M1108。独立对账确认原772份SQL字节和原5060条完整case字段全部不变，只有这2条新增；一般冻结528份、明确新增17份的批准账本核对通过。元数据场景仍planned，目录接口和错误身份尚待校准，没有把索引存在或空表EXPLAIN当作可见性证明。

累计M有限生成/来源审计重新运行通过，仍93登记/92有限生成、1108候选，不是M全章或数据库验证。专项曾因既有总数断言未同步而失败，已按明确新增2条同步342总数/312正向/30负向。最终6模块（含完整V1模块）78项测试通过，耗时674.932秒；回执38ea48，退出0。测试结束后重新核对代码、规格和生成报告指纹，与visibility_verification.json一致。本批只验收受限候选及静态保护，不包含实机验证。

本地证据为visibility_baseline.json、visibility_verification.json、visibility_write_audit.json；均在work/project_evolution_20260909_1700。第三批当时写入审计5062=4776不适用+252有限checked+25待审+9静态矛盾，正向静态矛盾0。一般包缺口对账见work/overnight_dual_20260908/general_gap_project_1700_visibility.json。

## 第四批：M REPLACE有限新输入顺序

实际两条既有候选为`REPLACE [INTO] m_replace_target SET id=id+1, qty=id`。完整fixture中id默认2、qty默认9；种子行(1,10)、(2,20)不是这次的新输入。M REPLACE正文L21–27、L65–67明确先从默认值读取，再从左到右赋值，所以有限输入依次为id=3、qty=3。已有场景的(3,3) Oracle保持planned；本批没有执行它，也没有证明删除旧行、唯一键冲突或影响行数。

只对M REPLACE SET、完整普通表和不同的无前缀目标列，加入整数列引用及列+1。每次赋值复用共享类型、NULL和范围检查，最后再次验证整行；常量/DEFAULT保留原机制。一般REPLACE、M INSERT SET、UPDATE不借用该规则。动态默认、隐式零值、非整数引用、重复目标、限定列、任意表达式、失效DDL及溢出/提升行为继续待审，不新增通用表达式求值器。

新增15项回归覆盖顺序互换、先前赋值、NULL、DEFAULT、目标和源范围、缺列、5000个前导零及失效身份。其中宽目标掩盖源运算溢出的反例先失败，再补前后源范围保护。最终16模块 **155项通过，39.058秒**（f0ca5a）；这是本批相关回归，不与此前批次数字直接相加。

重新生成6包54manifest、272条完整用例，字段、SQL字节、ID与Pairwise均保持不变（36de75）。全库5062条逐ID对账，仅以下2条从needs_review变为有限checked，其他5060条审计记录完全不变：

- manifest_m_replace_set_8841f7257e25
- manifest_m_replace_set_d385ddb74a7d

最新写入审计：4776不适用、254有限checked、23待审、9静态矛盾；正向矛盾0。生命周期计数不变。来源、源码、规格、生成报告及审计SHA已绑定到`work/project_evolution_20260909_1700/replace_sequence_verification.json`（9adeb8）。本批没有改YAML结构、实际SQL、expected、fixture或Oracle状态。

## 第五批：一般INSERT IGNORE的目标分支

一般INSERT原文L30–40的表目标产生式含IGNORE，L42–48的视图/子查询目标产生式不含。规格已有`insert_rule_ignore_target_supported`和两条负例，但渲染SQL的独立检查器只返回statement_not_supported，没有消费已知目标限制。

现在仅在general来源中识别该入口，复用完整fixture的视图身份或有限直接投影派生身份，给出`ignore_target_not_supported`静态矛盾。不删除IGNORE后按普通INSERT放行，不把名称像视图的表当成视图；M及未知来源、不完整/失效身份和复杂派生查询仍待审。原清单B/5.7/s1环境门、error预期及needs_verification Oracle全部保留。

8项新增回归先复现3项失败；最终17模块 **163项通过，39.164秒**（836254）。受影响54manifest/272条完整用例及SQL字节、Pairwise、ID不变（f31c7d）。全库逐ID仅`manifest_insert_ignore_view_negative_65161caef160`和`manifest_insert_ignore_view_negative_008f8d5cfb98`从待审变为静态矛盾，其他5060条审计记录不变。

第五批最新审计：4776不适用、254有限checked、21待审、11静态矛盾；正向矛盾0、生命周期不变。证据`work/project_evolution_20260909_1700/ignore_target_verification.json`（508703）。这是按文档识别已有负向规则，不是数据库错误Oracle已验证。

## 第六批：双列MODIFY检查实际前置

现有`manifest_alter_table_modify_multi_fresh`的目标为`MODIFY (note VARCHAR(96), amount NOT NULL)`。失败回归发现，仅改实际setup为amount含NULL、note原长128或加入索引依赖，而不改provides，生成器仍会接受。此前已人工检查的固定用例没有坏；缺口是后续输入变化时不能守住已声明的有限范围。

现在把[双列MODIFY前置合同](MODIFY_COLUMN_PREREQUISITES.md)接入实际选中表profile，复用旧DDL、字面量类型/范围/长度检查。只接受一般章节的无依赖普通新表、严格VARCHAR扩长及另一列NOT NULL，逐行排除NULL/DEFAULT；保留未知编码、收窄、其他语法及动态/依赖对象边界。新增11项回归覆盖helper和真实生成消费者。

最终12模块 **94项通过，78.465秒**（b4624d）；重新生成11包134manifest、1079条完整用例，字段、134份SQL快照字节、ID、Pairwise均不变（8ec2c2）。全库5062条写入/生命周期审计记录与第五批完全相同（76edf3），没有因为新增非写入检查改变写入通过数量。

证据：`work/project_evolution_20260909_1700/modify_batch_verification.json`、`modify_write_audit.json`。源码、实际ALTER TABLE正文SHA和全部该包规格已绑定；generation_report仍d7d13fb2…，未覆写旧SQL。该场景继续planned，未执行数据库。各批回归对应不同源码阶段，不合并成一次全项目最终测试。

## 第七批：共用有限种子入口

把同类前置校验集中到ADD、RENAME/CHANGE、MODIFY共用的fresh-fixture入口。原入口仅凭INSERT的有限形状会接受未求值的列引用和超出原字符串宽度的种子；现在解析真实全宽字面量行并按旧列定义统一验证。查询/部分列种子保留为这项合同未覆盖，不因此宣布产品不支持；NULL仍允许用于可空ADD/RENAME，仅在MODIFY要求NOT NULL时拒绝。

新增5项边界回归先复现10个失败分支；最终13模块 **99项通过，78.346秒**（dfd65a）。11包134manifest、1079条完整用例和快照不变（4751ab），全库5062条审计记录不变（d816d3）。证据为同工作目录下`fresh_fixture_batch_verification.json`和`fresh_fixture_write_audit.json`。第六批原始源码指纹保留，未覆盖为新代码证据。

随后冻结产品、规格、测试和生成输入，两组互不重叠的全量本地回归均通过：108模块901测试（1162.826秒），57模块394测试（1321.316秒），合计165模块1295测试。8865个输入的A开始/A结束/B开始/B结束指纹一致；收据位于`work/project_evolution_20260909_1700/frozen_static_a/receipt.json`、`frozen_static_b/receipt.json`及`frozen_suite_result.json`。这是七批修改结束时的冻结版本，不覆盖13:55之后的新修改，也不是数据库验证。历史153模块/1166测试基线保留，不改写为本次结果。

## 第八批：歧义规则回到待审，保全候选历史

原PDF物理1737/1738、1741、1743、1744页核读发现：`subquery`是插入目标，`query`是SELECT输入；ON CONFLICT限制末条仅写“不支持插入子查询”，未明确指代。旧factor将其提升为禁止query输入的confirmed硬规则，源账本与负例沿用了这一解释。现在L367单独转open_question；L357–366其他明确限制保持confirmed，未经证实的硬过滤撤销。

原负例移入`scenario_insert_conflict_query_review`，planned、不可执行、Oracle未校准；完整SQL/setup/teardown/PG门/原错误类别及ID保全。原manifest归档到`archive/spec_reviews/20260909/insert/`，旧SQL原路径和字节保留。不是将负例改成成功，也不是删除失败用例。4项来源/入口/历史保全回归先失败（9db806），修改后通过（9abec3）。

内存反事实与全库预览（1de678）证明，仅这一条候选退出活跃生成；其他5061条完整case和772份活跃SQL字节不变。正式生成成功7e6e67；独立库存对账681fce：772活跃manifest、5061活跃case，另1份历史SQL/1历史case，物理773份SQL。INSERT活跃100正向/10负向，待审问题7→8。不能以物理文件数代替活跃能力数。

生成器原有的`existing.unlink()`会误删需保留的历史SQL，已改成发布前分类检查：未登记多余SQL失败、已验证历史保留、部分生成不误删其他清单。3项新增保护回归从缺函数失败到通过；库存11项检查验证来源问题、planned状态、不可执行、完整case哈希及原文件身份。发现归档不在回归指纹范围后用e5fb03复现假通过，新增`archive/spec_reviews`输入目录；共27项库存/保护/收据专项通过4ad1e2。

本阶段写入审计：5061=4776不适用＋253有限checked＋21待审＋11静态矛盾，正向矛盾0；生命周期4731待审/330有限事务形状。checked减少1只是候选回到历史，不是新增质量结论；fd155a证明其余5061条审计记录完全不变。证据为同工作目录下`retirement_delta_verification.json`、`candidate_inventory.json`、`retirement_write_audit.json`。更广的11模块回归最终125测试通过，1075.315秒，8871输入前后一致，归档已纳入指纹（f0d7b6/e6e7ca，`retirement_regression/receipt.json`）。

机制及命令见[候选回到待审与历史保全](CANDIDATE_REVIEW_RETIREMENT.md)。当前批仍无数据库执行、无Git提交推送。

## 第九至十一批：六条明确限制的独立静态守卫

- INSERT：一般视图/派生目标不能带ON CONFLICT（两条既有负例）；外层WITH/WITH RECURSIVE不能带ON DUPLICATE（一条）。用实际目标身份、已解析的外层CTE和顶层子句判断，M/未知来源、字符串与嵌套不借一般规则。14模块153测试通过，29.747秒。
- UPDATE：多列SET子查询自身的顶层ORDER BY/LIMIT，以及多表更新中的已确认命名视图目标（两条）。保留单列子查询、外层排序、普通表与M边界。CTE重入显式传递外层来源模式，避免内层默认为一般模式；原setup对象不重建。16模块174测试通过，26.494秒。
- ON DUPLICATE内联主键：按实际完整普通DDL的PRIMARY KEY判定目标列，覆盖常量/VALUES/DEFAULT/同列和未知函数RHS，不按id列名或fixture标签猜测（一条）。普通UPDATE、ON CONFLICT、M和未知来源不套用该限制；额外索引/命名空间/opaque前置需单独合同，未建设完整唯一索引目录。17模块181测试通过，27.876秒。

各批都有先失败后通过的回归；各自重生成53清单271条相关case完整字段和SQL不变，阶段指纹分别保存在`insert_feature_regression`、`update_feature_regression`、`primary_key_regression`及对应生成对账文件，不能相加或互相覆盖为全量结果。

15:03前完成全库重新生成至work预览：**5061条活跃case、772份活跃SQL、GenerationReport与factor_coverage均与正式产物一致**。独立写入审计逐ID只改变上述六条原负例，当前4776不适用/247有限checked/21待审/17静态矛盾，正向矛盾0。所有负例仍保留原预期，**静态矛盾不证明目标SQLSTATE命中**。1条query/subquery歧义候选仍在历史待审，不能通过这六条守卫复活硬禁令。

全库证据：`work/project_evolution_20260909_1700/final_feature_verification.json`及`primary_key_audit.json`。正式generation_report SHA为`eaeffccc6c3979201d25216a27201f2738f67c9fc55428a31139f52237c3c792`。随后冻结全部产品输入，启动171模块的最终全量回归（114＋57）；**结果仍待实际收据**，不把七批冻结版1295或本批181专项当成最终全量结果。

## 冻结期间的剩余缺口对账

15:09起仅只读核对当前注册表、正式生成报告及相关matrix/scenario，不重抽全书、不改规格状态。逐包清单在`work/project_evolution_20260909_1700/remaining_gap_rollup.json`；它绑定上述generation_report SHA，不是新的数据库或全章语义证明。

| 口径 | 一般模式 | M模式 |
| --- | ---: | ---: |
| 登记包 | 224 | 93 |
| 有活跃候选的包 | 169 | 92 |
| 无普通manifest的包 | 55 | 1 |
| 活跃manifest / case | 544 / 3953 | 228 / 1108 |
| 有限生成模型完成包 | 159 | 92 |
| 报告整章静态完成包 | 3 | 0 |
| 本窗口数据库验证 | 0 | 0 |

以下gap计数仅来自261个有候选包，规则、取值、feature和Oracle分母不同且相互重叠，不能相加为遗漏SQL总数：

- 一般：规则gap 1、取值gap 76、feature gap 804、未校准错误Oracle涉及100个manifest。
- M：规则gap 0、取值gap 0、feature gap 17、未校准错误Oracle涉及34个manifest。
- 按审计detail互斥分类（先needs_profile，再missing_refs，再represented）：一般804＝548缺profile＋4存在但未完整选中的特征＋252已有代表但不承诺全域；M17＝8缺profile＋9已有代表但不承诺全域。**feature gap不等于该功能完全没有SQL。**

真实下一步按依赖处理，不以改状态清零：

1. 剩余21条有限写入待审：16条视图/派生目标DEFAULT，2条生成列DEFAULT，2条生成列省略输入，1条ON DUPLICATE复杂表达式。优先复核视图列默认来源合同；基表列血缘并不能单独证明视图继承DEFAULT。每个合同需来源、反例、最小消费者和受影响用例对账，不能把16条批量标checked。
2. 一般唯一规则gap在CREATE SEQUENCE系统列OWNED BY负向目标。现有专用matrix/scenario明确缺真实rowid/rowno身份及目标错误证据。普通表缺列错误、或人为创建同名用户列不能替代这项限制；先补目标表形证据，不直接往negative清单塞SQL。
3. M的17项feature gap集中在PREPARE（15）和SET（2）。PREPARE已有8类代表、7类缺profile；SET已有赋值代表、扩展值域缺profile。后续按实际内层命令和会话依赖补代表；不通过将coverage_mode从representative改all假装完整。
4. 一般4项未完整选中特征分别涉及ALTER TABLE分区表空间负例、DELETE宽域USING目标、UPDATE/DELETE CURRENT OF。已有受控代表不覆盖宽域，游标仍需要会话/事务前置。不是4条简单漏选binding，更不能加入无对应fixture的SQL。
5. 55个一般无普通清单包沿用实际资产路由：当前形式限制6、内部工具协议15、外部资产14、隔离管理生命周期14、模型/计划语义6。另有1个M审阅包。旧路由中的LOAD DATA已进入候选，不能继续计入无清单分母；路由标签不是统一“不支持”。

上述都是下一阶段入口，不是本窗口已补齐或实机失败的结论。最终全量回归仍以在途作业的真实收据为准。

进一步只读复核了两种模式的ALTER VIEW正文：一般L80–81（SHA90553d8d…），M L61–62（SHA70f9aca1…）都将SET/DROP DEFAULT描述为“暂无实际意义”。这只限定该ALTER参数的文档说明，不能外推所有INSERT/UPDATE的DEFAULT结果，也不能绕过视图/派生目标身份。`work/project_evolution_20260909_1700/view_default_review_dossier.json`保存16条待审候选的完整原字段、逐case哈希、两份正文来源哈希及下一步证据要求；没有新增或执行校准SQL，没有修改候选或预期。后续实验必须区分基表默认、视图参数、显式NULL、省略输入和旧种子行，避免一次“CREATE成功”替代行为验证。

## 最终静态节点验收

15:03那组最终回归实际944项中1失败：新的一般UPDATE视图禁令与旧test_multi_derived_contract期待review冲突；原失败收据保留，B未启动。独立复现后仅修改测试：一般精确验证multi_update_view_not_supported，M/未知来源仍验证同基表target_unknown，并将原schema歧义另列测试。不修改生产代码、规格、SQL或候选预期。

随后15:32:54–16:16:23完整重跑171模块，A114模块945测试1205.745秒、B57模块394测试1403.131秒，共**1339项全部通过**。旧工具会话句柄中途失效，但实际进程继续，B原始收据和日志保存完整。外层汇总缺失，独立从两组真实收据重建，明确保留wrapper退出状态未知，不捏造其退出码。

`milestone_acceptance_evidence.json`终验e1a961证明两组无漏选/重叠，原日志和起始记录哈希一致，8874输入四端及终验当前相同；`milestone_artifact_verification.json`证明与旧失败版相比只改一个测试文件，772/5061活跃资产与1/1历史资产及全部源/生成器证据保持一致。上述文件位于`work/project_evolution_20260909_1700/`，失败及较早阶段收据未覆盖。

当前唯一交付说明见[全项目静态验收节点](MILESTONE_STATIC_ACCEPTANCE_20260909.md)。这结束的是本轮静态验收，不是21条写入待审、全部语义/Oracle或数据库行为闭环；没有数据库执行和Git提交推送。
