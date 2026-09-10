# 夜间演进：9月9日16:32至9月10日09:00

本窗口按完整功能批次推进，每5分钟恢复检查，固定截止09-10 09:00。截止后的首次心跳于09:01进行终止收尾，未在截止后启动新作业，无在途作业。以下是已验收批次，不代表整个因子库完成，也不是数据库执行验收。所有运行使用 `GAUSSDB_ENABLED=false`，没有数据库连接、Git提交推送或历史资产删除。

## 08:26最新验收：全项目最终静态回归通过

07:32:59至08:24:10完成全实际215个测试模块、1682项测试，四个顺序分片分别为683、605、220、174项，全部通过，无跳过或预期失败。总进程收据时间3071.651秒，约51分12秒；这是当前冻结输入上的新全量结果，不是把历史相关回归拼成通过数。

独立核验每个命令的模块集合、原始日志、启动记录及收据SHA，并重新计算当前9098个纳入范围的输入文件指纹：各片前后、跨片及核验时输入一致，215模块恰好执行一次。正式生成报告仍为817个manifest、5187条case、5100种目标SQL文本，没有在测试期间修改输入。指纹端点一致不提供“编辑后还原”的检测能力；本窗口实际保持冻结。

原始总收据：`work/project_evolution_20260910_0900/final_shards_result.json`，SHA `d3ca4b003dbc9442793217f0b88cc1ec9093b2ba029364c94ef30aeb8bca051d`；独立对账：同目录`final_shards_independent_proof.json`。四片原始日志和各自收据全部保留。

**这是生成器与静态测试链路的验收，不是5187条SQL实机通过、317包全部覆盖或运行时Oracle已校准。** 数据库执行仍为0；16条写入待审、56个无普通manifest包、跨阶段依赖及场景Oracle缺口继续保留。08:00后不新增功能，剩余窗口仅整理验收证据和真实缺口交接，09:00结束调度。

## 本窗口净变化与保全

最后直接比较窗口初期5061条基线与当前报告，而不只依赖各批次串联的总结：旧5061条case完整字段、旧772份manifest记录及SQL文件字节全部保留；新增45份manifest、126条case。新增分布：COMMENT 40、M SET 29、M SELECT 25、INSERT 11、MERGE 7、UPDATE 6、M PREPARE 5、CREATE SCHEMA 2、TRUNCATE 1。来源和覆盖审计有真实演进，未宣称它们不变。

这是有限消费者增量，不是126种新增完整功能，更不是实机通过数。共享生成列、MERGE、RETURNING、函数身份、候选setup身份和执行失败边界的修正，除新增候选外还改变了已有场景的检查能力。直接保全证据为`work/project_evolution_20260910_0900/window_delta_proof.json`。

## A1：四类生成列输入共用有限合同

详细边界见[生成列合同](GENERATED_COLUMN_CONTRACT_20260909.md)。依据实际M原文、CREATE TABLE、字面量或完整seed历史，支持两裸INT列相加的显式STORED生成列，覆盖DEFAULT、省略列、有限查询输入、仅重算生成列的UPDATE。24项新增回归，最终相关冻结回归108项通过；全5061条SQL、完整case字段、Pairwise及Oracle字段不变。

独立审计只有4条从待审变为有限已检查，保留16条视图/派生DEFAULT和1条复杂冲突表达式。不支持的表达式、未知历史、VIRTUAL或隐式存储仍待审。

## A2：M PREPARE普通对象DROP子批

新增3组 profile、manifest、真实fixture和planned阶段场景，分别预备：

```sql
PREPARE m_prepare_stmt FROM 'DROP TABLE m_prepare_drop_table_ns.base_table PURGE';
PREPARE m_prepare_stmt FROM 'DROP VIEW m_prepare_drop_view_ns.target_view';
PREPARE m_prepare_stmt FROM 'DROP INDEX m_prepare_drop_index_ns.target_index';
```

这三条分别属于独立用例，不能在同一会话直接连续执行而忽略释放同名prepared对象。setup仅创建本case专属新模式、表及所需视图/索引；目标只PREPARE，不执行字符串中的DROP。

原文明确PREPARE解析、分析和重写，EXECUTE才执行。场景因此拆为PREPARE→检查对象仍存在→EXECUTE→检查目标消失。表和视图的预备后行值有具体结果集断言；对象消失和索引存在性的目录接口尚需校准，保持人工断言与planned，不用任意SQL错误冒充Oracle。

跨章依据来自M PREPARE、DROP TABLE、DROP VIEW、DROP INDEX、DROP SCHEMA和已有CREATE提供者。补齐4个DROP提供者的真实权限事实与导出，依赖图把它们排在PREPARE之前。语法事实供profile、权限事实供环境门、PURGE生命周期事实供场景；严格引用类型校验保持不变。

安全及语义边界：

- 必须是M物理数据库中的独占新模式、隔离连接、明确对象创建者；模式不能与用户同名。这里M的DROP SCHEMA删除模式，不是授权删除物理数据库。
- 只清理确认由本case创建的资产；没有CASCADE、DROP OWNED、吞异常或清理他人对象的兜底。表清理使用PURGE，prepared须确认创建成功后释放。
- 所有执行场景保留数据库授权、目录Oracle校准、逐步归属清理要求。
- BTREE是生成语法关键字，不能据此断言物理索引方法；M原文说明USTORE下实际建立UBTREE。
- DROP家族只有TABLE/VIEW/INDEX代表，不包括SCHEMA/DATABASE目标、在线、依赖级联或全域组合。feature为`representative`，不是整族全部覆盖。

## M UPDATE：补回本模式直接规定的视图多表限制

M UPDATE正文L16明确禁止视图多表更新。此前核心只给一般模式应用该限制，导致M模式的实际视图目标可能误判为有限已检查。现按各自正文来源生效，不向未知模式或派生目标借用规则；单表视图更新和普通表多表更新保留原有判断。

同步新增一条事实及原文账本映射、真实两表与视图fixture、planned场景。场景先用普通表多表更新作控制并检查行值，再尝试视图目标。目标错误类别为`multi_table_view`，SQLSTATE尚待校准，不能把任意失败当通过。没有把单表ORDER/LIMIT尾部套进多表语法，也没有为提高覆盖率改变现有用例预期。

新增8项测试，初始真实反例失败后修复；最终10模块95项相关冻结回归通过，实际30.521秒。全库重新生成后，775个manifest、5064条case完整字段、生成报告字段及SQL字节全部不变，全部要求pair仍覆盖，ID无重复。只更新m_update的来源覆盖；当前候选不包含这种多表视图组合，因此写入审计数量不变。此项修复提高拒绝错误候选的能力，不是增加实机已验证数量。

## A3：COMMENT普通关系对象子批

新增普通索引、两列视图及视图列三个目标，与原有普通文本、中文、单引号转义及NULL四值组合，增加12条候选。实际fixture建立ASTORE表、btree索引和直接投影视图；视图及索引不伪报成表。权限与创建语法分别引用CREATE VIEW/CREATE INDEX的确认事实，增加真实依赖边和正文来源。仅三个特性成为代表性覆盖，其余对象与权限域保持缺口。

新增9步planned注释设置、替换和清除场景，按索引/视图/视图列身份分别检查；目录Oracle尚待校准。新fixture无CASCADE或DROP OWNED，只有确认本case创建成功并记录归属后才允许按顺序清理；不承诺共享库安全或零回收站残留。

预览与正式全量生成对账：原5064条case完整字段、报告及SQL字节不变，新增12条，所有要求pair覆盖且ID唯一。相关122项回归最初120通过、2失败：旧故障注入只移除一个清单的权限消费者，漏掉此前新增的PREPARE DROP INDEX消费者。修正为移除全部实际消费者，并增加“保留另一个真实消费者仍有效”控制。复跑该模块5项通过；其余9模块118项原已通过，独立指纹确认两轮仅该测试文件变化。两份原始收据保留，不能写成单次123项全通过。

## A2续批：M SET两个独立用户变量

按M SET L23–25的逗号列表语法增加第三AST分支，复用已有赋值符号和字符串/NULL取值，不增加新维度而改变旧case ID。首变量固定独立字符串、第二变量为字符串或NULL，两种赋值符号共4条新候选。两个变量实际初始化，结束清NULL并关闭独占新M连接，不用ROLLBACK假装恢复变量。

planned场景读回两个变量，分别期待两字符串及字符串/NULL。没有互相引用，因此不推断列表求值顺序；不把逗号列表当连续赋值，也不承诺数值转换、二进制、子查询或任意长度列表。扩展域继续`needs_profile`。5项新回归，相关8模块44项通过，实际86.574秒；旧5076条完整字段、报告与SQL字节全部保留，新增4条，依赖图不变。

## VALUES谓词限制：已知负例不再被泛化为表达式未知

一般INSERT L294明确禁止在IN/NOT IN中使用传入行的VALUES(column)。已有负例此前被通用复杂表达式检查提前归为待审。现在只对实际普通表的已知裸列、一般章节来源、ON DUPLICATE赋值中的有限左操作数形状识别该限制；字符串伪代码、限定函数、M/未知来源、右侧或更复杂嵌套不借用规则。不计算CASE结果，不猜错误SQLSTATE。

新增6项测试，相关9模块84项回归通过（40.291秒）。全5080条case、报告及SQL字节不变，所有要求pair仍覆盖且ID唯一。独立逐ID审计仅已有目标负例由待审转为文档静态矛盾，其余5079条不变。运行时Oracle仍未校准，没有删除用例或改变expected来获得通过。

## A3续批：COMMENT模式与显式命名主键

为既有模式、约束两处缺口增加8条候选（两个对象×四类注释文本），复用原有语法槽位和文本域。前置实际创建独占模式及其中带命名整数主键的普通表；不把模式或约束假报成表。COMMENT现在有32条有限候选，其他对象类型、其他约束形态和目录行为仍不宣称完整。

新增COMMENT→CREATE SCHEMA/CREATE TABLE/DROP TABLE/DROP SCHEMA四条真实事实依赖，并记录原文哈希。CREATE TABLE以前只有正文补充来源，本次才实际消费建表权限与主键事实；四个提供者只增加消费者记录，没有改变它们的候选或覆盖结论。

清理文本限定为本case创建成功的表PURGE后模式RESTRICT；不使用CASCADE或DROP OWNED。明确初始模式不存在、不与现存用户同名、创建后及清理前都不是current_schema，尤其防止已有search_path自动选中刚创建的模式。只有实际记录的本case资产才允许清理，setup失败不盲目执行整套teardown。这些是未执行的前置合同，不是零残留证明或执行授权。

新增6步planned设置、替换、清除场景，模式和约束分别定位；约束不能误读为同名索引。目录接口待校准，保留人工断言。5项新增测试先全部RED，再相关34项GREEN；最终9模块72项冻结回归通过（117.549秒）。预览与正式快照逐字段及字节对账：旧5080条全部不变，只新增8条，全部要求pair覆盖，ID唯一；旧5080条独立审计也全部不变。

## A3续批：CREATE SCHEMA内嵌资产

按CREATE SCHEMA L56–66列出的七类子命令，复用现有AST的repeat列表，增加命名新模式中的TABLE→INDEX及独立SEQUENCE两种有限代表。表明确ASTORE、索引明确btree；序列只选择原文示例的START 101 / INCREMENT 10，未将OWNED BY当作列DEFAULT。两份清单各生成一条完整SQL，不能把这种固定有限代表称为复杂Pairwise压缩。

前置只做原文建议的`SHOW search_path`预检，不提前创建目标资产。真实对象由目标CREATE SCHEMA语句创建；provides不伪报为执行前已有表。清理只针对确认由本case创建的表或序列，再以RESTRICT删除非当前模式，不能盲清部分失败产物。没有为通过fixture校验加入SELECT 1，也没有假设ROLLBACK能恢复DDL或序列状态。

新planned场景对索引检查归属及空表结果；序列分两次调用nextval，分别预期101和111。目录接口、实际执行和清理仍需授权与校准。PARTITION/TRIGGER/GRANT、任意混合顺序、其他属性和OWNER/BLOCKCHAIN组合继续保留缺口。

本批也暴露了一个真实架构边界：DROP SCHEMA已有CREATE SCHEMA依赖，若把清理事实再反向导入，将形成包级循环。目前只为创建阶段导入CREATE INDEX/SEQUENCE/TABLE事实，清理正文及哈希仍完整保存，场景显式要求`phase_dependency_review`。**这不是完整跨阶段依赖闭环。** 没有关闭循环检查，也没有把这项缺口包装成已解决；后续需区分事实来源、创建前置和清理阶段，不能混成一种调度边。

16因子依赖试点仍为16个任务，实际需要的正文由20章增至21章，额外DROP SEQUENCE正文不冒充新因子任务。6项新增测试先RED，随后四相关模块27项通过；最终十模块69项冻结回归通过（132.823秒）。预览、正式快照、独立审计逐ID对账：只新增2条，旧5088条完整字段、SQL字节及审计均保留，ID唯一且要求pair完整。清理阶段依赖和运行时Oracle仍未完成，不能由静态测试推导。

## A2续批：M SET两个变量连续赋值

依据M SET L102–105补齐独立的连续赋值分支：首位运算符可选`:=`或`=`，第二位固定`:=`，不能把逗号列表的赋值符号重复套入链中。复用原有五个维度，只追加第四个form；两个赋值符号×字符串/NULL形成4条新候选，原时区、单变量和独立列表的ID、SQL及前后置完全保留。

新fixture初始化两个专属变量为不同值，结束逐个清NULL并关闭独占新M连接，不用ROLLBACK假装恢复。planned场景读回两个变量，分别期待两个相同字符串或两个NULL。只覆盖长度2的链，长链、中间等号拒绝的目标Oracle、数值转换和子查询依旧缺合同。

新增5项测试先RED；首次相关14项仅一处新测试误用了不含章节号的来源定位格式，按实际来源格式修正并增加账本102–105行断言。最终十模块53项冻结回归通过，进程收据99.170秒；包括M建库/重连环境文本和旧执行器禁止直接执行M用例的模拟测试，没有实际连接数据库。全量预览和正式对账确认只新增4条，旧5090条完整字段、SQL字节、独立审计不变，要求pair完整且ID唯一，依赖图不变。

## A4续批：一般MERGE复用有限列合同

依据一般MERGE正文L63–84，把实际普通表DDL、源与目标列身份、赋值列数、相同物理类型域、DEFAULT/省略列及NULL约束接入新的有限MERGE审计模块。只接受带明确不同别名的普通表、简单列等值ON和有限赋值，不解释行匹配数量、触发器或权限。DEFAULT复用INSERT/UPDATE的共享实现，没有另外把未知默认值猜成NULL。

原有38条MERGE以前全部被独立审计排除为not_applicable，现在分为7条有限checked、27条明确needs_review、4条既有负例静态矛盾。四类负例是无action、重复同类WHEN、更新ON列、多组VALUES；错误类别与现有manifest保持一致，SQLSTATE仍待实机校准。视图/子查询源、分区、复杂ON与分支WHERE保留review。**待审总数从16增至43是审计范围扩大，不是修改SQL产生27条新失败。** 正向静态矛盾仍为0。

增加18项测试，覆盖真实38条生成用例、来源哈希/账本、模式隔离、默认值与列域、引号/CASE/不完整尾逗号，以及审计CLI和实际生成器的故障注入/有效控制。越界赋值延续共享合同的assignment_range_unknown，不凭整数范围猜运行时错误。第一次16模块199项回归后，补入实际生成器故障注入，最终16模块200项冻结回归通过，进程收据67.348秒；全量重新生成后5094条完整case字段、所有SQL字节、要求pair、ID及生成报告完全不变。原5056条非MERGE审计不变。

本批有两个真实入口：生成器原有的success候选通用`inspect_write`硬门，以及生成后的独立写入审计。无需新增MERGE专用structural_check；四种保持valid属性但故意破坏render的正向profile，都会在生成阶段报错，恢复后正常生成。独立CLI也会对正向静态矛盾返回失败。新模块纳入审计源码指纹，不能用静态checked推导执行成功或全章覆盖。最初仅凭structural_checks为空判断“没有生成期接入”不准确，已通过实际调用路径和故障注入纠正；旧proof不覆盖，最新proof显式标注替代该错误解释。

## A4续批：MERGE真实DEFAULT消费者与精确预期

新增一个显式双表fixture和一个独立manifest，生成3条候选：标量DEFAULT配合显式插入默认值、元组DEFAULT配合省略列插入、整行DEFAULT VALUES。目标name列实际声明常量`'fallback-name'`，category无默认，两个规则不能混成统一NULL。复用既有五个维度与普通表列合同，没有增加新模型、改旧绑定或手改SQL快照。

三份planned场景各自从原始seed开始，并列出精确有序行结果；不能串用前一场景留下的id=2。整行DEFAULT VALUES不会复制源id，新行id预期为NULL。场景仍需数据库授权与Oracle校准，精确预期不是实测结果。

fixture只创建本case两张新表，不预先DROP抢占同名对象；限定独占非系统模式、固定current_schema/search_path及实际ownership记录，结束只对本case成功创建表使用RESTRICT PURGE。CREATE TABLE默认值正文与DROP TABLE权限/清理正文均保存hash，新增MERGE→DROP TABLE真实事实依赖；原创建依赖保持。没有声称跨阶段调度已全部解决。

新增4项测试先全部RED，三相关模块27项GREEN，最终十二模块94项冻结回归通过（进程104.502秒）。预览、正式快照及独立审计证明只新增3条，原5094条全部case字段、SQL字节、Oracle与Pairwise保持不变；新增3条有限checked，原审计全部保留。长表达式、子查询、WHERE/分区和视图默认语义仍不宣称完整。

## A4续批：INSERT/UPDATE的RETURNING输出合同

发现并复现真实漏检机制：写入列合法时，`RETURNING missing`也被判为有限checked，因为原检查在RETURNING处分割后只验证输入或赋值。现在普通一般模式INSERT/UPDATE会继续检查输出列身份、输出名和类型族；明确FROM来源使用单独命名空间，不把源列误当目标列。生成器原有硬门能拒绝两类真实manifest中故意损坏的正向RETURNING片段，恢复控制仍能生成。

只支持直接列、AS输出名、无FROM的星号及明确限定的星号；重复输出名不套用视图列唯一性规则。未知函数、NULL等未定类型表达式、隐式系统列、歧义FROM星号仍待审；一般模式的规则不套给M、REPLACE或多目标UPDATE。输出只声明类型族，不是完整SQL类型、实际返回值或受影响行数。CTE内部RETURNING和外层RETURNING分开，不误读字符串中的关键字。

新增13项回归。首次实现将NULL当成普通标识符，已按根因复用现有表达式身份排除集合；原投影检查的排除集合内容不变。最终二十模块225项冻结回归通过（进程95.522秒，unittest93.683秒）。全5097条重新生成后所有case字段、SQL字节和生成报告均不变；独立审计只有63条追加输出证据（44 INSERT、19 UPDATE，其中60条外层输出、3条只有CTE内输出），原5034条审计不变，所有状态与Oracle字段不变。证明质量提升不必靠增加SQL数量或把待审改绿。

## A1一般模式：生成列合同接入真实消费者

一般CREATE TABLE L746–762、INSERT L16–17和UPDATE L14–15提供了独立来源。共享检查器现在支持一般模式中两个普通INT相加的显式STORED列，覆盖字面量DEFAULT、省略生成列、来自真实seed的SELECT和seeded UPDATE。一般模式仍要求GENERATED ALWAYS及INSERT INTO，不借用M的可选关键字；M省略存储类型还受m_format_dev_version影响，未被本批泛化。

新增3份真实fixture、5份manifest、8个独立planned场景，生成4条正向和4条目标负向。负向明确区分直接写99、直接写NULL与允许的DEFAULT；未填造SQLSTATE。精确行结果来自有限输入推算，尚未实机执行，UPDATE重算未改变行值也不能独自证明受影响行数。

同时修复一个真实生成缺口：raw VALUES中的NULL原被输入合同过滤。现在只在完整消费真实VALUES行、核对每行列数及NULL token后接受NULL身份，不把字符串、CAST、SELECT或附加语法当作同一证据；M现有AST路径不变。跨章矩阵只消费约束事实，行为事实仅进入场景，未放宽事实类型校验。

最终28模块280项冻结回归通过（184.615秒）。第一次280项收据中1项旧M测试仍使用默认一般scope断言review，保留其失败记录；修正后要求显式M模式和有限生成证据，不修改产品代码凑通过。原5097条全部case字段、report、SQL字节和独立审计保持不变；新增8条全部保留，ID唯一、要求的pair完整。新增一般INSERT/UPDATE依赖CREATE TABLE和DROP TABLE的实际正文、事实与拓扑核验。

## A1续批：生成输入与RETURNING输出真正组合

没有停在上一子批的独立检查：先完整消费并证明生成列输入，再用既有RETURNING合同单独验证输出列。新增6项纯检查和3项真实生成集成回归，证明缺失输出列会被生成器拒绝、合法对照可恢复；输入溢出、未知函数或历史、M模式RETURNING仍不获得通过。

新增2份manifest、6条候选，复用上一子批全部fixture和依赖。6份planned场景绑定目标语句这一次执行的原始返回集，不重复执行写语句，也不以随后查询全表替代RETURNING。UPDATE返回集预期只有命中id=2的一行；若未来执行器不能捕获目标结果，须记为blocked，当前不宣称实际返回值或命中行数已验证。

最终29模块289项冻结回归通过（198.475秒）。旧5105条完整case/report/SQL/独立审计不变；新增6条同时持有输入与输出有限证据，全部既有fixture文件哈希不变。这个续批解决的是共享合同组合缺口，不是扩大通用表达式解释器。

## A1续批：一般模式省略STORED的身份与来源原子性

一般CREATE TABLE L751明确省略STORED与显式写法等价；M CREATE TABLE L451–452的省略含义却受版本参数影响。共享生成列合同现在仅在一般模式接纳省略STORED，M模式仍要求明确的存储证据。仍只支持两裸INT输入相加的有限三列结构，不放开VIRTUAL、IDENTITY或任意表达式。

补齐原遗漏的存储缺省事实，单独关联L751并导出给INSERT/UPDATE。原L749–754来源单元拆开版式、存储缺省与表达式限制；后者含多条独立约束，诚实保留`unreviewed`，没有为了来源100%维持错误的atomic标签。新增两个真实fixture、两个manifest和三个planned读回场景。

30模块298项冻结回归通过（收据总耗时207.907秒）。旧5111条完整case/report/SQL字节及独立审计全部不变，只新增3条有限checked候选；依赖图不变。来源账本仍有待精审项，结果集、命中行数及清理没有实机验证。

## A2续批：M SET单变量整数值与逐步读回

按M SET L109的整数表达式依据，增加7/-7两种小整数字面量，复用既有单变量AST及独占新M连接fixture。一个独立manifest选择两种赋值符号×两种值，共4条候选；旧时区、字符串/NULL、独立列表及连续赋值均不变。这四种组合本身已是小型全组合，不宣传成大量压缩。

新planned场景从fixture的字符串初值开始，先赋7、读回，再赋-7、读回。每步Oracle必须在下一次赋值之前执行；只检查数值，不用JSON数值表示冒充服务端int8类型或驱动类型证明。连接退出清NULL并关闭，不能假设ROLLBACK恢复用户变量。其余数值转换、二进制、子查询和长链仍保留缺口。

5项新测试先RED，随后19项直接测试通过。第一轮68项冻结回归只有旧测试的feature数量断言过期（4→5）；保留原failed收据，仅增加新整数feature及代表域断言，第二轮68项通过（142.895秒）。独立对账确认两轮输入唯一变化是该测试文件，没有修改SQL、规则或expected来凑通过。

本批只改变m_set的覆盖记录，旧5114条完整字段、报告、SQL字节与独立审计均保全，所有fixture文件哈希不变。新增SET候选在写入合同审计中为`not_applicable`，不是新增4条DML语义checked。

## A3：MERGE的ON整数条件与真实源行对照

共享合同接纳等值关联后的单个source整数列大于有界整数字面量，复用实际DDL列身份和整数范围。仅列/类型形状通过，不推导谓词真值、NULL消除或匹配行数；目标侧条件、动作WHERE、视图/子查询/分区仍分开待审。对未声明的filter列保守待审，避免将隐式系统列误报为不存在的用户列。

原6个带附加ON且没有动作WHERE的候选中，1个实际使用VIEW；因此只改善5个普通表消费者，没有为了达标放行第6个。新增两个真实对照，负id同时出现在源和目标：等值关联更新旧负键，附加正数ON使其不匹配并插入新的负键，不能把source行直接丢弃。fixture明确无唯一约束，两个读回Oracle仍planned。

13项新增测试先复现缺口与身份误判，35项直接测试后，12模块134项冻结回归通过（127.711秒）。旧5118条case/report/SQL完整保全；独立审计只有5条待审转有限checked，另新增2条候选。依赖图不变，只有merge_into覆盖记录改变。基础逻辑、比较与MERGE正文哈希保存在本批proof中，不把辅助查证冒充新的全局基础Fact注册表。

## A3续批：MERGE动作WHERE与ON共享类型检查、保留不同阶段

将有限source整数谓词检查抽为共享函数，供ON和每个动作的WHERE复用。只有完整的`source_column > bounded_integer`可进入该子域，任意布尔表达式、未知或系统列、目标侧谓词、隐式转换仍待审。过滤条件不能绕过原有目标列、join key禁改、列数、重复动作及NULL赋值检查，也不能推导nullable输入已被消除。

两个新候选只有WHERE不同：同一个ON、同样的name赋值、同样的分支顺序。通过依赖fixture追加未匹配负键-2，与原已匹配负键-1共同检查两个动作：WHERE可阻止-1的UPDATE但不会使其回退INSERT，也可阻止-2的INSERT。两个结果集Oracle均planned；这与上一批ON对照是独立试验，不能把不同seed的结果直接混算。

最初wrapper只有setup、没有teardown，被现有严格模型正确拒绝（实际32项中5个加载错误、未跑完全部测试，失败预览也保留）。没有降低模型或改auto忽略SQL，而是为本wrapper追加行提供精确三条件DELETE，再由依赖逆序DROP两表；必须先记录其INSERT实际成功，不能清理他人行。没有重复声明两表所有权、占位SELECT或CASCADE兜底。

10项新增测试先RED，修正后45项直接回归通过；14模块144项冻结回归通过（143.333秒）。旧5120条case/report/SQL完整保全，仅两个既有普通WHERE候选从待审变为有限checked；VIEW和子查询来源未放行。新增2条对照，旧fixture文件全部不变，只增加一个有真实种子逆操作的依赖wrapper。

## A3续批：MERGE直接VIEW只读来源

原文USING允许表、视图、子查询。共享列层已有直接投影视图的实际CREATE VIEW哈希、普通基表列域和顺序DDL证据，但MERGE将写目标和读来源一起拒绝。现分开身份：目标仍要求普通表；只读来源可使用有完整直接投影证据的命名VIEW，并记录独立的检查标签。

保留计算/过滤/嵌套视图、DDL失效、未知模式及视图写目标限制；基表DEFAULT不推导为视图DEFAULT继承。源列宽度/可空性、目标join key禁改及动作规则仍逐项检查。旧fixture的初始DROP/CASCADE风险仍单独待审，没有因列域通过而获得执行或清理授权。

9项反例测试先4项失败；修复后补真实7消费者集成测试，最新15模块154项冻结回归通过（155.657秒，输入端点一致）。全5122条case、报告、SQL字节、全部规格和依赖图不变；只有7条旧VIEW来源审计从待审转有限checked，其余5115条审计不变。没有新增SQL来放大进度，也没有改expected或Oracle。

## A3续批：MERGE直接子查询只读来源

从派生写目标中提取“普通基表＋裸列直接投影”的共享证据，给查询来源独立身份，不把来源误认为可写派生表。MERGE先完整切出源查询，再解析外层别名和ON；支持直接列、星号及有限列重命名，内层过滤、计算、嵌套、CTE、VIEW基表和分区目标继续待审。只证明列身份和类型，不证明行匹配或执行成功。

全5122条完整case/report/SQL、规格与依赖图保全，7个既有普通子查询源从待审转有限checked，其余5115条审计不变。195模块1530项完整四片回归发现4处旧测试断言，保留原始失败收据：一处错误要求M/未知来源RETURNING通过，三处仍使用新增生成列用例前的INSERT计数。独立对账确认原INSERT110条完全保留，新增5个manifest/11条；只修正两个测试文件，没有放宽产品代码或SQL预期。随后两个受影响模块57项全部通过（627.792秒），产品输入与原四片完全一致。

这是“全范围回归＋测试文件修正后受影响模块复核”的跨轮证据，**不是一轮1530项全通过**，也不能把重叠的57项相加。原中断的单进程discover另行保留，不计通过。最终窗口还需最新统一冻结验收。

## A2续批：M PREPARE创建命名空间

新增一个有限候选`PREPARE m_prepare_stmt FROM 'CREATE SCHEMA m_prepare_created_namespace';`，复用现有body槽位，不扩建生成器。跨章实际消费M CREATE SCHEMA语法、命名空间/归属/权限事实和DROP SCHEMA清理权限。M DATABASE/SCHEMA在这里表示模式，不是物理数据库；物理M建库与重连仍由独立前置计划负责。

setup只有真实`SHOW search_path`预检，不能先创建目标模式；PREPARE-only的teardown仅在确认创建归属后释放prepared，不删除尚未创建的模式。目标必须是不存在、非系统名、非用户名、不在search_path中的模式。独立8步planned场景区分PREPARE前后不存在、EXECUTE后存在、确认归属/空模式/非当前模式后才清理。目录接口仍需校准，五处人工断言不能当成已执行Oracle；不使用CASCADE、DROP OWNED或任意错误放行。

新增5项回归；首份RED含一个测试自身路径属性错误，修正后真实4项失败，再实现并通过。相关42项通过后，全量预览与正式对账证明原5122条完整case/report/SQL、旧fixture和审计均保留，仅新增1条；所有要求pair和ID检查通过。最终15模块87项冻结回归通过（165.077秒），输入端点一致。M PREPARE额外15个语句族现在10个有代表、5个仍缺profile；CREATE家族只覆盖SCHEMA单一拼写，不含DATABASE同义拼写、IF NOT EXISTS、字符集或字符序。

## A3续批：COMMENT普通SQL函数与原子来源

在专属用户模式实际创建一个INTEGER输入/返回的普通SQL函数，显式输入签名与原四种注释值组合，新增4条候选。使用PG风格环境门，创建权限、默认PUBLIC执行可见性、COMMENT权限和签名RESTRICT清理分别引用正确章节事实。不是将M builtin SUM前置身份套给自定义函数，也没有新增通用函数解释器。只允许独占测试数据库和隔离连接，禁止初始DROP、CASCADE、DROP OWNED或setup失败后盲目清理。

planned场景依次设置、替换、清NULL，三个函数读回明确预期7；注释元数据仍需独立目录接口按模式、函数名、INTEGER输入签名校准，函数返回7不能替代注释断言。相关95项冻结回归通过（101.732秒），旧5123条完整字段/report/SQL、旧fixture和审计保全，仅增加4条。一个早期命令误写测试模块名、随后三处旧测试断言失败均保留原始日志，没有改写为一次通过。

本批同时发现COMMENT原文L33–39的七个对象分支被一个总fact归为atomic。先如实标为grouped并暴露缺口，随后继续做实际修正：拆为七个单行source unit、七个精确语法事实，各对象feature实际消费对应事实。旧总fact保留为七个单元的兼容汇总来源，不改变已有候选引用。

新增反向回归：把七单元重新合为一个总fact时，原审计器必须再次报告原子性失败；没有修改审计器或添加豁免。第二子批43项冻结回归通过（57.211秒），全5127条case/report/SQL、所有fixture、所有独立审计和依赖图不变，只改变COMMENT的来源覆盖记录。五个尚无fixture的对象仍needs_profile，函数与索引仍仅representative。**7条来源语法事实不是7种新增可执行能力，也不是全书原子性复审。** 两批测试范围重叠，不相加作独立测试数。

## A2续批：M PREPARE删除独占空模式

新增单个`DROP SCHEMA`预备代表，真实fixture仅新建本case独占空模式；目标只PREPARE，planned场景分别检查预备前存在、预备后仍在、EXECUTE后才消失。目录接口尚未校准；不是物理数据库删除，也不覆盖DATABASE同义拼写或非空模式。清理先核实际阶段、归属、空模式且非当前模式，IF EXISTS不能替代归属判断。

新增5项RED→GREEN，相关35项通过；14模块68项冻结回归通过（180.487秒）。全量重新生成保留旧5127条完整case/report/SQL与旧fixture，只新增1条；独立审计旧5127行不变。M PREPARE body从16到17，文档族仍10个有代表、5个待profile，不把内部代表算整族覆盖。

## A3续批：MERGE纯UPDATE共享严格RANGE分区合同

把完整RANGE定义与显式分区定位拆为共享合同，INSERT保留自己的AS别名限制，MERGE只接纳不修改分区键的纯UPDATE。完整验证真实列声明、整数上下界和FOR值后才使用分区身份，不把无效setup的错误冒充目标分区错误。原DDL哈希保留；四条含INSERT的候选仍缺来源行路由证明，没有据seed猜测匹配结果。

新增12项反例/消费者测试，修复期间保留了旧统计断言失败与词法前置遗漏的原始日志；最后六模块93项通过，35模块313项冻结回归通过（289.274秒）。全部5128条case/report/SQL和规格未改；仅两个纯UPDATE从待审变为有限已检查，另四条仍待审但原因精确为INSERT分区路由。未执行数据库、未验证目标Oracle或清理安全。

## A4：前置或目标失败不能扩大执行与清理范围

纯Mock复现并修复两处真实边界问题：沙箱CREATE/SET失败曾回退public继续运行目标；失败PREPARE曾仍执行DEALLOCATE，可能释放同名既有会话对象。现在前者在case循环之前返回fixture_error并保留部分模式名供复核，后者保留目标错误、阻止无归属清理，匹配负向Oracle也不能把未完成生命周期算通过。

新增14项Mock反例与控制，47项直接回归通过，九模块64项冻结回归通过（28.149秒）。相对上批指纹只改变执行器和新测试；全部规格、生成器、5128条case/SQL及独立审计不变。M及文件资产硬门禁仍在，既有成功沙箱的CASCADE路径未获得新安全证明，没有真实数据库连接，也不宣称残留为零。

## A3续批：闭合字面量seed与MERGE分区INSERT充分条件

复用一般INSERT、MERGE和RANGE分区正文，把“源表里恰好有1、2”提升为明确的有限证据：从实际最新CREATE起，完整消费全宽字面量INSERT，按真实列名重排、逐字段检查类型/NULL/范围/长度；直投影子查询沿origin回到普通源表。若所有源key都在目标选定分区，那么实际插入的任意子集也在其中；不计算JOIN匹配行、WHERE真值或影响行数。

源CREATE之前也不能留下未知程序：最初黑名单漏掉`SELECT install_seed_trigger()`，现只接纳完整有限表DDL、裸表DROP和已知新表上的字面量seed。动态默认、函数、事件触发器、未知对象或不完整历史均待审；DROP清理归属与并发安全仍是独立前提。Python数字匹配还会接纳未审Unicode数字，新增反例后本helper限定原始ASCII SQL域；这不是断言非ASCII SQL必然非法。

新增16项测试，保留原始RED和中间收据。36模块328项冻结通过后，最终仅ASCII边界和对应测试变化，再对六个直接受影响模块冻结验证108项通过（41.373秒）；这是两轮带输入指纹的证据，不是最新所有模块的一轮全通过。四条既有MERGE分区INSERT候选由待审转为有限已检查，其余5124条审计、全部5128条case/report/SQL和全部规格保持不变。

若一个源key不在选定分区，仍只能待审，不能反推目标必然报错，因为它可能被匹配或过滤。VIEW、动态DEFAULT、M模式和复杂分区继续保留边界。成功隔离setup、无并发是前提而非本地执行事实；没有数据库运行或Oracle校准。

## A2续批：M SET单列常量子查询与真实SELECT依赖

依据M SET L114–116分别建立子查询syntax和结果一致性behavior_oracle；M SELECT实际导出L28可选FROM与L43投影表达式事实，由M SET语法/value消费，新增一条真实包级依赖。最初把跨包syntax放进scenario被严格类型校验拒绝，修正消费者位置，未放宽校验器；场景只用本章结果事实作判断依据。

复用既有字符串、NULL、7/-7与两种赋值符，新嵌套AST分支生成8条`SET @m_set_subquery_value := (SELECT 7)`形式的有限候选。专属变量实际初始化、清NULL并关闭独占M连接，不伪造表或依赖ROLLBACK恢复。planned八步骤逐步比较直接SELECT和变量读回；NULL是一行单列NULL，不是零行，驱动返回类型仍未校准。任意FROM/关联/多行查询、复杂转换等仍缺合同。

7项新测试先RED，相关26项通过；十模块56项冻结有55项通过、1项旧特性数断言失败（5→6），只修正该测试并补新特性的精确身份，复跑该模块8项通过。两轮输入仅此测试变化，原失败收据保留，不写成单次56项全通过。原5128条完整case/report/SQL、全部旧fixture及逐case审计保全，只新增8条；所有要求pair与ID唯一性通过，真实依赖拓扑无环。

## A3续批：COMMENT真实枚举与复合类型

同一独占新模式中实际创建两个短ASCII标签的ENUM和两个INTEGER属性的COMPOSITE，分别与既有四类注释文本组合，新增8条候选。类型不伪报成表；创建权限、属性类型USAGE、创建属主及RESTRICT清理通过CREATE TYPE/DROP TYPE已存在的真实事实建立依赖，不扩展I/O基本类型、shell或集合类型。

COMMENT L54–58的TYPE/VIEW/TRIGGER/IS拆为四条独立syntax事实和单行来源，L57闭括号单独记结构标点；旧总fact保留兼容引用。六步元数据场景保持planned，按模式、类型名、类别定位注释并检查标签/属性未变，目录接口仍待校准，不能用同名表或类型文本输出替代。

7项新测试先RED，四模块26项通过，八模块57项冻结回归通过（105.583秒）。原5136条完整case/report/SQL、旧fixture与审计全部保留；只新增8条和COMMENT到CREATE TYPE/DROP TYPE两条直接依赖，核心与生成脚本未改。此处只复核L54–58；同章其他分组来源尚不能据此宣称已原子化。

## COMMENT剩余分组：纠正原文原子性计数

再次逐行核对原文后，L25–32包含COMMENT ON前缀及六个对象分支，L40–46和L47–53各包含七个对象分支；此前分别只记作2、1、1项。现在三组均按真实七项记账，保留原事实引用，让审计器明确显示三组“独立事实数超过映射数”的缺口。因此COMMENT的来源提取完整结论改为false，而不是为维持100%放宽审计器。已精审的函数、类型等子集继续独立验证，罕见对象后续按真实消费需求精审。

新增两项内容绑定回归，保留原故障注入并要求匹配注入单元身份，避免已知缺口让负面测试误通过。七模块57项冻结回归通过（85.780秒），旧5144条case完整字段、所有SQL、Fixture、Oracle、依赖图及逐ID写入审计完全不变。只有COMMENT来源账本及相应覆盖报告改变；这不是SQL质量退化，也不是新增数据库验证。

## M SET当前模式：实际DDL与目标事务分离

新增CURRENT_SCHEMA TO、CURRENT_SCHEMA =及SCHEMA字符串三种写法，复用默认/SESSION/LOCAL三scope，共九条候选。专属空模式创建后显式提交，再开始目标事务；目标后先回滚并核验事前模式恢复、对象归属及空模式，才允许删除专属模式并提交。不是靠DDL回滚清理，也不把共享连接上的COMMIT当安全操作。

真实依赖连接M CREATE/DROP SCHEMA及START TRANSACTION/COMMIT/ROLLBACK；环境要求M物理数据库、独占新连接、事务创建者和实际模式所有者。新增LOCAL三拼写及回滚的planned场景，元数据接口与执行阶段仍待校准，不能猜初始模式为public或把缺失模式当应报错。DEFAULT、SESSION提交持久性和交错设置仍留缺口。

7项新测试先RED；相关九模块51项冻结回归通过（115.472秒）。旧5144条case完整字段、SQL、Fixture与审计不变，新九条仅增加语法候选，核心未改。证据：`m_set_schema_final_proof.json`、`m_set_schema_regression/receipt.json`、`m_set_schema_write_audit.json`及`m_set_schema_inventory.json`。

## M MIN/MAX：基础函数规则接入真实SELECT消费者

按M聚合函数正文MAX L574–591、MIN L635–652接入有限输出类型合同：裸整数表字段保持INTEGER，FLOAT表字段返回DOUBLE；非字段表达式在原文另有规则，不能套用。复用实际查询与CREATE列声明的匹配，不信任profile单方面声称的类型；每个函数保留单独的M模式及内建函数身份门，原SUM入口仍只接受SUM。

两个已有整数列分别生成MIN/MAX，共四条候选，继续使用原有真实三行seed，不新增占位表。结果场景保持planned；其他类型、排序规则、窗口、全NULL及空表未因这四条候选变成已覆盖。本子批结束时FLOAT尚只有纯类型测试；下一子批补了真实来源消费者。

新增测试还发现并修正一个旧共享漏洞：删除全部空白会把`SUM(ALL qty)`与`SUM(allqty)`误认为同一个投影。现在按词法单元比较，保留ALL/DISTINCT与列名之间的边界；六个真实反例先失败后通过，正常排版空格仍等价。没有逐条修改最终SQL。

最新十一模块82项冻结回归通过（117.599秒）；旧5153条case完整字段、SQL及Fixture全部保留，只增四条，依赖图不变。证据：`m_extrema_final_proof.json`、`m_extrema_regression/receipt.json`、`m_extrema_write_audit.json`及`m_extrema_inventory.json`。

## M FLOAT/DOUBLE：读来源声明与写入合同分离

真实反例发现：纯类型合同知道FLOAT输入的聚合输出为DOUBLE，但生成器无法识别实际FLOAT表。没有放宽所有普通列解析调用，而是增加默认关闭的读声明选项，只在M内建SUM/MIN/MAX入口启用。仅接受裸ASCII FLOAT/DOUBLE声明；带精度、DEFAULT、NOT NULL、REAL、其他后缀或不明对象历史仍待审。通用INSERT/DEFAULT、MERGE、索引和普通查询原有范围不变。

依据M 2.6.7.4 L1160–1229建立FLOAT与DOUBLE两个真实fixture，分别与SUM/MIN/MAX形成六个单例候选。专属模式内表字段与provides完全匹配，seed为1.5和2.5；planned场景分别期待4.0、1.5、2.5，并单独要求校准数据库输出类型/驱动元数据。Python浮点值不是数据库DOUBLE类型证据。增加CREATE/DROP SCHEMA真实依赖、M数据库与隔离连接/归属门；不使用CASCADE、DROP OWNED或DDL回滚清理承诺。

7项新增测试先真实失败；第一轮25项仅两处builder/source列表顺序不同，修复临时patch的歧义上下文而未弱化断言，第二轮25项通过。最终19模块166项冻结回归通过（186.242秒）；旧5157条完整case/report/SQL、所有旧fixture和逐ID写入审计不变，只增加六条候选。六个单例不代表所有类型组合Pairwise覆盖。证据：`m_approximate_final_proof.json`、`m_approximate_regression/receipt.json`、`m_approximate_write_audit.json`、`m_approximate_inventory.json`。

## 聚合字段身份：特殊表达式与Unicode近似拼写

实际反例显示，SUM/MIN/MAX纯类型入口会把CURRENT_DATE等无括号函数按profile假报成INT字段，而直接列投影入口已经排除它们。M日期时间正文L144–199、L642–681提供了直接反证。本批两个聚合入口复用既有特殊表达式排除集合，统一返回待审，不尝试解释时间值、函数解析或类型转换。

另外，Python Unicode忽略大小写和upper曾让`ſUM(qty)`、源类型`ınt`、输出`DECıMAL`借用ASCII内建SUM/INT/DECIMAL身份；同Unicode profile与实际SQL甚至通过真实CREATE绑定。现在SUM与MIN/MAX一样限定已审ASCII词法，先核原始类型再规范大小写。Unicode只被排除在有限证明之外，不被宣判为数据库非法SQL。普通小写、ALL/DISTINCT、近似但不同的普通列名仍保留。

6项测试的117个反例断言先失败。首次40项回归仅新测试一处误期望晚于实际词法门的错误；改为分别断言ASCII profile的既有投影不匹配与同Unicode profile的新函数身份待审，没有放宽产品判定。最终12模块101项冻结回归通过（109.448秒），相对上一输入仅合同文件和新测试变化；全部5163条完整case/report/SQL、所有规格及fixture、依赖/覆盖和逐ID写入审计完全不变。证据：`aggregate_identity_final_proof.json`、`aggregate_identity_regression/receipt.json`、`aggregate_identity_write_audit.json`、`aggregate_identity_inventory.json`。未执行数据库。

## M AVG：复用共享来源与函数身份合同

按M 2.5.11 L72–87接入AVG裸字段输出：INT/DECIMAL映射DECIMAL，FLOAT/DOUBLE映射DOUBLE；只在独立M内建AVG身份门下生效，复用实际最终SQL和CREATE声明绑定。没有复制SUM解释器，旧SUM兼容入口仍拒绝AVG，MIN/MAX仍未接纳DECIMAL域；通用写入/DEFAULT范围不变。

复用既有两整数列、FLOAT表和DOUBLE表，新增四条候选、三个manifest及三个planned场景，无新fixture且旧fixture逐字不变。明确区分数值结果与DECIMAL/DOUBLE驱动元数据；全NULL、空表、重复值DISTINCT、窗口、精度及其他整数域仍缺独立测试。7项新增测试先4失败2错误，39项相关GREEN后，最终13模块98项冻结回归通过（145.230秒）。旧5163条完整case/report/SQL/审计全部保全，仅M SELECT覆盖记录变化、依赖不变。证据：`m_avg_final_proof.json`、`m_avg_regression/receipt.json`、`m_avg_write_audit.json`、`m_avg_inventory.json`。

## 一般COMMENT AGGREGATE：真实聚集资产与签名

新增单INTEGER输入聚集的四类注释候选；前置实际创建专属模式、两个INTEGER参数且返回INTEGER的SQL转换函数，再建立INTEGER状态和文本初值0的聚集。N个聚集输入对应N+1个转换参数来自CREATE AGGREGATE正文，不把聚集假报成表或普通函数。COMMENT定位模式、聚集名与输入类型签名；两个真实依赖连接CREATE/DROP AGGREGATE，类型声明、转换函数、初值和清理所有者分别消费已确认事实。

不借用旧有固定名字及CASCADE的聚集fixture。新清理只依次DROP本case实际创建的聚集签名、转换函数签名和空模式RESTRICT；PG风格、独占测试数据库、PUBLIC默认执行风险、非当前模式及实际归属均明确。聚集创建权限未在该章获得独立充分依据，保留执行前单独核验，不借转换函数权限推导。三个元数据Oracle保持planned，不能用运行求和结果或同名函数冒充注释验证；零参数、重载、NULL和溢出不在本代表内。

5项新测试先全失败；随后发现旧测试仍把聚集视为未覆盖、以及batch05重复硬编码总数224。保留原日志，按真实有限代表修正断言，并从明确的逐包EXPECTED表统一计算总数/唯一ID/唯一SQL，保留全部20包独立数量和新增聚集4条专项断言。十一模块冻结78项仅一处库存旧断言失败；仅该测试文件变化后，完整重跑其22项全部通过（14.813秒），其余56项输入不变。独立proof验证这个跨轮关系，不声称新单轮全量78项通过。

旧5167条完整case/report/SQL、全部旧fixture与核心/脚本、逐ID写入审计不变，只增四条候选。COMMENT三组原文原子性缺口逐项保持，未提升完整静态或行为覆盖。证据：`comment_aggregate_final_proof.json`、`comment_aggregate_regression/receipt.json`、`comment_aggregate_regression_02/receipt.json`、`comment_aggregate_write_audit.json`、`comment_aggregate_inventory.json`。

## A3续批：COMMENT RULE所属表身份

依据COMMENT L45、CREATE RULE的表拥有者/事件/目标语法和DROP RULE的名称加所属表语法，建立独占普通表上的INSERT DO INSTEAD NOTHING规则。四类文本生成四条COMMENT候选；没有执行INSERT，不采用ON SELECT转视图分支，也不把规则混同触发器。

三个真实创建步骤对应规则→表→空模式的逆序清理。规则删除权限正文不足，单独保留执行核验条件，不由创建权限推导。新增两条真实提供者依赖及原文哈希，三步元数据Oracle仍planned且按所属表、规则名和类别定位。

5项初始RED后，相关34项GREEN；最终13模块104项冻结回归通过（179.634秒）。原5171条完整case/report/SQL和逐ID审计保全，所有旧fixture及core/scripts不变；仅四新候选。三组原文原子性缺口保持，不提升实机或全章覆盖。证据：`comment_rule_final_proof.json`、`comment_rule_regression/receipt.json`、`comment_rule_write_audit.json`、`comment_rule_inventory.json`。

## A2续批：M COUNT字段输出及NULL/重复种子

按M2.5.11 L338–388接入单INTEGER字段COUNT/ALL/DISTINCT的BIGINT输出合同。与SUM的DECIMAL返回分开，实际函数身份和M物理数据库仍是执行前置条件。没有把COUNT(*)、多参DISTINCT、窗口、常量或任意类型混入有限已检查域。

新独占模式下两列真实INTEGER表含六行seed，其中qty有NULL与重复。id的COUNT/ALL/DISTINCT分别计划返回6/6/2，qty为3/3/2；每一步另有BIGINT元数据Oracle，场景均planned，不以Python整数值或静态通过代替实机结果。新源增加一个AST分支，原所有分支与默认值不变；无需修改生成器入口。

6项真实RED后，5模块37项GREEN；最终15模块108项冻结回归通过（158.345秒）。独立proof起初漏考虑新增AST源分支，保留失败记录后明确验证：禁用COUNT构建器重建旧syntax，其SHA与上一收据完全一致；新syntax仅增加一个实际表字面量分支。未修改产品或重跑为掩盖差异。原5175条完整case/report/SQL与逐ID审计及旧fixture全保留，仅六新增。证据：`m_count_final_proof.json`、`m_count_regression/receipt.json`、`m_count_write_audit.json`、`m_count_inventory.json`。

## 一般TRUNCATE：双键选择器的有限形状合同

依据TRUNCATE的FOR取值语法及CREATE TABLE PARTITION的多列VALUES LESS THAN、键类型与边界限制，新增一个独占模式、两INTEGER键分区表、一条目标候选及planned行为场景。核心仅核实际DDL键名/顺序/类型、FOR值身份与元组宽度，不把这类检查冒充键值路由、边界排序或运行期分区清空证明；现有INSERT/MERGE单键路由代码未放宽。旧待审双键域和更复杂分区条件保留。

测试进一步暴露setup前缀识别会接收用户函数INSERT及内嵌CREATE SCHEMA。保留四个真实失败子例后，改为完整限定的空SCHEMA、目标CREATE TABLE及整数/NULL字面量seed。9项新测试覆盖实际DDL故障注入、其他形状拒绝、原路由边界及planned Oracle。最终相关13模块127项通过（134.881秒），旧5181条完整case、报告、SQL及逐ID审计全部保全。

本消费者新增五条真实提供者依赖；精确profile事实审查不借用父matrix或其他profile。DROP SCHEMA由原正文资产成为依赖试点第17个实际节点，总正文仍21份（4份正文only），47条Fact引用、2条Fixture引用与10个Fixture闭包已按实际来源hash静态核对。没有新跑17任务PDF重抽、队列及完整失效传播，不把本次引用审查当成那条全链路已经验收。初次回归两处依赖清单遗漏及后续正文消费者遗漏均保留原失败记录。

证据：`partition_shape_final_proof.json`、`partition_shape_regression_02/receipt.json`、`partition_shape_write_audit.json`、`partition_shape_inventory.json`及`cross17_source_review.json`。

## M COUNT(*)：计行与非NULL字段计数分开

M2.5.11 L346明确星号计全部行。本次复用原六行NULL/重复seed、M物理数据库和内建函数身份门，只增加独立COUNT(*)→BIGINT分支及一条候选，不放行ALL *、DISTINCT *、限定星号、多参或窗口。实际SQL投影、源表DDL和profile仍须相符。新planned场景期望6行，与已有COUNT(qty)的3明确区分；类型元数据仍需实机校准。

四项新测试最初两失败一错误；最小适配后4模块23项通过，最终16模块114项冻结回归通过（172.509秒）。原5182条完整case、报告、SQL、逐ID审计及所有旧fixture/syntax文件均保全，依赖图不变，仅M SELECT来源覆盖变化。新语法候选不等于行为已验证。证据：`m_count_star_final_proof.json`、`m_count_star_regression/receipt.json`、`m_count_star_write_audit.json`和`m_count_star_inventory.json`。

## M COUNT全NULL边界：修正“目标SQL就是测试身份”的假设

全NULL字段不等于空表。新增独立两行(id=2,qty=NULL)的显式fixture，复用原四个COUNT投影，planned结果分别为0/0/0/2，另有逐步BIGINT元数据Oracle。没有引入通用DELETE状态解释器，也不把六行fixture和两行fixture同时组合；各自在独占新模式中独立生命周期。原有所有fixture和语法文件保持不变。

这组真实对照暴露两个共同问题：发布器与因子审计都只按目标SQL文本判断重复，因此将不同seed的有效候选拦截。现在共用具体setup身份：同factor/SQL/setup仍拒绝；改名字、expected或teardown不能绕过；缺前次输入证据也不能放行。文本重叠继续报告，不假装SQL变多。具体边界见[架构说明](ARCHITECTURE.md)：这不是任意SQL的语义等价或运行前置状态证明。

新增四条case而distinct SQL不增加；报告明确四组同SQL的不同setup及各自SHA。全5183条旧case/report/SQL/逐ID审计保全，依赖不变。原18模块125项回归仅M pilot一处旧纯SQL唯一断言失败；修正后该完整模块7项通过（14.02秒）。独立指纹证明两轮只有该测试文件变化，118项未受影响与7项复测分别记账，不冒充单次125项全通过。此前全库traceability方法也已实际复现旧断言失败并针对复测通过。所有原始失败、首次受阻预览与中间审计保留。

证据：`m_count_null_final_proof.json`、`m_count_null_regression/receipt.json`、`m_count_null_regression_02/receipt.json`、`m_count_null_write_audit.json`和`m_count_null_inventory.json`。

## 17章跨章依赖全链路复核

06:44–07:15完成新一轮完整复跑，实际1862.015秒。将TRUNCATE新增的DROP SCHEMA依赖纳入17个任务；21份主/补充正文从本地PDF重新抽取，全部哈希匹配。47条Fact引用、2条Fixture依赖及10个Fixture闭包有具体来源；6项非法引用探针和创建/清理顺序检查通过。

逐任务运行envelope、lint、生成与覆盖审计，17个任务、159个manifest共1524条候选的完整字段、报告及目标SQL与正式快照一致，ID唯一、要求pair齐全。所有原项目输入的前后哈希一致，未修改原规格或正文。随后在临时副本中完成25项失效探针：5次包变更、5次主正文变更、15次补充正文变更；实际失效范围均与独立声明的依赖下游相同，恢复后重新新鲜。

这里通过的是“来源/依赖/调度/失效处理的验证链路”，不是17个包语义覆盖完成。真实队列全部保留needs_review，覆盖审计因真实缺口返回1；领取顺序与失效探针明确标记simulation，不能把模拟static_complete冒充真实包升级。没有数据库执行。此前仅引用检查的17节点证据现在有了这一轮完整复跑支撑，旧16节点运行仍保留历史。

证据：`cross17_closure/receipt.json`（SHA `8614e325d77eb717c959a76596d1270283690262ced01a891b03e5332d012c15`）、`cross17_closure/result/dependency_report.json`（SHA `6418ec8cd6be48e085d4c82bdf070a93c534e37c0244e7274a5a922550914d7d`）。07:30安排的215模块全项目回归此时尚未开始。

## 当前验收快照（17章依赖复核及全项目冻结回归均结束）

| 指标 | 当前值 | 边界 |
|---|---:|---|
| 登记包 | 317（一般224 / M93） | 不是全书事实精审完成 |
| 活跃manifest | 817 | 一般565 / M252 |
| 活跃case | 5187 | 一般4020 / M1167；最新子批新增4条不同seed候选，不改旧SQL |
| 历史待审SQL / case | 1 / 1 | 不加入活跃分子；物理SQL文件818份 |
| 写入有限已检查 / 待审 | 305 / 16 | 其余4840不适用、26为负例静态矛盾；正向矛盾0 |
| 目标SQL去重文本 | 5100 | 5187条case不等于5187种SQL；4组同文本不同setup单列 |
| 来源抽取审计结论 / 生成模型结论 | 166/261 / 251/261 | 分母仅本报告的261个活跃包；56个无普通manifest包未混入 |
| 静态覆盖结论 | 3/261 | 不能由能生成或单元测试通过推出全域覆盖 |
| 跨章依赖链路 | 17任务 / 21正文 / 1524候选复核通过 | 25项副本失效探针；真实包仍待审，不是实机验证 |
| 最新全范围冻结回归 | 215模块 / 1682项通过 | 四顺序分片，同一冻结输入，无跳过；约51分12秒 |
| 历史局部失败与复测 | 原1530项中的4处旧断言、COUNT批次中的旧SQL去重断言均留证 | 原收据不覆盖；当前新全范围结果已覆盖修正后的实际输入 |
| 数据库执行 | 0 | 没有校准运行时Oracle |

M PREPARE的15个文档语句族中，10个已有代表、5个仍缺profile；CREATE/DROP族的内部遗漏继续保留在代表范围说明中。用户、权限、其他模式管理分支不因补了普通对象而自动通过。M SET的其他值域也未被本批代替。

16条写入待审均为视图/派生DEFAULT。一般ALTER VIEW对SET/DROP DEFAULT标注“暂无实际意义”，不能据此推导视图DEFAULT继承。MERGE四个实际有限seed消费者已补充分路由证据，不代表任意MERGE分区INSERT已全面支持；来源不闭合或越界仍待审，不猜目标错误。

正式生成报告SHA256：`e8c1eaf94d14f683176740d9f34f9d664475854790784c07e28a1ce06664ee49`。当前215模块全量验证与该报告指纹一致；此前各次全范围或相关回归保留各自快照，不能用历史结果代替当前证据，也不能把单元测试当作数据库执行。

证据位于本地 `work/project_evolution_20260910_0900/`：

- `generated_seeded_verification.json`、`generated_seeded_regression/receipt.json`：A1逐ID、完整字段/SQL、来源指纹与108项实际收据。
- `prepared_drop_preview_proof.json`：正式更新前证明只增3条，旧5061条不改，coverage只影响5个实际包。
- `prepared_drop_final_proof.json`：正式快照与预览一致、原case审计不变、来源指纹与真实97项收据。
- `prepared_drop_inventory.json`：活跃与历史库存独立对账。
- `prepared_drop_*_green.log`：保留中途类型加载失败与随后修复结果，没有重写成通过。
- `m_update_view_final_proof.json`、`m_update_view_regression/receipt.json`：M来源限制的独立全字段/字节/ID/pair/审计对账和95项实际收据；原始RED保存在`m_update_view_red.log`。
- `comment_relations_final_proof.json`：COMMENT预览与正式快照一致、旧case审计不变、来源指纹；关联`comment_relations_regression/receipt.json`的初次失败与`comment_consumers_regression/receipt.json`的5项复测，独立证明仅测试文件变动、118项未受影响。
- `m_set_list_final_proof.json`、`m_set_list_regression/receipt.json`：四条列表候选、旧5076条不变、真实44项回归与来源指纹；保留`m_set_list_red.log`的初始5项失败。
- `values_predicate_final_proof.json`、`values_predicate_regression/receipt.json`：84项真实回归、仅1条负例审计变化、所有SQL及case字段不变；剩余16条均为视图/派生DEFAULT待校准。
- `comment_namespace_final_proof.json`、`comment_namespace_regression/receipt.json`：新增8条模式/约束候选、旧5080条完整保全、72项真实冻结回归和四条真实依赖；目录Oracle仍planned。`comment_namespace_inventory.json`保留历史与活跃的独立口径。
- `schema_inline_final_proof.json`、`schema_inline_regression/receipt.json`：两类内嵌资产、69项真实冻结回归、旧5088条完整保全；证据显式标记phase_dependency_complete=false。
- `m_set_chain_final_proof.json`、`m_set_chain_regression/receipt.json`：四条链式赋值代表、53项真实冻结回归、旧5090条完整保全；source约束映射到M SET L102–105，长链及目标错误仍留缺口。
- `merge_guard_final_proof.json`、`merge_guard_regression/receipt.json`：18项新增/200项相关冻结回归、5094条完整保全，仅38条原N/A的MERGE审计变动；`merge_final_write_audit.json`保留全部逐ID结果，新模块纳入指纹。旧`merge_final_proof.json`的无生成期入口解释已被新proof明确纠正；两份原始回归收据均保留。
- `merge_defaults_final_proof.json`、`merge_defaults_regression/receipt.json`：3条真实DEFAULT候选、3份精确但未执行的场景、94项冻结回归和旧5094条完整保全；跨章依赖和来源hash纳入核验。
- `returning_final_proof.json`、`returning_contract_regression/receipt.json`：225项相关冻结回归、5097条完整保全及63条输出证据变化；来源哈希、生成器故障注入和未执行边界均保留。
- `general_generated_final_proof.json`、`general_generated_regression_02/receipt.json`：280项冻结回归、原5097条完整保全及8条真实新增；`general_generated_regression/receipt.json`保留第一次旧断言失败。新审计和库存分别为`general_generated_write_audit.json`、`general_generated_inventory.json`。
- `generated_returning_final_proof.json`、`generated_returning_regression/receipt.json`：289项冻结回归、旧5105条完整保全、6条输入/输出组合候选；既有fixture哈希完全一致。新场景要求捕获目标原始返回集，状态仍planned。
- `storage_default_final_proof.json`、`storage_default_regression/receipt.json`：298项冻结回归、旧5111条完整保全、3条一般隐式STORED候选；来源原子性缺口仍如实报告，M隐式存储未放行。
- `set_integer_final_proof.json`、`set_integer_regression_02/receipt.json`：68项冻结回归、旧5114条完整保全、4条M整数SET候选；首份失败收据保留，只修正过期测试断言。
- `merge_on_final_proof.json`、`merge_on_regression/receipt.json`：134项冻结回归、旧5118条完整保全、5条旧普通MERGE转有限checked、新增2条对照；身份未证明的VIEW候选仍待审。
- `merge_where_final_proof.json`、`merge_where_regression/receipt.json`：144项冻结回归、旧5120条完整保全、2条旧WHERE候选转有限checked、新增2条对照；旧fixture完全不变，依赖wrapper只有精确种子逆操作。
- `merge_view_final_proof.json`、`merge_view_regression/receipt.json`：154项冻结回归，全5122条和所有规格保全；7条直接VIEW读来源审计转有限checked，其余5115条审计不变。最新独立审计为`merge_view_write_audit_02.json`。
- `merge_query_corrected_proof.json`：全5122条保全、7条子查询源审计变化；关联原四片1530项与修正后57项收据，独立确认仅两个测试文件变化。最新独立审计为`merge_query_write_audit.json`，不覆盖原失败收据。
- `prepare_namespace_final_proof.json`、`prepare_namespace_regression/receipt.json`：87项相关冻结回归、原5122条完整保全与1条新M命名空间预备候选；独立审计/库存为`prepare_namespace_write_audit.json`、`prepare_namespace_inventory.json`。DROP SCHEMA覆盖变化仅为新增真实scenario权限消费者，不是其生成能力或执行状态升级。
- `comment_function_final_proof.json`、`comment_function_regression/receipt.json`：95项回归、旧5123条保全和4个函数注释候选；保留发现原文原子性缺口时的中间证据。
- `comment_atoms_final_proof.json`、`comment_atoms_regression/receipt.json`：43项回归、全5127条保全、仅COMMENT七行来源粒度修正；没有修改核心审计器、fixture或SQL。最新独立审计及库存分别为`comment_atoms_write_audit.json`和`comment_atoms_inventory.json`。

## 后续推进

最终交接见[NEXT_NODE_AFTER_20260910.md](NEXT_NODE_AFTER_20260910.md)：10个生成模型结论未完整包的具体阻断、16条DEFAULT共性待审、56个无普通清单包、跨阶段依赖及单独授权的实机路线。逐包机器证据在本窗口`handoff_gaps.json`，不改变任何现有状态或覆盖口径。

最新来源计数证据：`comment_groups_final_proof.json`、`comment_groups_regression/receipt.json`、`comment_groups_write_audit.json`及`comment_groups_inventory.json`。同一份正式报告799清单/5144候选，三组真实来源缺口没有被掩盖。

最新TYPE证据：`comment_type_final_proof.json`、`comment_type_regression/receipt.json`、`comment_type_write_audit.json`及`comment_type_inventory.json`。

最新M SET证据：`m_set_subquery_final_proof.json`、`m_set_subquery_regression/receipt.json`、`m_set_subquery_regression_02/receipt.json`、`m_set_subquery_write_audit.json`和`m_set_subquery_inventory.json`。全库没有数据库执行。

最新seed证据：`merge_partition_seed_final_proof.json`、`merge_partition_seed_regression_02/receipt.json`、`merge_partition_seed_regression_03/receipt.json`、`merge_partition_seed_write_audit_03.json`、`merge_partition_seed_inventory_03.json`；上轮328项和最终108项按输入差异分别记账，旧反例未覆盖时的324项收据不冒充最终证据。

执行器边界证据：`executor_failure_final_proof.json`、`executor_failure_regression/receipt.json`、`executor_failure_write_audit.json`、`executor_failure_inventory.json`。所有数据库步骤均为Mock，connect显式禁止调用；模拟SQLSTATE不构成真实错误码校准。

MERGE分区证据：`merge_partition_update_final_proof.json`、`merge_partition_update_regression/receipt.json`、`merge_partition_update_write_audit.json`、`merge_partition_update_inventory.json`；全规格与SQL保全，仅6条旧审计变化，其中2条状态改善。

最新M预备子批证据：`prepare_drop_namespace_final_proof.json`、`prepare_drop_namespace_regression/receipt.json`、`prepare_drop_namespace_write_audit.json`、`prepare_drop_namespace_inventory.json`。前述COMMENT证据属于历史已验收批次，不覆盖后续输入。

后续按一般包资产路线选择有真实前置对象的缺口，不重复增加已经存在的有限子域。视图DEFAULT来源仍不明确的16条不猜测；用户/数据库管理等高风险条件保留门禁。本窗口已完成最终冻结回归，08:00后停止新增功能，09:00停止新作业并关闭本窗口轮询。最新作业、收据和续工指令以本窗口 `state.md` 为准。
