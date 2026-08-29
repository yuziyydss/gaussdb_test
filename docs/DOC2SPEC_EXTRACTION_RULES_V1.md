# Doc2Spec Extraction Rules V1

状态：已定稿。适用于从 GaussDB 产品文档抽取 Factor Package Schema V1。

## 1. 抽取目标

抽取不是把文档示例改写成几个 SQL，而是建立一条可审计链路：

```text
产品原文
  -> 原文 source unit 覆盖账本
  -> 原子事实
  -> 事实分类与置信状态
  -> 维度/等价类/能力 profile
  -> 可追溯规则
  -> manifest 测试意图
  -> 静态生成与覆盖报告
```

当前阶段止于 SQL 静态生成，不以数据库执行结果反向篡改文档事实。执行发现的差异应作为新的验证证据进入 review。

在抽取任何 fact 前，先按“能够独立决定处置方式”的粒度切分 source unit。标题、语法分支、参数语义、限制、行为说明和示例应分别建单元；不要把整页原文当成一个单元，也不要为了提高覆盖率把一句话机械拆成词。

每个 source unit 必须声明或保留原子性复核状态：单一主张为 `atomic`；暂时保留多个独立主张时使用 `grouped` 并填写 `independent_claim_count`；尚未复核为 `unreviewed`。原子性审计缺口会直接阻断 `source_extraction_complete`，因此“行号覆盖 100%”不再等价于“事实抽取完整”。

每个 source unit 必须且只能落入一种处置：`mapped`、`open_question`、`out_of_scope` 或 `unmapped`。覆盖率中的“已处置”包含前三种，不包含 `unmapped`；`out_of_scope` 必须说明边界理由，不能作为隐藏遗漏的垃圾桶。账本必须保留原文哈希、总行数、锚点和行号范围；每一行都必须被 unit 覆盖，或作为标题/空行进入带理由的 `ignored_lines`，使遗漏整段文字和后续文档变更能够被检测。

主文档只枚举能力名称、但未展开合法子语法时，可以引用同产品的官方补充章节。补充来源必须记录稳定 ID、文档版本、URL、检索日期和锚点，并由对应 source unit 的 `supplemental_source_refs` 显式引用。不同产品、无版本博客或模型记忆不能用来把 `needs_profile` 强行改成 `covered`。

## 2. 输入要求

每次抽取至少记录：

- 产品名、语句名和文档标题。
- 文档版本；原文未给出时写 `unknown`。
- 文档章节或锚点。
- 完整原文或可稳定访问的来源。
- 与当前抽取无关但被文档引用的外部章节，记录为待补证据，不自行补全。

## 3. 九步抽取流程

### 第一步：确定语句边界

先回答这份规格覆盖哪条语句以及覆盖到什么层次。例如 CREATE VIEW 的主语法属于本包，ALTER VIEW COMPILE 是 FORCE lifecycle scenario 的一个步骤，但不是 CREATE VIEW 的语法槽位。

确定边界后立即创建 source ledger：属于当前因子的内容进入 `mapped`、`open_question` 或暂时 `unmapped`；仅有明确边界依据的内容才能标记 `out_of_scope`。不得等 SQL 生成完成后反推“原文大概已经覆盖”。

### 第二步：逐字抽取语法骨架

从“语法格式”提取关键字顺序、可选段、互斥分支、重复结构、标识符和 SQL 子句。只写进 syntax，不先填测试值。

必须区分：

- `optional`：可省略。
- `choice`：多个互斥分支。
- `repeat`：零次或多次。
- `identifier`：需要生成或绑定名称。
- `sql_fragment`：由能力 profile 提供的子 SQL。

简单语句可使用线性 production；存在多个顶层产生式、重复列表、可选子树或嵌套查询时，必须使用递归 AST 模型和命名 subgrammar。AST 的一次生成必须有限：循环 ref 必须被拒绝，候选重复项由 factor value 的结构化 `properties.items` 提供，不能重新退化成超长整句字符串。

### 第三步：建立测试维度和等价类

只有能够独立变化、且可能影响语法或语义结果的因素才建立 dimension。关键字同义词可以属于同一等价类，但保留不同 value ID。

不要把以下内容误当成普通枚举：

- 完整 SELECT 查询：应建 query capability matrix。
- 表结构：应建 fixture。
- 对象不存在、已存在、跨会话：应建 scenario precondition。
- 权限和兼容模式：应建 environment fact / scenario。

SELECT 等表达式型语句还必须同步提取列契约：查询源可见列和类型、投影引用列、输出列和类型、非聚集列、GROUP BY 列、ORDER BY 列、集合运算两侧列数和类型。无法建立这些契约的子句组合不得宣称为可执行 SQL。

每个值都要标记 `validity`。文档仅说明语法、没有说明组合是否合法时，使用 `conditional` 或 `unknown`，不要猜测为 success。

### 第四步：抽取规则

只有文档明确表达，或由语法产生式必然推出的关系，才能成为硬规则。规则必须：

- 有稳定 rule ID。
- 引用一个或多个 confirmed fact。
- 使用受限表达式语言并在加载期编译。
- 能输出过滤原因。

文档没有说明的组合不能为了“让 SQL 看起来合理”而擅自过滤。

若关系是生成所需的结构一致性、但原文没有直接给出失败语义，应保存为 `inferred` fact 并由 `structural_checks` 消费，不能借用一条含义较宽的 confirmed fact 包装成产品硬规则。

### 第五步：识别 fixture 能力

读取 SQL 片段中的表名、列名、类型、唯一性、分区、临时性和种子数据要求。最小 fixture 应只提供当前 suite 必需的能力。

同一对象能力在 package 内只定义一次。普通两列整数表、临时表、分区表、GIN/GiST 特殊列等不得混为一个万能 fixture。

文档枚举多个能力或限制时，要逐项建立覆盖账本：能安全构造代表 SQL 的标记 `covered + profile_refs`；缺少子语法或证据的标记 `needs_profile + open_question`。禁止只抽取容易写的几项而不记录剩余项。

### 第六步：拆分 positive、negative 和 scenario

- `positive manifest`：文档明确支持，且前置能力已知。
- `negative manifest`：文档明确禁止或明确要求失败，`violates_rule_refs` 指向被违反的规则。
- `scenario`：需要对象既有状态、多条 SQL、事务、会话、权限、GUC 或行为/元数据断言。

一条 CREATE 成功不等于功能已经验证。语法冒烟、功能行为和 metadata oracle 必须分开标注。

对 negative manifest，`violates_rule_refs` 中的规则不是被忽略，而是从“必须满足”反转为“必须违反”；未列出的规则仍必须满足。这样可以确保每个负向用例只有可解释的目标违规，而不是任意非法 SQL。

每个 negative manifest 必须另外给出目标错误 Oracle。优先使用文档或已验证环境中的 SQLSTATE；暂时没有稳定 SQLSTATE 时，至少声明稳定的错误类别标签和足够窄的消息正则。缺表、缺列、setup 失败等非目标错误绝不能让负向测试通过。

### 第七步：分类保存全部事实

参数说明、注意事项和行为描述都拆成最小可独立判断的事实。一个 fact 不应同时表达权限、生命周期和行为结果。

示例只作为 `example` 证据。只有正文也明确支持时，示例中的现象才能提升为 confirmed constraint 或 oracle。

### 第八步：处理歧义和缺失

遇到以下情况必须创建 `open_question`：

- 语法与参数说明不一致。
- 示例出现正文未解释的省略写法。
- 文档链接损坏，无法确定标识符或错误码规则。
- 组合关系、优先级、重复参数、兼容模式或版本差异未说明。
- 需要数据库验证才能知道行为。

open question 不参与约束过滤，也不能偷偷写成 expected success。

### 第九步：生成 manifest

manifest 只从 factor 中选择稳定 value ID 或 matrix profile ID。按测试目的拆分文件，不建立一个包含所有维度的超级 manifest。

正向 manifest 只能选择 `validity: valid` 的值。语法 token 已被文档确认、且 manifest 已显式绑定兼容模式/版本等环境 profile 时，token 可标为 `valid`，行为结果放入 scenario。若当前模型还不能把必要环境前置条件绑定到用例，值必须暂记为 `conditional` 并只进入 planned scenario，不能在默认环境下伪装成 success。真正连语法是否成立都没有证据时使用 `unknown`。

建议最小集合：

- 基础正向语法。
- 选项正向语法。
- 文档明确的负向组合。
- 单独的 lifecycle / behavior / metadata scenarios。

## 4. expected 的语义

expected 必须说明范围：

- `syntax_only`：只断言能生成结构合法的 SQL，不承诺数据库成功。
- `syntax_and_semantics`：前置 fixture 满足时文档明确应成功或失败。
- `behavior`：需要执行后续操作判断。
- `metadata`：需要系统表或 information_schema 断言。

优先级建议：明确的 negative rule > manifest 明确预期 > factor 值的固有 validity > 默认值。默认值不得覆盖已知非法事实。

Fixture 必须可编译成独立生命周期：setup 创建对象，seed 构造最低限度数据，teardown 逆序清理。普通表可以由声明式 `provides + seed + execution:auto` 生成；分区或其他特殊对象使用显式 SQL。执行器必须区分 `fixture_error`、目标 SQL 错误和 `cleanup_error`。

## 5. 组合覆盖规则

先计算可行值域，再计算覆盖目标：

1. 解析所有选值和 profile。
2. 应用 confirmed 硬规则，保留可行组合。
3. 从可行组合投影出理论可行 pair 集。
4. 生成覆盖集。
5. 验证实际 pair 集与理论集一致；有缺失即失败。

禁止先计算全笛卡尔积再逐个生成所有 SQL。大空间应使用约束感知的增量构造、候选采样或 SAT/CSP 求解，但覆盖验证仍是硬后置条件。

每次报告至少输出：可行组合估计/计数、理论 pair 数、已覆盖 pair 数、缺失 pair、重复 case ID、规则过滤统计和无法解释的字段。

## 6. 静态校验

不连接数据库也必须检查：

- 原文 artifact SHA-256 与 source ledger 一致。
- 每个 source unit 都有合法行号、明确处置和可解释引用。
- Source Unit 原子性已复核；不存在超长未复核 unit、伪原子 unit 或主张数大于 fact 映射数的 grouped unit。
- 每条非 inferred fact 至少有一个 source unit 来源。
- YAML Schema 严格校验。
- ID 唯一和引用闭合。
- syntax 槽位与维度绑定完整。
- manifest 只引用存在的 value/profile。
- 规则可编译且引用 confirmed fact。
- inferred 结构关系只能进入 structural check，不得作为产品硬过滤规则。
- 列别名数量与查询输出列数相容。
- SELECT 投影、GROUP BY、ORDER BY、集合运算的列数和类型契约相容。
- INSERT 显式目标列数与 VALUES/查询输出列数相等；省略列列表时输入不超过目标可用列数，并按前 N 列校验类型；DEFAULT VALUES 单独处理。
- CREATE INDEX 键列列表非空，INCLUDE 只能引用非键列；普通/分区/在线/GLOBAL 形态分别应用文档列数上限，目标表、键列和 INCLUDE 列必须由同一 Fixture 能力提供。
- ALTER TABLE 必须把通用 action、RENAME、SET SCHEMA 和多列产生式拆成顶层 AST 分支；表目标的普通、星号、ONLY 和 ONLY(...) 形式不能靠字符串替换猜测。
- 文档声明 ONLINE 被忽略并以 NOTICE 降级离线时，这是 lifecycle/behavior oracle，不是负向错误；只有明确越界参数或明确禁止的 action 才进入 negative manifest。
- SQL 引用的对象/列由 fixture 或 scenario 提供。
- positive manifest 不包含已知非法组合。
- negative manifest 指明违反的规则。
- negative manifest 声明目标 SQLSTATE 或错误类别/消息 Oracle，任意错误不能通过。
- Fixture 能生成 setup/seed/teardown，且引用对象与列契约一致。
- 每条 confirmed 非示例事实至少有一个规格消费者。
- 文档枚举能力均显式标为 covered 或 needs_profile。
- Pairwise 可行 pair 覆盖率 100%。
- 因子级全局审计没有隐藏的有效值、规则、manifest 或文档 feature 缺口。

## 7. 完成状态

- `draft`：仍在拆解原文，结构可能变化。
- `needs_review`：静态抽取完成，但有 open question 或人工复核未完成。
- `ready`：静态验收全部通过，可接生成器。
- `planned`：scenario 已记录但执行器能力尚未实现。
- `deprecated`：只为兼容保留，不再作为新事实源。

存在 open question 不会阻止整个因子包保存，但相关值、规则或 scenario 不得标记 ready。

## 8. 抽取检查清单

- [ ] 语法格式的每个分支都有 syntax 表达。
- [ ] 原文已切成 source unit，且每个单元都明确标为 mapped、open_question、out_of_scope 或 unmapped。
- [ ] 每个 source unit 已完成 atomic/grouped 原子性复核，grouped 的独立主张数有对应 fact 映射。
- [ ] `out_of_scope` 和 `unmapped` 都有可审核的 rationale；ready 前不存在 unmapped。
- [ ] 每条非 inferred fact 都能反查到原文单元、锚点和行号。
- [ ] 每个参数说明至少有一个 fact 或明确标记不进入测试。
- [ ] 维度值都有稳定 ID、render、等价类和 validity。
- [ ] 通用规则只在 factor 中维护一次。
- [ ] 结构推导进入 structural_checks，没有伪装成 confirmed 硬规则。
- [ ] 查询、表形态等复杂对象使用 matrix / fixture。
- [ ] 示例没有被无证据地提升为通用规则。
- [ ] 权限、会话、GUC、生命周期被拆到 scenario。
- [ ] 所有歧义进入 open_question。
- [ ] 文档枚举项没有因缺少代表 SQL 而被静默遗漏。
- [ ] manifest 按目的拆分，不追求一次覆盖所有行为。
- [ ] 静态 lint、引用检查和 Pairwise 覆盖验证通过。
- [ ] 因子级全局审计分别报告原文、生成模型、静态和行为覆盖结论。
