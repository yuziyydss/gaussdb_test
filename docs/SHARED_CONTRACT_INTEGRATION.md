# 共享合同接入：第 1 轮（2026-09-08）

本轮只接入一个合同：**省略目标列与显式 DEFAULT 使用同一目标身份边界**。
不修改 Factor Package V1 公共字段，不新增全局函数注册表，不逐条修 SQL。
本地 PDF 为 V2.0-10.0.0 集中式参考 01（2026-04-30），不是历史 507 文档。

## 接入前评审：模式、阶段、函数身份

| 来源 | 适用对象/阶段 | 不能推导的结论 |
| --- | --- | --- |
| 2.5 父章及 PDF 超链接 | M 模式；链接实际指向一般 1.6 章 | 不能把一般章内部接口限制扩大成 M 专章函数全部禁止 |
| 3 父章 | 存储过程特性；非 M 前提 | 不能据此禁用 M 内建函数 |
| 1.6 父章 | A + enable_volatile_match_index；查询索引匹配 | 不是允许 CREATE INDEX 使用 volatile 函数，更不是保证命中索引 |
| 7.3，来源 L32–48 | 视图重写、函数参数默认值、过程编译、计划缓存各自的绑定阶段 | “记录函数 OID”明确指函数参数默认值，不能直接作为表列 DEFAULT 绑定规则 |
| 2.5.18，来源 L176–203 | M 函数 DEFAULT(col_name) | 不等于 INSERT/UPDATE 的赋值关键字 DEFAULT；也不证明 schema 限定的同名用户函数 |
| 一般 INSERT L273–280、298–299；UPDATE L170–172 | 目标列赋值/省略列 | 不能只凭类型或基列血缘推导所有视图默认值继承行为 |
| ALTER VIEW L80–81 | SET/DROP DEFAULT 语法，“暂无实际意义” | 不能把该 DDL 的存在或成功作为视图默认值生效的 Oracle |

以上是来源评审边界，不是已经实现模式模拟器。模式开关、重载、运行时对象 OID、安装/升级状态未知时，不从名字猜测语义；当前有限检查器继续拒绝证明动态默认值。

来源入口：`work/pdf_tiered_2026_09_07/integration_backlog_r2.json` 中的
`prefix::m_parent_link_general_functions_not_m_whole_ban`、
`prefix::plsql_parent_non_m_scope`、
`prefix::volatile_optimizer_match_not_index_creation`、
`batch_34::guc_definition_compile_plan_binding`、
`batch_23::default_column_not_default_keyword`。
原文位于同目录父章补录、批次来源和 `work/doc2spec/full_general_corpus/general/`；保留原交付指纹，不回写旧审计凭据。

## 已复现的缺口

```sql
CREATE TABLE t (id INT DEFAULT 7, note TEXT DEFAULT 'ok');
CREATE VIEW v AS SELECT id,note FROM t;
INSERT INTO v(id,note) VALUES(DEFAULT,'x'); -- 原检查器：needs_review
INSERT INTO v(note) VALUES('x');            -- 原检查器：checked
```

这不是已观察到的数据库失败，而是**当前静态检查器可重复的证据越界**。
`check_omitted_columns` 直接对基表调用 `default_literal`，绕过后者已经存在的视图/派生目标限制。

修正：先检查被省略的视图/派生目标输出列。需要 DEFAULT 时，使用原目标对象调用同一解析入口；不得先切换成基表。

- INSERT 的显式列列表、隐式前缀列表、VALUES、SELECT 输入、别名和派生目标共用此规则。
- UPDATE 的显式 DEFAULT 继续走原共享入口；未更新列不自动填默认值。
- 普通表的 absent / 显式 NULL / 常量 / 动态 / 未解析状态保留；不合并缺失与未知。
- 完整提供视图输出列仍可通过有限形状检查。未暴露基列的既有约束检查不变；这不构成完整可写视图、隐藏列行为或继承语义证明。
- generated / identity、动态默认执行、配置变化后的绑定仍待后续合同，不因为本轮修正标绿。

## 验证与交付范围

- `tests/test_default_target_contract.py`：修复前首轮 5 个测试方法复现 7 个失败分支；随后补充审计消费者与默认状态变体，共 7 个测试方法。
- 扩展相关静态回归：151 个测试通过；没有执行数据库 SQL。
- 另运行现有 `test_generated_sql_snapshots_match_current_generator`：通过。该测试在内存中重生成注册的 manifest 并比较现有 SQL 快照，不是全库重新精审或实机执行。
- 使用原生成入口分别重生成 INSERT（15 manifests / 107 cases）、UPDATE（15 manifests / 81 cases）。前后输出隔离保存于 `work/default_target_contract_2026_09_08/{before,after}/`。
- 当前这 188 个生成用例的静态分类数量前后相同：INSERT 96 checked / 10 needs_review / 1 rejected；UPDATE 78 / 2 / 1。正向 rejected 均为 0。负向 rejected 不是目标 Oracle 已验证。
- 当前用例尚未触发新增的省略视图列反例，所以不宣称 SQL 通过率或覆盖率提升。新回归证明该缺口以后不能静默通过；不修改 manifest 覆盖域来追求数字变化。
- 生成器继续保留 needs_review 用例，不把它们偷偷过滤出 pairwise 分母；详细前后比较见同目录 `verification.json`。

本轮“来源已评审、一个有限合同已接入、静态回归已运行”；不是 P0 全局身份注册表完成，也不是整个 DEFAULT 合同完成，更不是实机验证完成。

## 接下来按同样方法推进

1. DEFAULT 剩余项按真实消费者依赖处理，特别是 generated/identity 和环境快照；不能用 7.3 的函数参数规则代替表列来源证据。
2. 选择一个查询输出类型合同（例如 SUM 的整数输入/输出类型），先复现当前消费者的错误或明确未知，再做最小适配。
3. 随后是索引创建能力与运行选择的分离、Fixture 前置失败与目标 Oracle 的分离。

每轮只选择一个可复用合同，新增失败回归，修改共用入口，再重生成实际受影响包。专题仍按需精审，不展开 125 组同等深度改造。数据库执行需要独立授权。

## 第 2 轮：生成列输入身份守卫（2026-09-08）

M INSERT 原文 L15–16、M UPDATE L14–15 都明确：生成列不能直接接收值，但可写 DEFAULT。M CREATE TABLE L441–458 定义 `[GENERATED ALWAYS] AS (...) [STORED|VIRTUAL]`，且省略存储关键字时的默认方式随 `m_format_dev_version=s2` 改变；不能把生成列当作“没有 DEFAULT 的普通可空列”。这些来源位于 `work/m_compat_batch_01/corpus/m_compat/`，不采用其他版本产品的行为推断。

复现的最小例子：

```sql
CREATE TABLE t(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO t VALUES(1,2,99);
UPDATE t SET g=99;
```

旧检查只看到 INTEGER 形状，会返回 `checked`。这并不代表旧报告承诺实机成功，但缺少一个文档已知的关键写入限制。

现在从实际存活的 CREATE TABLE 列声明识别生成列，在 INSERT/UPDATE 的共同类型检查前验证输入意图：

| 输入 | 新的静态结论 | 没有作出的推断 |
| --- | --- | --- |
| 指定具体值、表达式或 NULL | `generated_column_write` 矛盾 | 不猜实际 SQLSTATE，也不把任意报错当通过 |
| 显式 DEFAULT | `generated_default_unknown` 待审 | 不展开成 NULL，不模拟生成表达式 |
| INSERT 省略生成列 | `generated_default_unknown` 待审 | 不因缺普通 DEFAULT 合同而跳过验证 |
| UPDATE 只修改普通列 | 原有限类型检查继续适用 | 不推断生成列重算结果、溢出或运行时行为 |

这是一个拒绝已知错误输入的有限守卫，**不是整个生成列求值合同完成**。视图/派生目标仍无完整生成列写入合同，保持待审；存储方式默认值、表达式合法性及输出、函数不可变性、identity/autoincrement 均未因此完成。

同时修正了 `audit_rendered_sql_contracts.py` 的 M 写入包路由：`m_insert/m_update/m_replace` 不再被白名单覆盖成 `not_applicable`。支持不了的 M 语法返回真实 `needs_review`，没有扩大解析器的支持声明。

初步验收：新增生成列测试 9 个方法先出现 22 个失败分支，再修正共享入口；合同测试全集 160/160 通过。重生成 4991 条 SQL，735 个 SQL 快照（含 528 个一般模式快照）字节不变；累计 M 审计仍为 93 登记、92 有限模型、1070 条 SQL。实际现有用例中，M INSERT 生成列具体值负向由形状 `checked` 改为静态矛盾，DEFAULT 正向仍待审；正向静态拒绝数量仍为 0。

证据在 `work/m_compat_closure_20260908/`：`generated_assignment_before.json`、`generated_guard_verification.json`、`rendered_contracts_after_generated_guard.json`、`generated_guard_test_results.json`。本轮完整 M 回归 182/182 通过（392.452 秒），不是复用之前 178/178。无数据库执行、无产品状态批量提升。

## 第 3 轮：M UPDATE 生成列的真实消费者

不再只有“补生成列表 fixture”的 planned 操作说明。通过原始抽取构建器补充实际前置：

```sql
CREATE TABLE m_b01_update_generated(
  id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO m_b01_update_generated(id,qty) VALUES (2,9);
```

三个独立目标用例分别为 `g=DEFAULT` 正向，以及 `g=99`、`g=NULL` 负向，均带 `WHERE id=2`。每例重建自己的 fixture，清理仅 DROP 这张测试表；不能在共享未知状态上自动执行。正向 planned Oracle 查询期望行 `(2,9,11)`；负向绑定目标 UPDATE 的 `generated_write` 错误类别，SQLSTATE 待校准，前置失败不能算目标通过。

为避免以语法推导行为，CREATE TABLE 中另抽取 L444–445 的 `generated_recompute` 行为事实，生产者自身增加 CREATE→INSERT→UPDATE→结果 `(2,10,12)` 的 planned 场景，再以带类型的跨包引用提供给 UPDATE。没有修改 Fact 引用类型校验或消费者要求；存储方式明确使用 STORED，不依赖 s2 的缺省差异。

专项回归（新消费者、六包 pilot、共享生成列）21/21 通过，包括故意把正向 profile 的真实渲染改成 `g=99` 后生成器拒绝的测试。全量重新生成与累计审计通过：M UPDATE 16→19 条，M 总计1070→1073，全库4991→4994。原有735份 SQL 快照及16条 M UPDATE 用例保持不变，只新增2个 manifest 快照。此轮没有重新宣称全部 M 测试重跑；上一轮182/182与本轮21/21按输入和范围分开记录。

本轮新增场景仍为 planned，不代表完成实机验证或减少了全部未执行场景。证据：`work/m_compat_closure_20260908/update_generated_verification.json` 和同目录最新 queue/state。

## 第 4 轮：M INSERT 的 NULL 与省略生成列

在原26条 M INSERT 用例之外新增三条，不删除或改写原例：

| 输入 | 实际目标和输入 | 有限合同结论 |
| --- | --- | --- |
| 显式 NULL | 三列 generated 表，`VALUES (7,9,NULL)` | 目标负向：generated_write；不是类型不匹配冒充目标错误 |
| VALUES 省略生成列 | 三列目标，`VALUES (7,9)` | 输入两列的结构可生成；生成表达式结果仍待审 |
| 查询省略生成列 | 三列目标，查询真实源表的 id/qty 两列 | 同上；没有把目标 available_column_count 伪造为2 |

新增的 NULL 标记只表示**每一条有限 VALUES 行的对应位置确实为无类型 NULL 字面量**。字符串 `'NULL'`、`CAST(NULL AS INTEGER)`、宽度不符、混合实际值及未解析查询不能借该标记通过。全局 INTEGER/NULL 类型兼容规则没有放宽，普通列的 NOT NULL 与生成列禁止赋值仍须分别校验。

DEFAULT、两类省略列的实际结果，以及 NULL 目标错误有了4个真实 planned 场景。表达式重算引用 CREATE TABLE 的行为事实，不把语法事实当行为依据。结果断言尚未实机执行；负向 SQLSTATE 尚未校准。

验证：专项17项通过，随后完整 M 回归退出0，合同全集160项通过。重新生成740个 manifest / 4997条 SQL；M INSERT 26→29、M总计1073→1076。原737份 SQL 快照（含528份一般模式）字节不变，原26条 M INSERT 的 ID/SQL/setup/expected 不变。渲染检查 positive_rejected=0，但仍有36例 needs_review，不能据此保证全部SQL可执行。

证据：`work/m_compat_closure_20260908/insert_generated_verification.json`、`rendered_contracts_after_insert_generated.json`、`queue_after_insert_generated.json`。全章来源、静态与行为完整结论仍为0；164个 planned 场景是待验证清单，不是行为覆盖数。

## 第 5 轮：直接列投影不能伪造输出类型

复现了一个元数据自洽但SQL不自洽的缺口：源表的 `id` 是 INTEGER，投影实际仍为 `id`，只把 `output_types` 写成 TEXT，结构检查却通过。集合两侧同时写成错误的 TEXT 也能绕过两侧类型比较；把实际投影改成不存在的列、却不改 referenced_columns，同样未被原结构检查发现。

共享守卫现在对有限的无限定名列投影（含 `AS` 别名）核对实际 items 与源列合同，拒绝 `projection_type_mismatch` / `projection_missing_column`。类型同义词归一不等于数值自动转换，INTEGER不能直接冒充NUMERIC。

边界仍须区分：

- 来源类型是已有 source profile 合同，不是本轮新获得的数据库目录证据。
- helper返回真正核对的位置；函数、表达式、限定/引号标识符和SQL特殊值没有因此获得类型证明。
- 集合右侧可能读取另一张表，不能借用左侧source来证明或否定它；右侧来源/fixture仍需独立校验。
- 原4个反例先全部失败，再加入别名、未知表达式、类型同义词和右侧独立来源回归。当前合同全集167项、完整M回归199项通过；投影专项与完整FactorPackageV1合计55项通过（658.909秒），不是复用旧轮次结果。
- 最终重新生成740份SQL快照，全部字节不变，4997个用例ID和已有渲染checker结果也不变。没有提升覆盖标记；修正的是之后错误抽取不能静默通过的验证入口。

产物证据：`work/m_compat_closure_20260908/projection_verification.json` 和 `queue_after_projection.json`；测试状态见同目录 `state.md`。

下一聚合合同的原文已定位到 M 专章2.5.11，`SUM` L952–965明确INT/DECIMAL输入返回DECIMAL，FLOAT/DOUBLE返回DOUBLE。这条事实尚未接入函数签名消费者，不能用一般模式或同名用户函数替代，也不能凭返回类型推断精度、空输入结果或执行行为。

## 第 6 轮：显式选择 M 内建 SUM 的条件类型合同

第5轮未接入的SUM签名现已进入一个有限正式消费者。源码依据仍为本地PDF的 **M 2.5.11 L952–965**，不是一般模式1.6.18的SUM规则。

`query_output_contract.py` 对显式选择 `function_output_contract=m_builtin_sum` 的投影进行条件校验：INT/DECIMAL输入应声明DECIMAL，FLOAT/DOUBLE输入应声明DOUBLE。只接受直接列参数、可选ALL/DISTINCT和AS别名；限定同名函数、窗口、复杂表达式和未审类型不能借用此合同。BIGINT等尚未细审的输入保持unknown，不等于数据库不支持。

新增的正式候选为：

```sql
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source(id,qty) VALUES (1,10),(2,20),(3,30);
-- 以下为两个独立用例的目标，各自带fixture生命周期：
SELECT SUM(id) AS total FROM m_b01_source;
SELECT SUM(qty) AS total FROM m_b01_source;
```

manifest必须同时保留 `compatibility_mode=M` 和 `function_resolution=m_builtin_sum`，删除或放宽后导出会失败。**前置要求不是前置条件已验证**：环境事实确认的是M章节所定义函数的文档适用范围，未确认运行时OID、搜索路径或实际函数解析。SUM(qty)=60的Oracle场景仍为planned。

来源通过SELECT表达式消费者位置关联M聚合补充正文。累计审计器现在按实际引用纳入该全书抽取目录，仍校验文档ID、正文哈希和父PDF哈希；没有跳过外部章节验证或把整个聚合章计为完成。

23项专项回归、176项合同测试、3项一般SELECT/全库快照测试及3项来源入口/篡改防护测试通过。完整M回归208项通过（479.268秒），见 `work/m_compat_closure_20260908/m_sum_test_results.json`；目录入口修正有单独测试与累计审计证据，不混称同一输入版本。

产物对账：M SELECT 23→25例，M总计1076→1078，全库4997→4999；仅增加1份SQL快照，原740份（含528份一般模式）字节不变，旧4997个ID保留。新队列仍有2554个未映射来源unit、3193个原子性待审unit、29包未校准错误Oracle、165个planned场景。拆分一个来源unit带来的数量变化不表示新增了独立测试能力。

目前源参数类型仍来自已有source profile；本轮没有宣称所有Fixture实际DDL类型都被统一反推。下一步先验证这种类型来源是否可能漂移，再将真实来源合同用于INSERT…SELECT。其渲染检查现在仍对SUM保留expression_unknown，不把条件返回类型推导当作值域、精度或运行行为证明。

证据：`work/m_compat_closure_20260908/m_sum_contract_before.json`、`m_sum_verification.json`、`queue_after_m_sum.json`。原文/代码/报告均保留哈希；未执行数据库、未提交Git。

## 第 7 轮：SUM 的源列类型绑定真实 Fixture 声明

第6轮的后续探针确认：只在内存中将qty的profile改成FLOAT、SUM输出改成DOUBLE，真实fixture仍为INT，完整生成曾接受完全相同的SQL。问题是元数据彼此一致不等于元数据与生成内容一致；探针证据保存在 `m_sum_source_drift_before.json`，没有改规格凑结果。

现在带有SUM合同的正式消费者在Fixture编译后再次核对：

- 实际渲染SELECT的投影必须匹配选择的profile。
- 实际FROM表必须匹配声明的来源，并在setup中存在未被DROP/ALTER或不透明生命周期操作失效的普通CREATE TABLE证据。
- profile列类型必须匹配该DDL的真实列类型，随后用真实源列重检条件SUM返回类型。

这不是数据库目录查询或通用SQL解释器。仅证明简单直接表来源的声明一致性；WHERE、CTE、嵌套来源、视图、会话解析变化或不能完整识别的列声明保持待审。FLOAT返回规则仍是文档条件规则，不意味着本轮普通DDL解析器已经支持所有浮点声明。函数运行期身份仍有环境gate，结果Oracle仍planned。

专项先5项测试/5失败分支RED，再14项GREEN，补边界后专项8项通过；最终合同全集184项、一般SELECT/全库快照3项及完整M回归216项（451.126秒）通过，证据见 `work/m_compat_closure_20260908/sum_source_test_results.json`。全生成仍4999条，741份快照字节不变，没有为提高数量新增用例。

下一步将同一来源证据用于实际INSERT…SELECT消费者，分别检查目标列接收能力与查询输出类型；不能把SUM返回DECIMAL等同于已证明目标精度不会溢出。每一步继续保留真实失败回归，不把复杂表达式一律当numeric。

## 第 8 轮：INSERT…SELECT 的直接列输出绑定真实来源

实际 `manifest_m_insert_table_query` 中，将输入output_types和目标profile类型同时改为TEXT，真实SQL/Fixture仍为INTEGER，原生成器会接受。这不是原SQL执行失败，而是两个相互匹配的错误声明绕过检查。只读复现见 `insert_query_source_drift_before.json`。

原pilot builder现让现有query profile显式选择 `query_output_contract=fixture_direct_columns`；生成器编译Fixture后核对实际SELECT投影与profile、真实存活源表、DDL列类型与output_types、依赖列身份。复用第7轮来源解析和既有直接列类型比较，不改一般模式类型转换规则。它目前覆盖同一query profile在普通表、视图和省略生成列三个目标下的5个现有候选；**证明的是源查询输出，不是这三种目标的全部写入语义。**

例如现有候选仍为：

```sql
INSERT INTO m_b01_source SELECT id,qty FROM m_b01_source WHERE id = 1;
```

已证明部分：SELECT投影的id/qty与真实源表声明一致、顺序和类型不能由profile虚构。WHERE作为 `unverified_predicate` 保留；目标类型转换、精度、约束、视图可写性、生成列结果及实际行数不由此合同证明。未知来源或聚合不能借直接列合同通过；原渲染write审计仍独立保留其needs_review。

5项红测试均失败后实现最小修复，初次18项关联测试通过；新增边界后23项专项/pilot通过，合同全集192项、一般INSERT/全库快照3项及完整M回归224项（473.845秒）通过，证据见 `work/m_compat_closure_20260908/insert_query_test_results.json`。本轮741快照/4999ID不变，没有增加SQL候选、执行数据库或提升全章覆盖结论。

下一步继续分开核对目标profile与实际列声明：输入可转换为某类型，不等于目标表就是这个声明类型。不能因为源侧已验证便认定target_types也真实；需要普通表、视图列血缘、生成列的各自证据。

## 第 9 轮：普通 INSERT 目标声明不能由可转换性代替

后续独立探针只把目标profile的target_types/available_types改为NUMERIC，源查询仍声明INTEGER、实际目标DDL仍是INT，原生成器仍接受同一SQL。依据M INSERT的列顺序和转换说明，**输入可以转换为NUMERIC，不等于实际目标列声明就是NUMERIC**。复现见 `insert_target_drift_before.json`。

原pilot builder给普通表与带唯一键表的两种target profile显式选择 `target_column_contract=fixture_ordinary_columns`，复用存活DDL和普通列解析，核对：实际目标表身份、声明顺序和列数、available_types与target_types是否都与真实声明一致。INTEGER/NUMERIC的公共输入兼容关系没有被改为禁止；转换安全仍是另一层证据。

同一守卫适用于现有VALUES、SET、SELECT和upsert消费者，共14条既有候选，而非逐条SQL修补。剩余10条视图和5条生成列目标不借用普通表证明；显式目标列列表、别名、未解析DDL和会话解析变化也保持未知。返回的声明证据明确不证明输入转换或实机行为。

6项测试/9失败分支先RED。首次联测19项中一项旧断言因“双重伪造先被目标守卫拒绝”失败，已改为精确的target_type_mismatch，并新增源单独NUMERIC漂移测试，确保源守卫依然独立工作，未放宽为任意异常。随后25项专项/pilot、202项合同全集、3项一般INSERT/快照及234项完整M回归通过（485.741秒）；证据见 `insert_target_test_results.json`。741快照/4999ID不变，没有新增候选或提升全章结论。

下一步已有可复用证据：实际视图Fixture经现有 `attach_shared_contracts` 能得到id/qty到真实基表的类型/列来源；生成列目标没有普通列证据。只读结果见 `target_lineage_review.json`。应复用视图来源合同并测试失效传播，不重复建表规则，也不将其等同于视图可写性、DEFAULT行为或数据库执行证明。

## 第 10 轮：直接视图目标复用现有列来源

现有 `attach_shared_contracts` 已从真实Fixture推导 `m_b01_view.id/qty` 来自 `m_b01_source.id/qty`。本轮没有重新实现视图解析器，而是在原目标声明守卫增加显式 `fixture_direct_view_columns` 分支，要求真实目标有 `_view_base` 和列来源证据、profile.is_view与合同种类一致，再核对列数和原始声明类型。

对应M INSERT L137–153中的“直接基表用户列”必要条件；该条件不能替代可更新列、聚合/窗口/集合限制、保留键、系统视图或环境权限。原builder为view profile引用已有 `m_insert_fact_view_column`，生成器实际消费该合同，不能仅靠is_view标签宣称完成。

新增检查复用于现有10条视图候选：NUMERIC声明不能冒充真实INT；普通表不能冒充视图；基表DROP/ALTER、视图DROP/rename后旧列来源失效；表达式视图不能冒充直接列。显式视图列别名可保留真实基表origin，基表即使按相同DDL重建也不恢复旧视图证据。视图的DEFAULT继承仍明确unknown，既有拒绝逻辑有回归测试，未因类型来源可知就放开。

7测试12失败分支RED后，首次25项联测通过；补边界后26项专项/pilot、212项合同全集、3项一般INSERT/快照及244项完整M回归通过（493.067秒），证据见 `work/m_compat_closure_20260908/insert_view_test_results.json`。741快照/4999ID不变，未新增SQL候选或实机结果。

普通目标14例与视图目标10例现在均有各自的实际声明来源校对；生成列目标5例仍独立待处理。下一步优先补其正向声明身份与类型证据，不把生成表达式求值、DEFAULT、NULL、STORED/VIRTUAL模式默认值混为同一证明。

## 第 11 轮：生成列目标的声明身份与行为证据分开

后续只读探针只将generated目标profile的三列声明改为NUMERIC，真实DDL仍为INT、输入profile未改，生成器曾接受相同SQL。新 `fixture_generated_columns` 合同复用实际AS身份解析，独立核对真实列顺序、类型与具体生成列集合；不能由“表中存在一个生成列”冒充约定的g列，也不能将生成列当作普通列获得DEFAULT/NULL证明。

有限提供者只支持本批实际使用的裸内置类型列与生成列声明；返回原始类型、来源和generated身份，不创建普通 `_column_contract`、nullable或default_state。未知函数表达式、STORED/VIRTUAL缺省、输入转换、生成结果和数据库行为均不由声明证据证明。复杂声明保留待审，不以字符串标签宣布合法。

现有5条生成列候选通过同一合同，包括DEFAULT、具体值负向、NULL负向和两种省略输入；同此前14条普通目标、10条视图目标共同覆盖29条现有M INSERT候选的各自声明来源。**这不是29条完整写入语义或实机验证通过。** 两个负向用例保留目标generated_write类别与未校准SQLSTATE；三个正向用例的渲染write检查仍为needs_review。

6测试12失败分支RED后，首次30项关联测试通过；增加身份与证明边界后22项专项/pilot、222项合同全集、3项一般INSERT/快照及254项完整M回归通过（535.663秒）。见 `work/m_compat_closure_20260908/generated_target_test_results.json`。

`generated_target_verification.json` 对账741快照（含528一般模式）、4999个ID及既有渲染write审计结果全部不变；M候选仍1078条。没有新增SQL数量或提升全章完成状态。下一方向转向M CREATE INDEX的实际渲染能力约束，优先验证当前规则是否只检查取值ID，而未检查生成SQL中的真实范围。

## 第 12 轮：M 索引的范围规则必须检查实际 SQL

本地M CREATE INDEX正文2.4.2.8.11明确FILLFACTOR范围为10~100。原规则只排除storage_below的取值ID；只读探针保持storage_min标签和validity不变、将render改成9，17条正向候选中4条实际越界仍被生成。这是渲染约束缺失，不是数据库能力限制，见 `index_fillfactor_drift_before.json`。

新 `index_fillfactor_contract` 在实际SQL渲染后执行，复用已有事实/规则引用结构，不另建能力注册系统：

- 对比真实WITH填充因子与所选storage的数值，再检查包含上下界的10~100。
- 要求来源为M章节、manifest保留精确M gate，检查项关联已确认的约束事实和相同事实下的目标规则。
- 正向实际越界直接报错，不静默移出Pairwise分母。负向只有实际越界且明确针对该规则才可导出；实际为70时不能靠negative标签通过。
- COMMENT里的WITH文字不是存储选项；重复/未知存储项、非整数或尚未建模的语法保留未知。负向预期不能掩盖这些未知或renderer/profile不一致。

该有限合同不证明主表存储引擎、索引方法自动转换、键列存在性/类型、唯一性、锁效果、填充因子默认值或数据库执行。M允许行内COMMENT；没有套用旧一般模式的修复结论。

5测试7失败分支RED后5项GREEN；补边界后的20项专项/生成列关联测试、232项合同全集（163.872秒）、3项通用索引/快照及264项完整M回归通过（551.462秒），实际状态见 `work/m_compat_closure_20260908/index_fillfactor_test_results.json`。全生成仍741份快照/4999条SQL，M CREATE INDEX保留17正向+1目标负向，未校准SQLSTATE不补造。

下一缺口的只读探针 `index_key_drift_before.json` 已复现：仅将实际key_profile.items换成缺失列，source_columns依赖标签仍写id，7条正向候选被接受。下一步应将实际键列表绑定存活Fixture声明，而不是只检查标签；索引表引擎和复杂键表达式仍需各自证据。

## 第 13 轮：实际索引键绑定存活的 Fixture 声明

本轮接入 `index_key_source_contract`，以M CREATE INDEX L146的目标表字段定义和现有限制事实为依据。原builder新增一条精确的key_source约束事实，不把排序语法事实当作列存在性依据；原145–149来源unit拆为145、146、147–149，仅146映射到新事实，其余缺口和原子性待审标记保留。

生成器编译实际Fixture后核对：渲染索引的主表和直接键列表、profile.items与列数、source_tables/source_columns、存活普通CREATE TABLE中的列身份。索引存储和键校验复用同一有限语法分解，避免两套前缀/尾部解析漂移。DROP/ALTER/不透明setup和会话名称解析变化会使旧证据失效；普通表被真实DROP后重新CREATE则用新声明，不照搬旧视图血缘的失效结论。

检查同样适用于填充因子负向候选：目标值越界不能掩盖不存在的键或失效的前置表。普通表直接键上限32有合同级边界回归；GLOBAL、分区、表达式键、前缀键、生成列、视图或未完整解析的DDL保持未知。原始类型/列来源可知，不表示排序profile、方法与类型兼容、存储引擎或实际执行已证明。

6测试12失败分支RED后16项联测通过；补边界后21项键/存储联测、243项合同全集（177.855秒）、3项通用索引/快照及275项完整M回归通过（572.373秒），见 `work/m_compat_closure_20260908/index_key_test_results.json`。`index_key_verification.json` 确认741快照、4999ID和既有渲染write检查不变，M仍1078候选；正式索引仍17正向+1负向，不将纯合同测试冒充新增数据库场景。

新队列未映射unit2555、原子性待审3195，较上一轮分别增加1和2，是上述来源块细分后的计数变化，不是删减事实或测试退步；全章完成仍未宣称。29包错误Oracle、165planned不变。

随后只读审计M的Fixture写入，按每步之前的setup建立证据而不是借用之后的DDL：39种去重前置写入服务632个用例步骤，37种在有限检查范围内checked、2种needs_review、0种rejected。CTAS显式NULL种子行仍为nullability_unknown，M UPDATE生成列表省略输入仍为generated_default_unknown；结果见 `fixture_write_prefix_audit.json`。两者是不同合同缺口，均不是数据库执行结果，不能一次性改成通过。

## 第 14 轮：显式 NULL 与 DEFAULT 分离，并用于真实种子写入

实际CTAS source fixture先创建 `id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9`，再插入 `(1,10),(2,NULL)`。原有限检查器把显式NULL无条件当成nullability_unknown，虽然现有普通列合同已能提供qty可空的证据。

新共享检查只在实际普通列证据充分时判断显式NULL：允许NULL则保留该输入，NOT NULL则报目标列矛盾。它不调用DEFAULT解析、不把NULL替换9，也不把NULL加入公共类型兼容规则。生成列具体NULL依然先被拒绝；视图/派生目标、域、复杂表约束、失效DDL、函数和类型转换仍需自己的证据。结果中的 `shared_explicit_nullability` 只标记这项有限判断。

原M CTAS builder补两条来源事实（2.4.2.8.19 L284–286与L296–297），关联已有extra_column_order场景，并显式选择 `fixture_write_contract`。正式生成在编译Fixture后，逐步检查有限种子写入，**每一步只使用前面的setup**；矛盾、无法判断或缺少写入证据时停止导出。目标SQL预期报错不能让坏seed通过。合同不证明完整DDL成功、写入行数、唯一性、触发器、最终目标状态或数据库结果，原场景仍planned。

该落点有两轮红→绿证据：NULL检查5测试8失败分支后30项关联测试通过；随后正式生成消费5测试4失败分支，补边界后46项共享/生成列/分区关联测试通过。最终256项合同全集（188.169秒）、3项一般INSERT/快照及288项完整M回归（593.073秒）通过，见 `explicit_null_test_results.json`。

`explicit_null_verification.json` 确认741份快照、4999个ID、目标write审计逐条不变，M仍1078条；39种Fixture前缀中恰好1种改变，只对应12个CTAS消费者步骤，其SQL/前置声明/消费者列表不变。该项由nullability_unknown变为有限checked，其余38种逐项一致；现在38checked、1needs_review（生成列省略输入）。没有把12个步骤算成新SQL、增加场景数或提供实机结论。

来源unit因两处原块拆分，未映射计数2557、原子性待审3199；这是计数粒度变化，29包未校准错误Oracle和165planned不变。下一阶段应回到按包复核真实来源与场景缺口，不继续无界扩展NULL表达式或整个类型系统。

## 第 15 轮：回到按包补遗漏，而不是无限加共享检查

复核M预备语句族四章，发现PREPARE原文列19行语句族，原有限矩阵只实现4行DML。新增15行语句族来源、数据库所有者限制与解析/执行阶段事实；对新增语句族用已有矩阵 `documented_features: needs_profile` 明确登记缺口。它们没有有限profile，也没有被自动挂入syntax冒充生成覆盖。含多个备选项的一行仍需细分，原子性状态不提升。

EXECUTE沿用已有UPDATE fixture，增加写后有序查询预期 `[[1,99],[2,20]]` 的planned场景，并与读取场景共同声明跨PREPARE的会话依赖。没有执行数据库、校准错误码或将场景提升ready；参数语法歧义和释放后的目标错误仍待处理。

第一轮严格加载发现新事实无消费者，随后接入上述显式缺口记录，未放宽校验。修后预备语句专项7项、全库快照1项及完整M回归292项（554.586秒）通过；重新生成仍741快照/4999 SQL，累计M为93登记、92有限生成、1078 SQL。独立对账确认全部旧快照和ID不变，新增15条待建profile仍可见。实际状态见 `work/m_compat_closure_20260908/prepared_source_test_results.json`。

## 第 16 轮：负例不能让错误的前置条件代替目标错误

PREPARE原同名/用户变量合并action占位已拆为两个独立具体场景。旧ID保留用于同名负例：Fixture先创建一条预备语句，目标再次同名但使用合法字符串。新的FROM变量负例先通过M SET持有的Fixture赋值 `'SELECT 1'`，目标名不存在，不混入同名条件或未初始化变量。

两例均声明目标步骤、target-only错误类别和未校准Oracle，不填猜测SQLSTATE。变量场景清理本case变量为NULL后要求关闭独占连接，不对预计不存在的预备语句无条件DEALLOCATE；同名场景只释放本Fixture创建的语句。仍为planned，**这些是具体测试定义，不是通用场景执行器已消费所有字段或数据库已通过的证明**。

跨包依赖使用现有Fixture拓扑及包级事实：SET原文L23–25的赋值语法由本包消费，L97字符/NULL存储约束供PREPARE场景引用。初始错误地跨包引用syntax被严格加载器拒绝；修正来源引用，未放宽消费者类型。真实拓扑回归核实SET先于PREPARE，PREPARE先于EXECUTE，变量前置没有混入其他SET或PREPARE步骤。

后续累计审计又发现本地SET语法仅由场景引用仍不符合事实消费口径。保留严格规则，使用已有 `needs_profile` 矩阵明确登记独立赋值生成分支未实现；读取场景仅消费字符/NULL约束。修前单项审计回归失败，修后23项来源/负例/真实依赖/会话/审计测试通过（41.563秒），累计M审计及全库快照1项通过（17.326秒）；重新导出仍741快照/4999 SQL。完整M回归300项通过（597.605秒），见 `work/m_compat_closure_20260908/prepared_negative_test_results.json`。下一步将重点转向已有needs_profile的实际有限生成，避免只增加planned记录。

## 第 17 轮：将 PREPARE 的 ANALYZE 缺口转为一个实际代表

不扩展共享模型，在已有body矩阵中添加普通ANALYZE profile，新增独立manifest，沿用PREPARE FROM字符串AST。Fixture显式创建本case的行存表并写入两行，目标为 `PREPARE m_prepare_stmt FROM 'ANALYZE m_prepare_data';`，只在同一独占M连接准备和释放。没有执行EXECUTE，也没有统计内容已正确的结论。

跨包环境条件由M ANALYZE持有并导出：2.4.2.6.17 L49–50普通分析支持PREPARE但不含VERIFY，L63–67为权限，L151为仅行存。新manifest真实消费三条事实，依赖图包含ANALYZE→PREPARE；ORIENTATION ROW的构造另已核对M CREATE TABLE L251–259。未使用全库分析、继承、分区或VERIFY分支。

原15个额外语句族中，仅ANALYZE标为有profile的representative，另14个仍needs_profile；审计器仍将这个代表列为not_domain_complete，不将有一条SQL解释为全域完成。行存来源单独映射，其他unmapped/原子性缺口不批量豁免。

新增测试先出现缺manifest和未消费条件的RED（4项，2失败1错误），随后19项关联测试通过（42.779秒）。累计M审计、全库SQL快照校验1项通过（17.945秒）。独立对账确认741份旧SQL快照（含528份一般模式）与4999个旧ID均不变，只新增1份快照/1个ID：全库742份/5000条，M 1079条。完整M回归304项通过（601.879秒，退出0），实际证据见 `work/m_compat_closure_20260908/prepared_analyze_test_results.json`；没有数据库执行。

## 第 18 轮：双模式有界补缺与真正的跨包事实消费

一般GRANT复用既有AST和9个valid值，补DATABASE LINK专用权限6条及PUBLIC SYNONYM权限4条；对象是专用新非登录角色，不创建远端链接。授权者资格、权限目录和回滚场景仍待验证。ALTER TABLE增加专用新表的多列MODIFY代表1条：原amount可空、note长度64，目标NOT NULL与VARCHAR96；原泛化conditional不变，独立valid facet强制此fixture和作用域。来源ADD/MODIFY/统计语义精确拆分，21个open_question保留。一般168非空包的取值缺口88→78；这不是全224包或实机通过率。

累计M审计原来把一般528份历史快照固定相等，合法新增也会失败。现在保留这528份哈希，只允许显式审核登记的新快照，逐一校验归属、真实渲染、完整覆盖与ID；未登记、旧文件漂移/消失、错误归属均失败。一般本轮新增3份、11条已有独立证据，不能自动收编磁盘文件作为新基线。

M PREPARE沿用FROM字符串结构，在ANALYZE之后补TRUNCATE PURGE、普通表单INTEGER键BTREE索引、两列直接投影视图、ALTER TABLE ADD可空INTEGER列，各1条独立候选。阶段仅PREPARE，不EXECUTE；不清理从未创建的索引/视图。权限来自各自章节的ENV导出，由新manifest真实引用，使用M与独占连接门。DDL三个代表不表示相应全语句族都已支持；body profile共9个，另10个额外语句族仍needs_profile。

这批实际暴露加载器与审计器不一致：审计能识别外部消费者，加载器却只统计本包引用。用真实CREATE INDEX/VIEW权限先复现，再在逐包校验前收集**已导出、可解析、消费者类型正确的实际跨包引用**。未导出、错误类型和只导出无人消费仍拒绝，来源账本/导出声明本身不计消费者；无需添加空场景或虚假本地引用。

实际证据见 `work/overnight_dual_20260908/` 下三批verification/test_results。DDL批31项专项通过，24项一般依赖回归及全库快照1项通过；完整M回归312项通过（607.015秒，退出0）。本轮全生成749快照、5015唯一ID，其中一般3932/M1083；DDL独立对账确认746旧快照/5012旧ID不变，仅新增3条。M全章静态和行为完整仍均0，来源原子性待审3221、未映射2556，29包错误Oracle与169planned均未消除。数据库未执行。

## 第 19 轮：文件合同跨模式复用，56包中推进一个真实候选

重新核对56份历史资产评审与正文哈希，无漂移；不重抄已完成的3411行复核。M已有实际INTEGER TSV校验及未部署阻断，因而一般章节LOAD DATA现在可以复用这些能力。本包来源属于一般章，但文档仅支持B/M，本批明确选B、5.7/s2、非PDB，并从COPY导出真实文件权限和safe_data_path事实作为环境门。没有把目录归属误解为普通兼容模式支持，也不自动设置权限/GUC或创建数据库。

共享文件模型仅新增允许的`/tmp/factor_assets/`根，旧M根不变；源文件仍必须在本fixture的assets目录，保持哈希、整数TSV形状、大小、路径和符号链接检查。专属三行本地文件与两INTEGER列新表匹配，只生成省略/显式列列表的2条候选。显式TAB/LF、非LOCAL、无SET/冲突/分区；部署状态仍false，旧执行器在建立数据库连接前跳过文件用例。planned结果场景给出精确三行，但没有执行证据。

未实现的LOCAL等11行产生式不再挂在有限syntax上冒充已消费，移入带实际runtime/SET open_question的needs_profile矩阵。保留2个问题，3个feature中仅1个representative，0个全域完整。原LOAD路径事实已经是environment，直接复用；仅5.7/s2配置事实按实际职责从constraint改environment，没有制造重复来源事实或改变PDF行。

先4项RED，再11项文件联测通过；旧batch11无清单集合实测1失败后，准确移出LOAD DATA并补2条未部署断言。未实现语法矩阵漏挂open_question时严格加载再次拒绝，修引用、不降门禁。最终55项专项（含M文件/LOAD/COPY及一般batch11）通过（70.901秒），10项快照/跨章依赖通过（48.468秒），累计M审计通过；本批未重复完整M312项，不能拿第18轮结果冒充当前全量重跑。

独立对账确认749旧快照、5015旧ID不变，仅新增1快照/2ID。全库现750快照、5017候选：一般169个有候选、3934条、159有限模型通过、3静态完整；M92个有候选、1083条。文件候选不等于实机可执行覆盖。当前55无普通清单路由见`NO_MANIFEST_REVIEW_ROUTES_CURRENT.json`，历史56路由原文件保留，并逐项记录LOAD DATA的迁移证据及未部署状态。运行证据见`work/overnight_dual_20260908/general_load_data_*`。

## 第 20 轮：SET 用户变量真正进入有限生成，而非仅作为 PREPARE 前置

M SET原文2.4.2.16.4 L23–25允许两种赋值符号；L97支持字符串/NULL存储。新增独立form分支及operator/value维度，实际生成单变量 `SET @m_set_value :=/= 'factor value'/NULL` 四种组合。Fixture先设置不同的initial value，使目标NULL也是真实状态迁移；目标后置NULL并要求关闭独占连接。没有借用时区事务或宣称ROLLBACK恢复用户变量。原PREPARE依赖的固定字符串Fixture没有变化。

新增维度导致原9条timezone用例的默认参数及ID变化，不能宣称所有旧ID不变，也不能为回避迁移把变量赋值塞进timezone槽位。预先保存旧9条，逐一核验SQL、预期、setup/teardown、环境与其余字段完全相同，只有明确列出的默认维度、消耗维度和ID变化；其余749旧快照/5008旧ID完全保留。迁移映射与新增4ID见`work/overnight_dual_20260908/m_set_variable_verification.json`。

用户变量feature仅representative，类型转换、数值/二进制、多变量、连续赋值、子查询与实际读回继续开放。两步结果集Oracle明确区分一行SQL NULL与字符串/空结果，scenario仍planned，不是行为验证已执行。

新4项RED后，新旧SET/PREPARE/session专项20项通过（38.271秒），一般文件/事实依赖及对账21项通过（42.997秒）。全生成751快照/5021唯一ID，一般3934不变，M1087；累计M审计通过。完整M回归316项通过（617.823秒，退出0），同时覆盖上批共享文件根的小改动。M仍92有限包、0全章静态完整、0行为完整，2556未映射、3221原子性待审、29包错误Oracle、170planned。没有数据库执行或文件部署。

## 第 21 轮：倒排索引的参数负例与合法对照

一般CREATE INDEX的两个非法取值以前没有目标负例：UGIN的fastupdate=off，以及GIN pending-list容量63（文档下界64）。本批复用既有AST和参数值域规则，新增4份独立manifest：每个负例各有一条相同表形、相同键的合法对照（on或64）。只有目标值域规则可以违反；错误方法、错误引擎或把合法值当负例仍被拒绝。

专用fresh Fixture分别创建USTORE BOOL[]和ASTORE INT[]单列空表。只CREATE自己的表、不先DROP旧名字、不CASCADE；目标后仅清理本case表，实际执行必须使用新隔离schema、正确授权并先恢复错误事务。没有扩大现有有CASCADE预清理的旧Fixture，也不把缺表/缺列/方法错配当作参数负例通过。

兼容环境选择固定A。加载器拒绝空fact_refs后，引用CREATE DATABASE L423–426的真实兼容环境枚举，并保持原DDL syntax事实独立；只有UGIN另引用CREATE INDEX L268的非M限制，不将其推广给GIN。两章通过已导出的环境事实真实连接，不改变共享模型。错误类别分别是ugin_fastupdate_disabled和gin_pending_list_limit_out_of_range；SQLSTATE空、Oracle needs_verification，控制/负例逐步场景仍planned。

最初新4测试7个失败分支，补实现后新5测试通过；旧审计断言明确从335→339（309正向/30负向）、8取值缺口→6，精确保留其余缺口和9个open_question。最终17项索引/来源/依赖专项（90.029秒）、32项一般数据库与M关联回归（55.164秒）、9项全库快照/批准门（16.951秒）通过。累计M审计不变1087条，一般536份快照=528冻结+8批准新增。

独立proof确认751旧快照、5021旧ID不变，新增4快照/4ID：当前755快照、5025候选，其中一般3938/M1087。只有2个已有非法取值获得对应有限负例；源unit仍209，所有场景与错误身份仍未实机验证。本轮没有再跑完整M316项，不能把上一批结果视为本轮全量重跑。证据见`work/overnight_dual_20260908/index_storage_*`。

## 第 22 轮：EXPLAIN OPTEVAL 的独立分支与受限选项

M EXPLAIN原文2.4.2.10.2 L54定义OPTEVAL boolean，L156–157仅允许与COSTS、VERBOSE、FORMAT搭配。复用已有三个维度，独立AST分支生成8条正向SQL，覆盖20/20活跃参数对；不把ANALYZE FALSE或BUFFERS FALSE当作省略该选项。新增1条明确含ANALYZE FALSE的目标负例，只有OPTEVAL选项规则可被违反。没有为了数量增加无关维度。

Fixture仍为显式创建的两INTEGER列源表及三行种子，查询体固定同一条SELECT。原4份EXPLAIN清单22条SQL和全库755份旧快照、5025个旧ID均保持不变。PLAN写plan_table的生命周期、PERFORMANCE与语法表的差异继续保留，未用这9条候选关闭全章问题。错误类别opteval_option_not_allowed仍未校准，SQLSTATE未猜测；真实计划内容及格式Oracle仍planned。

4项RED后15项专项通过（40.528秒），23项一般快照及来源依赖通过（62.961秒）；完整M回归320项通过（627.657秒，退出0）。生成757快照、5034唯一ID，其中一般3938、M1096；累计审计及队列已对齐。独立增量、测试证据见`work/overnight_dual_20260908/m_explain_opteval_*`。仍是离线生成与静态回归，没有数据库执行。

## 第 23 轮：前置失败不能授权盲清理

一般CREATE DATABASE的缺席断言若发现已有同名库，旧执行器仍会在finally执行DROP DATABASE。纯mock回归实际重现了这个顺序，未连接真实数据库。修复复用已有setup/test阶段标识：全部setup未成功时跳过未经所有权证明的teardown，保留fixture_error与原始错误，并在JSON及HTML报告中明确显示cleanup_skipped_reason。部分setup成功可能留下对象，不能称残留0；后续需要定向审查，不以盲DROP兜底。

成功setup后，目标成功/失败仍进入既有清理路径；清理自身失败仍为fail。M与文件执行的预连接阻断不变。旧测试中“建表失败仍应DROP”的断言按真实安全合同修正，并新增初始断言失败、部分setup失败、正常目标、目标失败、清理失败、无setup、报告展示7项测试。

专项与现有核心/M环境/文件门31项通过（12.604秒），9项全库SQL快照及批准门通过（16.299秒），累计M和队列重新对齐。没有修改规格或生成SQL，仍757快照/5034候选。固定数据库名的并发租约与成功setup后的所有权仍没有正式合同，因此未直接复制旧Fixture扩充5个客户端编码负例。这里解决的是安全执行阶段判断，不是增加实机通过率；证据见`work/overnight_dual_20260908/setup_cleanup_*`。

## 第 24 轮：PREPARE SET 的解析阶段与执行阶段分开

M PREPARE 增加一条受限的 SET SESSION TIME ZONE 'PRC' 字符串候选，双写内部引号，真实消费 M SET 的时区语法导出。Fixture 拓扑复用 SET 的事务前置，再 SHOW TimeZone 检查参数存在；目标仅 PREPARE，不 EXECUTE，清理顺序为 DEALLOCATE、ROLLBACK。没有临时造表，也不把“SET 可以预备”推广到用户变量；M SET L101 的限制继续保留。

独立 planned 场景给出 baseline SHOW、PREPARE、再次 SHOW、EXECUTE、最终 SHOW 的阶段顺序。解析后是否未改变参数、执行后是否为 PRC 语义仍需实机 Oracle，未猜测 SHOW 的规范化字符串。19 个已登记语句族中本分支只是 representative，余9个语句族仍 needs_profile。

4项缺失回归先失败，修后20项 PREPARE 专项通过（51.877秒）、25项一般/来源/清理回归通过（47.277秒）。独立 proof 确认757旧快照/5034旧ID不变，仅新增1份1条。初次完整M324项有1个旧测试计数/Fixture断言失败，已精确修为10个profile且SET仅需会话前置，随后相关7项通过；完整联合复跑324项通过（649.035秒，退出0）。历史失败记录保留，见`prepared_set_test_results.json`，未把首次失败改写为通过。

## 第 25 轮：PG INSERT 冲突候选必须有实际主键证据

一般 INSERT 正文 L335–367 限定 ON CONFLICT 的 PG 模式和权限；L453–472 给出普通主键表与 EXCLUDED 更新示例。新增专用两列表、id 主键、101种子，分别生成 DO NOTHING 与 DO UPDATE note = EXCLUDED.note，各配冲突101和无冲突102/103输入，共4条。无查询源、重复源键、唯一键列更新、表达式或部分索引。4个泛化conditional取值和7个open_question均保留，新有限facet不替代整个域。

实际变异揭示仅靠 profile/provides 不够：删除 setup 中 PRIMARY KEY 或移除 PG 环境门，旧生成仍放行。新增 opt-in 内联主键检查，从最后有效的完整普通 CREATE TABLE 读取证据，核对目标身份、唯一键与 ON CONFLICT 目标；DROP/ALTER/重复CREATE使证据失效。NOT NULL、名叫id、DEFAULT字符串含PRIMARY KEY都不能证明唯一。未扩展公开模型、DEFAULT解析或完整索引目录；复合、命名、部分和表达式约束仍待审。

本批40项新旧/共享列回归通过（38.017秒），47项 DEFAULT 与 M INSERT 消费者回归通过（64.650秒），22项一般/来源/快照/清理回归通过（33.412秒）。初次新增快照登记误用排序ID，被严格累计审计拒绝；仅改该条目为实际生成顺序后审计通过，未放宽断言。独立 proof 核实758旧快照/5035旧ID不变，现759快照/5039候选：一般3942、M1097。

两份 planned 冲突/无冲突结果场景给出精确有序行，未执行数据库。一般169个非空包中159个有限模型通过、3个全章静态完整、0行为完整；这10个有限模型缺口包仍有76项取值缺口，不代表全224包仅余76项。新的按包账本见`general_gap_after_insert_pg_conflict.json`。完整324项M联合回归通过（649.035秒，退出0），最终快照/批准门9项通过（16.917秒）；使用本轮联合输入seal核对当前产物，不复用第22轮320项结论。两种模式仍没有数据库执行证据。

## 第 26 轮：REPLACE 的多唯一键冲突不是“只改一行”

原 multiple_unique 场景将双唯一冲突与 DEFERRABLE 限制合在一句 action 中，没有表或具体 SQL。本批新增新鲜普通表 id INT PRIMARY KEY、qty INT UNIQUE 和两行 (1,10)/(2,20)，单行 (1,20) 会分别命中两条不同旧行；合法对照 (3,30) 不冲突。只生成这2条新候选，原18条 REPLACE 候选及全库759旧快照/5039旧ID全部保留。新总量760快照/5041ID，一般3942/M1099。

新的 opt-in 合同完整读取实际两列 INT 建表、两行 seed INSERT 和一行目标 VALUES。去 UNIQUE、seed 本身冲突、改输入导致只冲突一行、错表、额外DDL、NULL/DEFAULT/查询/多行/延迟约束均不会被当成已证明的双行冲突。它不扩大 ordinary_columns 的 DEFAULT/NULL 推导，也不模拟通用数据库；只为本例计算两个整数独立键的冲突行集合。真实变异先暴露去UNIQUE/改seed仍放行，再补有限检查。

唯一键与主键语义由 M CREATE TABLE L566–568、584–588 持有并真实导出给目标 profile。REPLACE 原 syntax 事实错误指向功能描述和零值表的 L10–39，现按真实 VALUES、QUERY、SET 产生式分别定位 L83–88、93–99、102–108；不把一个超长说明段继续当作语法覆盖。尚未解释的零值、分区、延迟和复杂类型仍是缺口。

两个独立 planned 场景分别期望最终行 [[1,20]] 与 [[1,10],[2,20],[3,30]]；按 L19 的删除+插入计数，目标标签待验证预期分别为 REPLACE 0 3 与 REPLACE 0 1，不是简单“插入1行”。DEFERRABLE 场景另保留待构造前置和待校准错误身份，不能把建表失败当目标拒绝。

41项新旧 REPLACE/PREPARE/共享列/DEFAULT/builder专项通过（54.961秒），39项一般模式与快照合同回归通过（30.625秒）；独立增量 proof、累计和队列已对齐。完整330项M回归通过（666.482秒，退出0），没有将上一批324通过代入本批。来源拆分后未映射unit为2562、原子性待审3235，29包错误Oracle不变、173planned；计数增加反映新拆出的真实缺口，而不是新增实机失败。

## 第 27 轮：浮点序列的模式作用域必须参与生成校验

一般 CREATE SEQUENCE L68–69明确B接受浮点步长并转换成整数，非B不接受，但没有规定1.5的取整结果。本批保留原泛化conditional与取整/目标错误open_question，另加B正向和PG负向两个有限facet；均锁定普通序列、显式1/100/1边界、NO CYCLE及专属表OWNED BY id。Fixture只创建自己的空表，目标序列通过文档明确的列从属关系清理，最终只DROP该表；未扩大旧170条序列候选或给其批量添加盲清理。

新内部opt-in属性required_compatibility_modes由生成器读取实际被AST消费的取值。所需模式非空、唯一且属于已知枚举；manifest必须恰有一个非空模式门且不能扩大到属性之外。遗漏、重复、错误或矛盾门直接报错，未激活分支不施加要求。它不是自动验证数据库模式，也不替代全部能力矩阵或放宽环境规则。

5项helper缺失RED、4项候选缺失RED后，9项专项通过12.662秒。全生成762快照/5043唯一ID，一般3944/M1099；独立proof确认760旧快照和5041旧ID完全不变。PG错误SQLSTATE仍空，Oracle needs_verification；planned场景只采集实际nextval差，不猜1.5变成1或2。

联合检查暴露上一索引批加入的CREATE INDEX→CREATE DATABASE环境依赖未登记在老15节点试点。现显式纳入第16个提供者、四处具体mode门和其真实来源；CREATE DATABASE自带的CREATE TABLESPACE/DROP DATABASE仅正文依赖也纳入，形成16任务/20正文，而不是额外执行四个正文包。严格图相等和独立正文期待继续保留；selector检查防止把另一环境门上的引用当作当前门的依据。两轮失败证据保留，最终跨章11项、指定门2项均通过，实际PDF证据另核对24个Fact引用和2个Fixture引用。本批完整M330项通过（672.241秒）；一般77项首跑75通过、2个旧基线计数失败（701.501秒），修正CREATE INDEX 26清单/339候选和INSERT16清单/111候选后，原两处失败与全库快照批准门11项复查通过（46.009秒）。不将初次77项失败改写为完整通过，也不重复未受影响的75项。证据与当前输入哈希保存在sequence_float_*。

## 第 28 轮：预备 COMMIT 不等于提交事务

M PREPARE 原文 L44 列出 COMMIT，但原19个语句族里该项仍只有来源、没有有限profile。本批真实导入 M COMMIT 的语法、事务创建者权限与提交语义，复用其已有Fixture：新表、seed0、BEGIN、未提交INSERT1。wrapper再读取COUNT记录前置；生成目标只PREPARE，不提前COMMIT或EXECUTE；清理DEALLOCATE→ROLLBACK→DROP本表。

planned场景先PREPARE后ROLLBACK，再查询应只剩0；再开事务插入1、EXECUTE同一个预备语句、ROLLBACK并查询应为0/1。两次结果明确绑定不同步骤，分别验证“预备没有提交”及“执行才提交”；ROLLBACK不释放预备语句的事实来自PREPARE L7–13。无活动事务的消息仍需实机记录，不当成目标错误。

4项缺失回归失败后34项PREPARE/来源/旧分支/builder检查通过（93.387秒）。原10个profile及SQL/ID全保留，仅1新候选；语句族缺profile从9减至8，不推断所有COMMIT可选词或跨会话执行。独立proof核实762旧快照/5043旧ID全不变，新763/5044；实机未执行。

## 第 29 轮：B 模式 COMMENT 复用所选值模式合同

一般 CREATE INDEX 的 COMMENT 曾因模式前置不足整体保留conditional。本批不改变该父值，只增加短ASCII、普通ASTORE、INTEGER直接键BTREE的B有限facet，真实新建空表并通过DROP本表清理索引，不预清理既有对象。源码659–665的语法、B环境、1024字符长度分成三个有类型的事实，引用既有三个原子unit；未增加假的source覆盖数量。

该新值直接复用第27轮模式合同，去掉B门、改A/M、扩大B+A均被拒绝；没有再写一个按manifest ID的特殊分支。短注释不关闭1024边界、Unicode、重复COMMENT和目录Oracle缺口。新增具体建索引步骤的planned场景，元数据接口尚未校准，不猜系统目录字段。

4项缺失RED之后，14项中仅旧INDEX计数断言失败；按真实新增1条修为27清单/340候选/310正向/30负向。27项一般/跨章/全生成质量检查通过（111.583秒），9项全快照与批准门通过（18.114秒）。两批联合为764快照/5045唯一ID，一般3945/M1100；该增量独立确认763旧快照/5044旧ID全保留。完整M334项联合回归实际通过（679.135秒，退出0），本轮PREPARE COMMIT与COMMENT共同验收，不以此前330项通过替代。仍无数据库执行证据。

## 第 30 轮：解除关联必须从已有关联开始

M ALTER SEQUENCE 原 finite 中的 OWNED BY NONE 使用未绑定列的旧shared序列，因此不代表解除已有关联。本批新增专属新表与 START5、未调用nextval、已OWNED BY该表列的序列。目标仅ALTER SEQUENCE ... OWNED BY NONE；通过省略可选MAXVALUE/CACHE分支表达，旧有限清单仍显式排除新增空change值，不改变原16条ALTER候选。局部准入规则只约束本清单的选择，不宣称其他组合是产品非法。

旧association场景保留ID，换真实前置与专用清理，明确执行解除关联→删除本表→nextval预期5，仍planned。清理只DROP IF EXISTS本case序列再本case表，适应目标失败、解除成功及场景已删表三种状态；setup失败不得清理未确权对象，已有执行器门禁继续有效。没有DROP OWNED、CASCADE预清理或调用外部数据库。

权限从真实正文补齐：M CREATE TABLE L12–13、CREATE SEQUENCE L17–18导出环境事实，目标清单真实消费；ALTER SEQUENCE L9–10权限与L51同owner/模式分开记录。生命周期事实不冒充环境权限。拆分原文块后未映射2564、原子性待审3241；这不是将新增记录等同覆盖，29包错误Oracle与174planned仍保留。

4项缺失RED后16项新旧序列/builder回归通过（39.780秒），20项一般快照/批准门/跨章来源检查通过（50.050秒）。独立增量proof确认764旧快照/5045旧ID全保留，仅新增1候选，现765快照/5046ID，一般3945/M1101；全M338项回归实际通过（695.313秒，退出0），按本轮证据封存，不借用上一334结论。

## 第 31 轮：列改名核对实际DDL，而不只相信profiles

一般 ALTER TABLE 新增普通RENAME两种COLUMN拼写与B CHANGE同定义改名，共3候选/2清单。复用同一新普通表id/code/note与两行短字符串；code实际VARCHAR32、可空无DEFAULT，新名code_new不存在。原复杂regular表、13取值缺口和21个open_question保留；不纳入FIRST/AFTER、MODIFY行为开关、类型转换、依赖重建或ONLINE。

共享check_rendered_column_rename读取实际目标SQL和有序setup，用ordinary_columns核对目标表、旧列和新列；只接收一条CREATE及可检查的本表seed INSERT。重复建表、列变更、索引、CALL、DROP、目标/名称映射不符、默认/非空/唯一约束与不透明DDL均不能冒充受控的同定义改名。实际CHANGE还必须有精确B门，普通RENAME不套用B-only条件；生成器只消费激活的table_profile合同，未使用该属性的旧包不受此有限合同影响。返回列序只是静态推导，不是数据库目录Oracle。

两份planned场景查询id/code_new/note，预期两行保持；列名、默认/可空性、列序目录证据仍待实际接口与授权。未从“DDL像改名”推出实机行为成功。

原CHANGE source unit 393–404拆为产生式393–395、名称/定义396–399、环境400–404三个unit，211→213。环境组至少六个独立条件，现只有五个聚合/未决映射，审计明确暴露independent_claims_exceed_fact_mappings；ALTER的source_extraction_complete因此由true回到false。保留这一真实缺口，不降低独立条件计数或增添空fact凑绿；其他静态/行为结论仍false。

纯helper7项先因缺功能失败，首次实现发现测试把省略末尾可空列误当成超宽INSERT；诊断确认现有写合同会检查省略列，改为真正四值/三列反例后通过，未放宽生产检查。新候选4项缺失RED之后18专项通过26.559秒。跨章初次12项有两处旧图/数量断言失败，显式加入ALTER→CREATE DATABASE及5个真实环境门消费者，精确更新19清单/281候选、270正向/11负向和213单位，保留旧SQL。

最终36项一般/模式/来源/跨章/精确基线通过88.761秒，9项全库快照与批准门通过17.598秒，64项共享列/写入/DEFAULT/PG冲突回归通过27.089秒。独立proof确认765旧快照/5046旧ID全部保留，现767快照/5049ID（一般3948/M1101）；一般批准账本542份=528冻结+14明确新增。新缺口报告仍169非空/159有限/3静态/0行为/10缺口包76取值差额；来源形式台账168/169不是逐事实语义全覆盖。

完整M338已实际通过（706.592秒，退出0），未复用上一338通过。真实PDF依赖闭包再提取也已完成（exit0，a9d19f）：20/20正文哈希吻合、16个任务、29个真实Fact引用，逐包调度/生成与定向失效检查通过，目标SQL与ID未变。本机默认Python缺pypdf的失败记录保留，成功轮使用已有bundled PDF Python，未安装依赖。此为离线跨章验证，不是数据库执行或全章语义完成。

## 第 32 轮：M CHANGE复用列合同，章节身份决定模式

M ALTER TABLE正文L176–179有自己的CHANGE产生式和新旧列名条件，不能因一般章节要求B而推断M不支持。共享列合同保留默认一般B作用域，生成器依据已核的general/ddl/alter_table.txt与m_compat/ddl/alter_table.txt选择B/M，再检查实际环境门。错章节、缺来源、重复模式门或M/B混用均拒绝；不接受任意YAML指定产品模式覆盖。

M新form=change_fresh直接提供实际目标表名，只有新AST分支消费该值的column_rename_contract；hook因此支持实际激活维度的显式合同，而不只固定table_profile名字。没有新增全局维度，避免改变所有旧case ID。新的普通表id/qty均INTEGER、可空无DEFAULT/约束/索引，seed为(1,10)/(2,20)，生成CHANGE和CHANGE COLUMN两个同定义改名候选。旧41个M ALTER候选及其中6个带DEFAULT/FIRST/AFTER的CHANGE全部保留，不声称新合同已经检查它们。

真实M CREATE TABLE权限导出由新manifest消费，M ALTER自己的表所有者权限仍必需；setup只创建专属新表并插入两行，teardown只DROP自己的表。模式建库/重连由既有M环境阶段承担，本轮不执行数据库。planned场景读取id/amount保持两行，并要求未来校准列名、列序、类型、默认和可空目录结果，不把静态投影推导当实机结果。

新增4项回归先因缺manifest失败（13.159秒）；首轮22项新旧M/一般/helper专项通过（38.716秒），完整M342通过713.543秒、当前完整一般factor模块48项通过628.822秒。实际收集数量为48，不沿用历史77的预估。独立proof确认767旧快照/5049旧ID完全不变，现768快照/5051ID（一般3948/M1103），仅新增2个M候选。

冻结输入等待时追加只读变异探针，又发现M合同错误接受一般RENAME COLUMN形状（1项真实失败）。已有两条CHANGE候选并未生成错SQL，但有限校验器的作用域仍过宽。待首轮作业结束后添加守卫：已核M列改名合同只接受CHANGE，未审阅的M RENAME COLUMN留待其他来源证明，不宣称产品绝对不支持。正式helper与实际AST变异测试已补，23项最终专项通过41.739秒；再生成的报告SHA与768/5051独立proof完全一致。最终完整M342通过723.920秒、一般模块48通过655.925秒、88共享/来源/模式/快照回归通过63.159秒，均退出0。队列仍93登记/92有限/0全章静态/0行为；2564未映射、3243原子性待审、175planned，新增数量不能替代语义覆盖结论。

## 第 33 轮：新增列位置与NULL行预期，共用真实前置列合同

一般ADD子句L349–356说明无DEFAULT时已有行新字段为NULL；位置参数L1137–1147另行明确B-only及加密/规则/外表/SET限制。M自己的L144–149及L596–603分别说明无默认NULL和FIRST/AFTER，不套一般B-only门。两边仅使用无业务数据、无规则/索引/约束/加密的新普通表，未把MODIFY的enable_modify_column混入ADD条件。

新共享check_rendered_column_add只接收实际单条ADD [COLUMN] extra INTEGER FIRST/AFTER旧列，并从真实CREATE读取新列不存在、AFTER旧列存在；无DEFAULT、NOT NULL、IF NOT EXISTS或任意复杂类型。新增_fresh_plain_column_fixture被ADD与既有RENAME/CHANGE共同使用，核对一条CREATE加有限seed，拒绝DROP/ALTER/CALL/索引与不透明DDL；没有泛化为完整DDL状态机。返回新列序/可空/无默认仅是静态合同结果。

一般新增一个manifest两种位置，M新增一个form及manifest四个COLUMN拼写/位置组合；没有新全局维度，旧M ADD DEFAULT7六条仍保留，普通FIRST父conditional不改为valid。两份planned场景SELECT *明确区分FIRST和AFTER列顺序，旧行新增值为NULL，目录类型/可空/默认/位置依旧待授权校准。没有执行数据库。

纯helper6项先因缺功能失败，候选4项先因缺manifest失败；15共享helper通过0.011秒，33新旧一般/M/helper专项通过52.136秒。一般审计旧281计数真实失败后准确改20manifest/283候选（272正向/11负向），复核通过13.340秒，原213源unit、1个atomicity gap、21open_question与13取值差额不变。

独立proof确认768旧快照/5051旧ID全保留，现770快照/5057ID（一般3950/M1107），一般批准账本543=528冻结+15明确新增。最终88共享/模式/来源/批准回归通过60.859秒、完整M342通过709.440秒、一般模块48通过639.724秒，均退出0。最新一般缺口仍169非空/159有限/168来源形式闭合/3静态/0行为/76取值差额；M未映射2565、原子性待审3247、176planned，不能将记录增长视为全章质量完成。

## 第 34 轮：CREATE失败不授权清理，负向命中不掩盖未清理状态

实际资源池候选的纯Mock复现证明：setup查空成功后目标CREATE失败，旧执行器仍会DROP；查空不等于对象所有权。已补保守门：直接CREATE（含前置BOM、行注释、嵌套块注释）目标error/core时停止所有teardown，保留原始目标错误与cleanup_skipped_reason，要求检查可能残留。匹配目标错误Oracle也仅pending，不冒充通过或零残留；不匹配仍fail。setup失败保护、普通CREATE成功清理和DML失败清理保持原行为。

这是有限失败保护，不是完整资产所有权合同。成功的IF NOT EXISTS/OR REPLACE、多语句或例程内隐式创建，以及成功后对象被替换的竞态尚未解决；跳过清理可能留下本case的setup对象，必须诚实记录。没有使用DROP OWNED、吞异常或宽泛CASCADE兜底。

真实候选1项RED、扩展8项RED后，20项安全/报告/Oracle测试通过0.061秒，8个直接执行器消费者模块50项通过26.906秒，累计离线生成审计退出0。此轮未改SQL规格，保留770快照/5057唯一ID及上一ADD回归证据；全M342与一般48是修改执行器前的上一批验证，不冒充本次重新运行。所有执行均为Mock或离线审计，未连接数据库。

## 第 35 轮：PREPARE CREATE TABLE只预备，不提前建表

M PREPARE正文明确包含CREATE TABLE族；新增一个专属新模式下两INTEGER列普通表代表，不含IF NOT EXISTS、临时、分区或约束。创建语法及权限真实引用M CREATE TABLE导出事实；模式创建引用M CREATE SCHEMA的命名空间、数据库CREATE权限和同名用户模式对象归属三个事实。没有把M CREATE DATABASE误当物理建库，也不把SCHEMA章节锚点套给另一章。

Fixture只CREATE SCHEMA，不预先CREATE目标表；目标只PREPARE字符串。清理只DEALLOCATE及DROP空模式，不对尚未创建的目标表运行DROP。环境限定独占同会话、新模式不与任何用户同名。planned场景在预备后检查表不存在（目录接口仍待校准），EXECUTE后插入并读取两行，先清理实际创建表再释放prepared和模式。中途失败仍需实际资产归属和分阶段清理，不声称执行器已全自动支持此场景。

新增4项真实RED后，新旧prepared39项首次有7个旧汇总计数失败；准确更新12代表/7缺profile，保留19语句族及所有旧逐族断言。最终39项通过113.485秒；88共享/模式/来源/快照回归通过62.561秒。独立proof确认770旧快照/5057旧ID全保留，仅新增1M候选，现771快照/5058ID（一般3950/M1108）。累计审计通过，新队列仍93登记/92有限/0全章静态/0行为，2565未映射、3249原子性待审、177planned。完整M346项回归已实际通过725.824秒，退出0；这仍是离线回归，不是实机语义验证。

## 第 36 轮：一般B单目标DELETE USING自身，保留独立审计缺口

DELETE自己的L159–163允许B或多目标时USING重复目标；本批只选择B单目标普通新表，无WHERE/ORDER/LIMIT/RETURNING。沿用原AST组合有/无FROM两种拼写，新增有限profile和值的required_compatibility_modes=[B]被现有生成器消费；缺模式、A/M或B+A宽门均拒绝，不修改原conditional值和游标限制。

新fixture显式创建两列表并插入三行，没有DROP预清理；两份planned场景各自独立重建seed，删除后SELECT应为空。未来affected rows应按实际删除目标行验证，不拿自连接中间组合数替代；当前没有数据库证据。建表权限/用户模式真实消费CREATE TABLE导出，16章依赖图新增DELETE→CREATE TABLE，31个Fact引用及20份正文/实际PDF哈希已检查，没有重复提取全书或用mock替代来源。

4项缺失RED之后首轮32专项仅精确依赖图少新边失败；补入两个具体环境门引用而非放宽断言。最终51项一般/模式/DELETE/快照/来源回归通过47.168秒。独立proof确认771旧快照/5058旧ID全部不变，仅新增2一般候选，现772快照/5060ID（一般3952/M1108），一般批准544=528冻结+16明确新增。完整一般factor模块48项已实际通过627.054秒、退出0；未执行数据库。

独立DELETE检查器此时还未消费环境：73候选中35有限shape checked、38 needs_review、0正向rejected；新两条自连接属于needs_review，生命周期同样未闭合。因此新增语法候选不等于语义或执行质量门通过。一般仍169非空/159有限模型/3全静态/0行为/76取值差额，M仍93登记/92有限/0全章静态/0行为；不能把这一代表对泛化域的部分帮助算成旧缺口全部消失。

## 第 37 轮：独立DELETE形状审计真实消费声明环境

上一轮保留的具体缺口已通过一个有限消费者补齐：inspect_delete可显式接收environment_requirements，audit_delete_contracts传递实际case字段。只有一个模式门恰为[B]、同一实际普通表且使用完全一致标识符、不同显式USING别名，并且没有CTE、目标别名、ONLY/*及WHERE/ORDER/LIMIT/RETURNING时，才增加delete_self_using_declared_b形状证据。默认两参数调用不猜B；缺门、错/宽/重复门、畸形结构、限定名歧义、视图、目标变化和更宽自连接形状仍待审。其他两表USING行为不变。

这里的B是声明条件，不是数据库实测。合同限度明确写明不能证明权限、行数、可见性、资产归属或数据库行为；没有改变生成层SQL/预期，也没有把结果回填成全章已完成。

真实audit消费者先失败，缺环境参数产生3个错误，默认无环境调用保持待审；最小适配后27纯检查通过0.188秒，最终53项模式/DELETE/清理回归通过13.484秒。73条独立审计从35 checked/38待审变为37 checked/36待审，0正向rejected；逐case对账仅新两条形状状态改变，73个完整case身份、生命周期和错误Oracle全不变，772份SQL及5060个ID不变。固定输入的其余96个非M模块宽回归已实际772项通过（exit0，1109.912秒），8849个输入端点无变化。M及五因子模块的互补收尾回归也已实际394项通过（exit0，1361.443秒），其57模块与前96模块分开运行；不是用历史M346/一般48冒充本次最终收据。两份原始receipt及日志保存于work/overnight_dual_20260908/final_*_regression，最终封存需检查模块全集、输入一致及当前产物。
