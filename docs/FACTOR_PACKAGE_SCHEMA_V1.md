# Factor Package Schema V1

状态：已定稿；严格加载器、有限展开的结构化 AST 静态生成器、Fixture 静态生命周期模型、目标错误 Oracle 数据模型和 Web/API 已接入。V1 fixture/scenario 的真实数据库执行仍不在当前范围。

## 1. 目标

Factor Package 是一条 SQL 语句在测试系统中的完整静态规格。它把产品文档中的事实、SQL 文法、测试选值、对象能力和多步骤行为分开保存，同时用稳定 ID 建立引用。

V1 解决三个问题：

1. 同一条规则不再同时维护在 factor、syntax、matrix 和 manifest 中。
2. 文档原文、推导规则和待验证问题可以区分，不把猜测伪装成事实。
3. SQL 生成前可以静态验证引用、值域、约束和覆盖目标，不依赖数据库。

## 2. 最终目录

```text
specs/
  README.md
  ddl/
    create_view/
      create_view.factor.yaml
      create_view.source.yaml
      create_view.syntax.yaml
      manifests/
        basic_positive.manifest.yaml
        options_positive.manifest.yaml
        non_updatable_negative.manifest.yaml
      matrices/
        query_capabilities.matrix.yaml
      fixtures/
        source_two_ints.fixture.yaml
      scenarios/
        *.scenario.yaml
  shared/
    fixtures/
    matrices/
```

一个 SQL 语句对应一个目录，称为一个 factor package。文件后缀决定文件类型，不依赖所在目录猜测类型。

每个可生成 SQL 的因子包必须包含一个 `*.factor.yaml`、一个 `*.source.yaml`、一个 `*.syntax.yaml` 和至少一个 `*.manifest.yaml`。matrix、fixture、scenario 按文档事实和测试目的增加，不为凑目录而创建。换言之，原来的 grammar 和 manifest 没有消失，而是被收进对应因子包并收窄了职责。

## 3. 公共字段

所有 YAML 顶层都必须包含：

```yaml
schema_version: 1
kind: factor | source_ledger | syntax | manifest | matrix | fixture | scenario
id: 全局唯一且稳定的标识符
```

建议同时包含：

```yaml
name: 人类可读名称
status: draft | needs_review | ready | planned | deprecated
description: 简短说明
```

加载器必须启用严格模式：未知字段、重复 ID、缺失引用、非法枚举和无法解析的规则均应报错，不得静默忽略。

## 4. factor：产品事实与测试模型

`*.factor.yaml` 是因子包的规范化索引，不是产品事实的原始来源。产品事实的唯一权威证据是 catalog 固定的本地 PDF 章节；factor 只负责把该证据派生为事实、测试维度和值域，任何内容都必须能回溯到 source ledger 与 PDF 哈希。

### 4.1 必要结构

```yaml
schema_version: 1
kind: factor
id: create_view
name: CREATE VIEW
category: DDL
status: needs_review

source:
  product: GaussDB
  document: GaussDB Kernel 参考
  version: V2.0-10.0.0
  artifact_sha256: 稳定章节文本的 SHA-256
  parent_pdf_sha256: 父 PDF 的 SHA-256
  extraction_rule_version: gaussdb-pdf-outline-v1
  extraction_date: YYYY-MM-DD
  catalog_chapter_ref:
    document_id: gaussdb-kernel-reference-v2.0-10.0.0-doc01
    source_relpath: general/ddl/create_view.txt
    chapter_sha256: 与 artifact_sha256 相同

source_ledger_ref: source_ledger_create_view
syntax_ref: syntax_create_view
dimension_refs: []
dimensions: {}
rules: []
structural_checks: []
facts: []
exported_fact_refs: []
manifest_refs: []
matrix_refs: []
fixture_refs: []
scenario_refs: []
```

`source.version` 未知时必须写 `unknown`，禁止从相邻文档或文件名猜测。若来源由 PDF catalog 管理，`parent_pdf_sha256`、`extraction_rule_version` 与 `catalog_chapter_ref` 必须存在并和任务信封一致；完整书签路径和精确页内边界仍通过 catalog 解析。章节哈希、父 PDF 哈希和抽取规则版本分别绑定“内容、容器、算法”，任一变化都使旧静态结论失效。

跨包事实引用使用 `factor_id::fact_id`，例如
`create_view::cv_fact_key_preserved_definition`。被引用事实必须由来源 factor 的
`exported_fact_refs` 显式导出且状态为 `confirmed`；未导出的内部事实不能形成隐式
耦合。本地引用继续使用原有 `fact_id`，旧 V1 包无需迁移。Registry 会校验目标
factor、fact、消费者要求的事实类型，并由限定引用自动生成因子依赖图、检测环。
引用外章已确认定义不能自动关闭本章的行为 open question。

### 4.2 dimension、class 与 value

维度表示一个可以独立变化的测试因素。每个维度由等价类和稳定值 ID 组成：

```yaml
dimensions:
  temp_modifier:
    description: 临时视图修饰符
    default_value_id: temp_absent  # manifest 省略该维度时采用的显式单值
    classes:
      - id: temp_class_permanent
        meaning: 不显式创建临时视图
        values:
          - id: temp_absent
            render: ""
            representative: true
            validity: valid
      - id: temp_class_explicit
        meaning: 显式创建临时视图
        values:
          - id: temp_keyword
            render: TEMP
            representative: true
            validity: valid
          - id: temporary_keyword
            render: TEMPORARY
            representative: false
            validity: valid
```

规则：

- manifest 选择 `value.id`，不重复写 SQL 字符串。
- `render` 是渲染文本，不作为身份标识。
- `representative` 表示等价类的默认代表值，不代表其他值永远不测。
- `validity` 取 `valid`、`invalid`、`conditional`、`unknown`。
- profile 类复杂值使用 `profile_ref` 指向 matrix，而不是把整段能力表复制进 factor。
- `default_value_id` 用于 AST 非活动分支或清单不关注的单值维度；它必须指向本维度的已定义值。省略 binding 只表示固定为该默认值，不表示从覆盖空间删除该维度。

### 4.3 facts

每条文档事实必须有稳定 ID、事实类型、状态和原文定位：

```yaml
facts:
  - id: cv_fact_temp_dependency
    type: lifecycle
    statement: 引用任一临时表时，视图即使没有 TEMP 关键字也会成为临时视图。
    status: confirmed
    source_anchor: 参数说明/TEMP | TEMPORARY
```

允许的事实类型：

- `syntax`：关键字、顺序、可选性和语法分支。
- `constraint`：合法、非法或条件合法的组合。
- `environment`：权限、兼容模式、事务、GUC、版本、部署形态。
- `lifecycle`：对象创建、失效、重编译、会话结束等状态变化。
- `behavior_oracle`：操作应成功、应失败、返回值或目录字段应为何值。
- `metadata_oracle`：系统表或 information_schema 的可验证状态。
- `example`：文档示例，只作证据，不自动提升为通用规则。
- `open_question`：文档不足、冲突或实现相关，必须验证后才能转为规则。

`status` 取 `confirmed`、`inferred`、`needs_verification`、`rejected`。只有 `confirmed` 可以直接形成硬约束；`inferred` 必须写推导依据；`needs_verification` 不得过滤组合。

### 4.4 rules

规则引用稳定维度值或 matrix 属性：

```yaml
rules:
  - id: cv_rule_check_requires_updatable
    kind: requires
    expression: >-
      post_query_option in ['check_default', 'check_cascaded', 'check_local']
      => query_profile.properties.updatable == True
    fact_refs: [cv_fact_check_updatable_only]
    severity: error
```

每条规则必须能编译、能解释、能追溯。规则语言不得直接执行 Python `eval`。编译失败必须阻止规格加载。

### 4.5 structural_checks

`structural_checks` 保存生成器必须执行、但不应伪装成产品硬规则的结构契约。它可以引用 `inferred` fact，例如“显式视图列名数量与查询输出列数一致”。结构检查参与可行组合判定，但不改变产品事实：不满足结构契约的组合不能成为理论可行 Pair，也不能生成 SQL。

```yaml
structural_checks:
  - id: cv_struct_column_count_matches_query
    kind: column_count_matches_query
    fact_refs: [cv_fact_column_names, cv_inferred_column_count_matches_query]
```

SELECT 类结构可使用 `select_expression_contract`。相关 dimension value 在 `properties` 中声明：查询源可见列及类型、投影引用列、输出列及类型、非聚集列、GROUP BY 列、ORDER BY 列、集合运算两侧输出类型。生成器据此拒绝不存在的列、分组列遗漏、不可见排序列、集合列数/类型不兼容以及锁定子句与 DISTINCT/聚集/集合运算的冲突。

INSERT 类结构可使用 `insert_input_contract`。`target_profile` 声明显式目标列数/类型或隐式目标的可用列数/类型，`source_profile` 声明输入形态、输出列数/类型和有限行列表。生成器在 Pairwise 目标计算前过滤列数或类型不兼容的组合，并验证需要 CTE 的输入确实由 WITH 分支提供；`DEFAULT VALUES` 不参与输入列数匹配。

任意 profile 引用多张源表时，不能只给一份扁平的 `source_columns`。必须用
`properties.source_columns_by_table` 把每个引用列精确归属到对应表；生成器按表
核对 fixture 契约，禁止“另一张表恰好有同名列”掩盖当前表缺列。单表 profile
可以继续使用 `source_columns`。

CREATE INDEX 类结构可使用 `index_column_count_contract`。`key_profile` 声明有限键项、键列数和引用列，`include_profile` 声明非键列和数量，`table_profile`/`scope_clause` 声明普通、分区和 GLOBAL 形态。生成器拒绝空键列表、声明列数与 AST 项数不一致、INCLUDE 与键列重叠，以及超过本版 PDF 明示的 GLOBAL 31、其他索引 32 个键列的组合。INCLUDE 是非键列；没有独立来源时不得把它并入该键列上限，也不得沿用其他版本的在线 28/29 限制。

## 5. source ledger：原文单元覆盖账本

`*.source.yaml` 回答“产品原文的每个可独立判断单元被怎样处置”。它记录事实的来源，不取代 factor 中的事实，也不算事实的下游测试消费者。

```yaml
schema_version: 1
kind: source_ledger
id: source_ledger_create_view
factor_ref: create_view
artifact_sha256: 与 factor.source.artifact_sha256 完全一致
source_line_count: 71
ignored_lines:
  - line: 2
    rationale: 章节标题，语义由其下 source units 承载。
supplemental_sources:
  - id: gaussdb_select_same_pdf
    document: GaussDB Kernel 参考
    version: V2.0-10.0.0
    catalog_chapter_ref:
      document_id: gaussdb-kernel-reference-v2.0-10.0.0-doc01
      source_relpath: general/dml/select.txt
      chapter_sha256: 对应章节文本的 SHA-256
    source_anchor: 被当前章节明确引用的 SELECT 子语法
units:
  - id: cv_su_temp_dependency
    section: 参数说明
    source_anchor: TEMP | TEMPORARY
    line_start: 18
    line_end: 18
    statement: 引用临时表时视图自动成为临时视图。
    status: mapped
    fact_refs: [cv_fact_temp_dependency]
    supplemental_source_refs: []
    atomicity: atomic
    independent_claim_count: 1
  - id: cv_su_join_view_definition
    section: 可更新视图
    source_anchor: 连接视图
    line_start: 52
    line_end: 52
    statement: 文档定义了连接视图。
    status: unmapped
    rationale: 尚未建立连接视图 query profile 与行为场景。
```

主来源来自 PDF catalog 时，factor 的 `catalog_chapter_ref`、账本的 `artifact_sha256` 和任务信封必须指向同一个稳定章节。补充来源必须且只能选择远程 `url` 或同一 catalog 中的 `catalog_chapter_ref`；不得使用旧网页补全当前 PDF 中已改变或缺失的事实。

原文单元状态只有四种：

- `mapped`：已映射到至少一个 fact。
- `open_question`：原文有歧义，映射到 `needs_verification` 的 open-question fact。
- `out_of_scope`：经过明确判断不属于该语句因子，必须写原因。
- `unmapped`：属于当前因子但尚未建模，必须写缺口原因。

账本必须满足：1 到 `source_line_count` 的每一行都被至少一个 unit 覆盖，或以 `ignored_lines` 明确登记标题/空行及理由；行号范围有效；`mapped`/`open_question` 必须引用 fact；`out_of_scope`/`unmapped` 不得伪造 fact 引用且必须有 rationale；所有非 inferred fact 至少被一个 source unit 引用；账本和 factor 的原文哈希必须一致。原文引用但未展开的外部章节只能通过 `supplemental_sources` 补证据，source unit 必须显式引用其稳定 ID。`ready` 因子不得包含 `unmapped` source unit。

每个 unit 还要接受原子性审计：`atomic` 表示只承载一个可独立判断的主张；`grouped` 必须声明至少为 2 的 `independent_claim_count`，且需要足够的 fact 映射；`unreviewed` 只是迁移状态，任意一个未复核 unit 都会形成审计缺口，不以行数阈值放行。审计器还会拒绝跨度异常的伪原子 unit，以及独立主张数多于 fact 映射数的 grouped unit。行覆盖 100% 但原子性有缺口时，`source_extraction_complete` 必须为 false。

## 6. syntax：SQL 结构

`*.syntax.yaml` 只回答“SQL 怎么拼”。简单语句可使用线性 `production`；SELECT 等递归语句使用 `ast + subgrammars`。两者必须且只能选择一种，不保存测试候选值。

```yaml
schema_version: 1
kind: syntax
id: syntax_create_view
factor_ref: create_view
production: >-
  CREATE {or_replace} {temp_modifier} {force_modifier} VIEW {view_name}
  {column_list} {view_options} AS {query_profile} {post_query_option}
slots:
  or_replace:
    type: token
    optional: true
    dimension_ref: create_view.or_replace
  view_name:
    type: identifier
    symbol_action: creates_view
  query_profile:
    type: sql_fragment
    dimension_ref: create_view.query_profile
```

AST 节点是递归模型，支持：

- `literal`：固定文本。
- `slot`：渲染一个 dimension value。
- `sequence`：按顺序渲染子节点。
- `choice`：根据 selector value 选择互斥顶层或子产生式。
- `optional`：只对声明的 selector values 渲染子节点。
- `repeat`：从 value 的 `properties.items` 读取有限列表并按 separator 渲染。
- `ref`：引用命名 subgrammar；加载器检查悬空引用，渲染器检测无终止循环。

```yaml
ast:
  kind: choice
  selector: statement_form
  branches:
    select_statement_ast: {kind: ref, ref: select_statement}
    select_statement_table: {kind: ref, ref: table_statement}
subgrammars:
  select_statement:
    kind: sequence
    items:
      - {kind: literal, text: "SELECT "}
      - {kind: repeat, slot: target_list, separator: ", ", items_property: items}
      - {kind: ref, ref: from_source}
```

AST 类型定义本身递归，实际一次渲染必须是有限展开。嵌套 SELECT 通过命名 `nested_select` subgrammar 组合；不允许没有终止条件的循环 ref。

禁止事项：

- 不在 syntax 的 slot 中维护 `values`。
- 不在 syntax 中维护 Pairwise、测试优先级或 expected。
- 不把对象准备 SQL 写进 syntax。

## 7. manifest：一次测试选择

`*.manifest.yaml` 只回答“这一次选择哪些值、用什么覆盖策略、预期属于什么测试类型”。

```yaml
schema_version: 1
kind: manifest
id: manifest_create_view_basic_positive
factor_ref: create_view
syntax_ref: syntax_create_view
suite_type: positive
strategy: pairwise
fixture_refs: [fixture_create_view_source_two_ints]
environment_requirements:
  - key: compatibility_mode
    allowed_values: [PG]
    fact_refs: [cv_fact_example_environment]
identifier_policy:
  view_name:
    generator: deterministic
    prefix: v_cv_basic
    schema_prefix: public  # 可选；用于模式修饰名称
    unique_per_case: true
bindings:
  temp_modifier: [temp_absent, temp_keyword, temporary_keyword]
  query_profile: [query_simple_two_columns, query_filtered_two_columns]
expected:
  default: success
  scope: syntax_and_semantics
```

`environment_requirements` 是可执行门禁，不是备注。每一项必须引用本地或其他包
显式导出的 `status: confirmed`、`type: environment` fact；执行器只有在环境能力的键和值均匹配时
才运行用例，否则结果为 `skip` 并记录缺失条件。可通过
`GAUSSDB_ENVIRONMENT_JSON` 统一传入能力映射，或用
`GAUSSDB_COMPATIBILITY_MODE`、`GAUSSDB_B_FORMAT_VERSION`、
`GAUSSDB_B_FORMAT_DEV_VERSION` 传入当前已支持的三个键。环境不匹配导致的错误
绝不能满足负向用例的目标 Oracle。

manifest 可以省略具有 `default_value_id` 的维度；生成器会补成单值域。没有默认值的维度仍必须显式 binding。Pairwise 的“适用”只按至少两个真正有多个候选值的交互维度判断，固定默认值不会伪装成子句交互覆盖。

`prefix` 与可选的 `schema_prefix` 只接受安全的未引用标识符片段；对象名哈希同时包含 manifest ID 和参数组合，因此不同 manifest 即使复用前缀，也不会因相同组合产生同名对象。标识符长度、引用标识符和 Unicode 边界应在对应产品章节补齐后另建 profile，不能由通用生成器猜测。

约束规则不在 manifest 中重复维护。manifest 如需缩小域，只选择 value ID；如确需声明该测试特有规则，使用 `local_rules` 并说明它为何不是产品通用规则。

负向 manifest 使用 `violates_rule_refs` 声明“有意违反”的 confirmed 规则。生成器计算该清单的候选与覆盖目标时，仅对这些规则切换为“必须违反”，其他通用规则仍必须满足；否则负向组合会先被普通可行性过滤掉，永远无法生成。

负向 expected 还必须声明目标错误 Oracle：稳定时设置 `oracle_status: confirmed`（默认），优先给出 `sqlstates`；没有 SQLSTATE 时给出 `error_category` 与足够窄的 `error_message_regex`，并用 `fact_refs` 引用当前因子的 confirmed `behavior_oracle` 事实。`.*`、`.+` 等可匹配任意错误的正则会被严格加载器拒绝。若 PDF 只确认“应失败”而没有给出可识别的错误身份，必须设置 `oracle_status: needs_verification`、保留 `error_category`，且不得伪造 SQLSTATE 或正则；这种 manifest 必须保持 `needs_review`，执行结果只能是 `pending`，不能计为通过。fixture 报错、清理报错、任意其他数据库错误均为失败。

`scope` 也是执行判定的一部分：仅 `syntax_and_semantics` 的单语句执行结果可以直接判 pass/fail；`syntax_only`、`behavior`、`metadata` 必须由专用场景或 Oracle 收口，裸执行结果保持 `pending`。

Pairwise 覆盖所有经过规则过滤后仍可行的二元值对。因此 V1 不提供含义模糊的 `high_priority_dimensions`，当前只接受 `strength: 2` 和 `require_all_feasible_pairs: true`。三维交互属于后续生成器能力，不能只在 YAML 中写 `strength: 3` 假装已经支持。

## 8. matrix：复杂能力剖面

`*.matrix.yaml` 保存可复用、具有多个属性的能力对象，例如查询形态、表类型或索引方法。它不保存 SQL 主产生式，也不决定本次选择哪些 profile。

```yaml
profile_property_defaults:
  environment_ready: true
profiles:
  - id: query_distinct
    render: SELECT DISTINCT col_1, col_2 FROM t_view_source
    validity: valid
    properties:
      output_column_count: 2
      updatable: false
      features: [distinct]
```

`profile_property_defaults` 用于声明同一 matrix 中所有 profile 共享、且规则会读取的显式默认属性；profile 自身的 `properties` 可以覆盖默认值。这样既避免在大量 profile 中复制布尔属性，也不会把缺失变量静默当成通过。

通用能力覆盖台账使用 `documented_features`：

```yaml
documented_features:
  - id: recursive_cte
    profile_refs: [query_recursive_cte]
    status: covered
    coverage_mode: all
    fact_refs: [select_fact_cte]
  - id: xmltable
    profile_refs: []
    status: needs_profile
    fact_refs: [select_open_xmltable_example]
```

当 feature 由 AST dimension value 而不是 matrix profile 覆盖时，使用 `value_refs`。例如 TABLE 顶层产生式由 `select_statement_table` 覆盖。`covered` 必须至少引用一个 `profile_refs` 或 `value_refs`，且该值必须实际进入生成用例。

`coverage_mode` 明确“命中一个代表值”和“值域完整”的区别：`all`（默认）要求列出的全部引用均实际进入 SQL；`any` 仅适用于经人工证明彼此等价、任一代表即可覆盖的引用；`representative` 只表示已有样例，永远不能关闭静态全域覆盖缺口。审计同时输出 required、selected、missing refs，禁止把“任意一个引用被选中”简写成 feature 全覆盖。文档已列举但尚未写入 `profile_refs/value_refs` 的变体，必须单列 feature 或使用 `needs_profile + open_question`，不能靠缩小分母获得 100%。

`documented_non_updatable_features` 仅为既有 CREATE VIEW 包保留的兼容字段；新因子应使用 `documented_features`。

当一条语句包含递归、重复或高度耦合的子文法，而当前线性 production 无法保证片段组合内部一致时，可以暂时把完整语句保存为一个 matrix profile。此时审计必须标记 `pairwise_applicable=false`：`0/0` pair 只代表单维 profile 枚举，不代表子句交互覆盖。需要真正的子句 Pairwise 时，应先增加可组合的子文法/AST 能力，再拆分维度。

每个 profile 必须显式声明 `validity`。如果属性未知，写 `unknown`；不得用 `false` 代替未知。`expected: success` 的正向 manifest 只能绑定 `validity: valid` 的 dimension value 和 matrix profile；`unknown`、`conditional`、`invalid` 必须先进入待验证流程或有目标规则的负向清单。

文档枚举了一组能力或限制时，matrix 必须同时记录“已覆盖 representative”和“仍缺 representative 的显式缺口”，不能只保存已经写得出 SQL 的部分：

```yaml
documented_non_updatable_features:
  - id: distinct
    profile_refs: [query_distinct_two_columns]
    status: covered
    fact_refs: [cv_fact_non_updatable_features]
  - id: unpivot
    profile_refs: []
    status: needs_profile
    fact_refs: [cv_fact_non_updatable_features, cv_open_non_updatable_profile_syntax]
```

`needs_profile` 必须引用一个 `needs_verification` 的 open question，避免遗漏被隐藏成“以后再说”。

## 9. fixture：对象能力

`*.fixture.yaml` 声明测试所需的对象能力，而不是任意 setup SQL 的容器：

```yaml
provides:
  tables:
    - name: t_view_source
      persistence: permanent
      columns:
        - {name: col_1, type: INTEGER, nullable: true}
```

Fixture 还必须声明执行方式；依赖其他 Fixture 时显式引用，而不是复制 setup SQL：

```yaml
seed:
  required: true
  rows:
    - {col_1: 1, col_2: 2}
requires_fixture_refs: [fixture_shared_role]
execution:
  status: ready
  mode: auto
  note: 由编译器生成幂等生命周期 SQL。
```

`requires_fixture_refs` 会递归展开并做拓扑排序：依赖项先 setup、消费者后 setup，teardown 采用严格逆序；缺失引用和循环依赖在加载期失败。`auto` 为受支持的普通表、临时表和 Ustore 表生成幂等 DROP、CREATE、INSERT 与逆序 teardown；分区等特殊表形态使用 `explicit`，并必须同时提供 `setup_sqls` 和 `teardown_sqls`。`not_implemented` fixture 不能进入可生成清单。SQL 引用的表和列必须能由 fixture 解析；setup 失败记为 `fixture_error`，teardown 失败记为 `cleanup_error`，二者都不能满足负向用例。

队列会把限定 Fact 引用和跨包 Fixture 依赖同步为
`depends_on_factor_refs`，按拓扑顺序认领任务。验证快照记录直接及传递依赖的
章节 SHA-256 与 Factor Package SHA-256；上游发生变化时，只把依赖闭包内的
下游 `static_complete` 判为 stale。处于 `needs_review` 但已经产生有效包的上游
可以提供已确认事实，不要求所有上游先达到行为闭环。

若依赖章节在队列中，快照同时保存正文绝对路径并校验实际文件 SHA-256；即使尚未
运行 inventory，正文漂移也会使下游失效。跨批测试必须把依赖章节及正文纳入验证
批次。没有正文路径的旧快照或批次外包只能核对声明哈希与包哈希，不应据此声称
已检查磁盘正文。依赖失效粒度是章节/包，不是单个 Fact。父 PDF 或公共工具链
变化仍会使绑定它们的所有快照失效。

内部 queue 验证快照也保存本包及传递依赖包的 `supplemental_sources` 正文路径和
SHA-256。即使不刷新 inventory，补充正文变化或删除也必须失效；缺少该证据的旧
快照仅在包确实没有补充来源时仍可复用。URL-only 来源不能获得本地文件 freshness
证明。跨批 catalog 仍须显式纳入所有被引用正文，不会凭空定位外部材料。
补充正文的来源引用不等同于可拓扑执行的包依赖 DAG；失效传播可以覆盖两类引用的
消费者，但不据此声称已实现任意跨包语法复用。

## 10. scenario：状态变化与行为断言

`*.scenario.yaml` 描述多步骤流程，适用于单条 CREATE 不能验证的事实：

- `OR REPLACE`：先有对象，再替换并验证定义。
- `FORCE`：缺失依赖时创建无效视图，补对象、COMPILE 后变为有效。
- 临时视图：跨会话验证自动删除。
- `CHECK OPTION` / `READ ONLY`：创建后执行 DML 并验证错误。
- 依赖失效、权限、兼容模式等环境行为。

在执行能力未实现前，scenario 使用 `status: planned`，但仍须记录 `fact_refs`、前置条件、步骤和 oracle。只有包含结构化 `steps`/`variants` 以及至少一个带 `kind`、`expected` 的 Oracle 时，scenario 才能标记为 `ready`；`planned`、`draft`、`needs_review` 均不能计入行为闭环。

## 11. 单一事实源

| 信息 | 唯一维护位置 |
| --- | --- |
| 原文单元、行号和处置状态 | source ledger |
| 文档事实、等价类、通用规则 | factor |
| 非产品硬规则的生成结构契约 | factor.structural_checks |
| SQL 结构和槽位顺序 | syntax |
| 多属性能力 profile | matrix |
| 本次取值和覆盖策略 | manifest |
| 对象能力和种子数据 | fixture |
| 多步骤状态与行为断言 | scenario |

引用可以重复，事实正文和规则表达式不能复制维护。

source ledger 是“来源证据”，syntax、rule、value、matrix、fixture、manifest、scenario 是“下游消费者”。仅把 fact 写进 source ledger，不能证明该事实已经进入 SQL 生成或行为验证。

## 12. ID 规范

- factor：`create_view`
- source ledger：`source_ledger_create_view`
- source unit：`cv_su_<meaning>`
- syntax：`syntax_create_view`
- manifest：`manifest_create_view_<purpose>`
- matrix：`matrix_create_view_<capability>`
- fixture：`fixture_create_view_<capability>`
- scenario：`scenario_create_view_<behavior>`
- fact：`cv_fact_<meaning>`
- rule：`cv_rule_<meaning>`
- dimension value：在 factor 内稳定唯一，如 `check_cascaded`

重命名显示文本不得改变 ID。ID 一旦被报告、快照或外部工具引用，不得随意复用。

## 13. 因子级全局覆盖审计

因子是否完整不能由 SQL 数量或单个 manifest 的 Pairwise 报告推断。全局审计器同时检查四层：

1. 原文层：source unit 是否全部映射、进入 open question 或明确 out of scope。
2. 模型层：fact 是否有来源和下游消费者，有效 value 是否至少被一个 manifest 实际选中，硬规则是否同时有正向满足证据和目标负向违反证据。
3. 生成层：所有 manifest 是否生成成功、case ID/SQL 是否唯一、所有可行 Pair 是否 100% 覆盖、文档枚举 feature 是否有 profile/value 且实际进入用例、Fixture 生命周期与目标错误 Oracle 是否完整。
4. 行为层：需要生命周期、行为或元数据验证的 fact 是否进入 scenario，planned scenario 和 open question 是否已经解决。

命令：

```bash
python3 -B scripts/audit_factor_coverage_v1.py --factor create_view
python3 -B scripts/audit_factor_coverage_v1.py --factor create_view --fail-on-gaps
```

第一条用于日常查看并写入 `generated/factor_packages/<factor>/coverage_audit.json`；第二条用于严格 CI，只要静态覆盖尚不完整就返回非零。审计结论分开报告：`source_extraction_complete`、`generation_model_complete`、`static_coverage_complete`、`behavior_coverage_complete`，禁止把“生成器完整”简写成“文档全覆盖”。任何 `needs_verification` fact（包括 open question）都会阻断静态闭环；它可以保留在校准包中，但必须如实显示为未闭环。

## 14. 静态验收标准

一个 factor package 完成静态生成闭环必须满足：

1. 所有 YAML 可严格解析，未知字段为错误。
2. 所有顶层 ID、fact ID、rule ID 和 value ID 唯一。
3. 所有引用闭合，无悬空 syntax、fixture、matrix、scenario 或 value 引用。
4. syntax 的每个可变槽位都能解析到 factor 维度或明确的生成策略。
5. manifest 的每个 binding 都是 factor 中已定义的值 ID。
6. 每条硬规则至少引用一个 confirmed fact。
7. 每个 SQL 标识符和对象引用都能由标识符策略、fixture 或 scenario 提供。
8. 生成后 case ID 唯一，所有约束满足，可行 pair 覆盖率为 100%。
9. 任何推断和文档歧义保存在 open question 中，不进入硬过滤规则。
10. negative manifest 只能违反 `violates_rule_refs` 列出的规则，并且每个生成用例确实触发至少一条目标规则。
11. 每条 confirmed 非示例事实至少被与事实类型匹配的消费者使用，例如 syntax 事实进入 syntax/value，constraint 进入 rule/negative，lifecycle/behavior/metadata 进入 scenario 或 Oracle；任意引用不能冒充有效消费。
12. 文档枚举能力必须标成 `covered` 或 `needs_profile`，并声明真实覆盖模式；代表值覆盖不得冒充全域覆盖，`needs_profile` 必须引用 open question。
13. source ledger 的原文哈希与 factor 一致，所有 source unit 都有显式处置，且不存在 `unmapped` 或原子性审计缺口。
14. 因子级审计的原文抽取、生成模型和静态覆盖结论均为完整。

## 15. 与旧目录的边界

根目录下现有 `factors/`、`grammars/`、`matrices/`、`manifests/` 属于 Legacy V0，当前运行时为兼容仍会读取它们。自 V1 起，新的抽取只写入 `specs/<category>/<statement>/`。

V1 已由 `FactorPackageRegistry`、`FactorPackageSQLGenerator`、Fixture 编译器、目标错误 Oracle、静态审计和 Web/API 读取。执行器已能按 case 执行 setup/test/teardown，但本项目当前未连接目标 GaussDB，因此只完成生成层与执行契约的自动测试；planned scenario 状态机及真实数据库兼容性仍需后续验证。
