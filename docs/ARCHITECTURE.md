# 当前系统架构

状态：Factor Package V1 是新规格的唯一写入格式；Legacy V0 仅为现有页面和旧用例提供兼容。

## 1. 当前目标

当前系统解决的是静态生成可信度：把一个产品文档章节转成可追溯规格，证明原文被逐项处置、规格引用闭合、约束可解析、所有可行 Pair 被覆盖，并生成稳定 SQL 快照。

当前不宣称完成真实数据库行为闭环。V1 fixture/scenario 的执行、真实 SQLSTATE 校准、权限和多会话生命周期验证仍属于后续阶段。

## 2. 数据流

```text
UTF-8产品文档章节
  │
  ├─ source path / SHA-256 / line count
  ▼
manage_extraction_queue.py
  │ pending → in_progress → generated → static_complete/needs_review
  ▼
AI任务文件
  │ 一次只允许处理一个章节和一个 OUTPUT_DIR
  ▼
Factor Package V1
  │
  ├─ source ledger：每个原文单元的去向
  ├─ factor：事实、维度、规则、结构契约和引用
  ├─ syntax：递归AST
  ├─ matrix：能力Profile
  ├─ fixture：setup/provides/teardown
  ├─ manifest：选择值、覆盖策略、目标Oracle
  └─ scenario：多步骤行为和元数据断言
  │
  ▼
FactorPackageRegistry
  │ 严格Schema、全局ID、引用、值域和约束校验
  ├─────────────────────┐
  ▼                     ▼
FactorPackageSQLGenerator  FactorCoverageAuditor
  │                     │
  ├─结构契约过滤          ├─source unit/行/原子性
  ├─约束感知可行域        ├─fact溯源与消费
  ├─Pairwise选择与补缺    ├─有效值与规则正负证据
  ├─case ID唯一性         ├─Pairwise与重复项
  └─SQL基础结构校验       └─feature/scenario结论
  │                     │
  └──────────┬──────────┘
             ▼
确定性SQL快照、JSON报告和Web/API展示
```

## 3. Factor Package 职责

| 文件类型 | 只负责 | 不负责 |
|---|---|---|
| `source_ledger` | 原文行和原子事实如何处置 | SQL结构和组合选择 |
| `factor` | 产品事实、维度、值域、规则、结构契约、引用索引 | 具体测试批次选择 |
| `syntax` | SQL产生式和递归AST | 重复维护产品值域和能力矩阵 |
| `matrix` | 表、查询、键、输入等复杂能力Profile | 决定本批次选择哪些Profile |
| `fixture` | setup、provides、teardown和对象契约 | 多会话状态迁移 |
| `manifest` | 本批次绑定、策略、预期和目标负向规则 | 产品事实的唯一来源 |
| `scenario` | 生命周期、权限、行为和元数据的步骤与断言 | 单条SQL的Pairwise生成 |

详细字段以 [Factor Package Schema V1](FACTOR_PACKAGE_SCHEMA_V1.md) 为准。

## 4. 核心模块

### V1模型与注册表

- `core/factor_package_model.py`：所有 V1 Pydantic模型、严格加载和引用校验。
- `FactorPackageRegistry`：扫描 `specs/`，建立全局 ID注册表并解析跨文件引用。

### 生成器

- `core/factor_package_generator.py`：解析 manifest、构建参数空间、应用规则和结构契约、展开AST并生成 case。
- `core/combinator.py`：组合选择算法。
- `core/constraint_solver.py`：受限约束DSL；解析失败必须报错，不能静默放行。

V1 Pairwise 流程：

```text
参数值域
  → 枚举或增量构造候选
  → 产品规则和结构契约过滤
  → 计算可行 Pair 集合
  → 贪心选择测试组合
  → 补齐缺失 Pair
  → 硬后置条件验证100%覆盖
```

所谓“理论 Pair”只包括至少出现在一个合法完整组合中的参数对，非法组合不会被算作覆盖目标。

### 覆盖审计

- `core/factor_coverage_auditor.py`：汇总原文、事实、值、规则、manifest、feature 和 scenario。

报告分别输出：

- `source_extraction_complete`：原文行、unit、fact账本和原子性是否闭合；
- `generation_model_complete`：值域、规则证据、生成异常、重复项和Pairwise是否闭合；
- `static_coverage_complete`：在前两项基础上，feature和confirmed fact消费是否闭合；
- `behavior_coverage_complete`：在静态闭合基础上，没有planned scenario、缺失行为fact和未决问题。

不能把其中任意一项简写成“文档已全覆盖”。

### 离线队列

- `scripts/manage_extraction_queue.py`：只管理本地文件，不调用任何 AI API。
- `prompts/factor_package_v1_extraction.md`：任何内网 AI 共用的单任务契约。

任务信封把 `factor_id`、原文SHA-256、行数和输出目录固定下来。verify 首先核对生成 package 是否对应同一份原文，防止旧规格冒充新结果。

### Web/API

- `main.py` 和 `web/`：同时展示 Legacy V0 与 Factor Package V1。
- V1页面使用注册表、生成器和覆盖审计器，不依赖数据库即可浏览和生成SQL。

### Legacy V0

- `core/spec_model.py`、`core/spec_generator.py`、`grammars/`、`matrices/`、`manifests/`：旧三文件规格运行时。
- `core/factor_model.py`、`core/registry.py`、`factors/`：更早的单文件因子运行时。

这些代码当前不能直接删除，因为 Web/API 和兼容测试仍在使用。新产品事实不得继续写入 V0。

## 5. 静态门禁

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py --factor <factor_id>
python3 scripts/audit_factor_coverage_v1.py --factor <factor_id> --fail-on-gaps
```

内网队列的 `verify` 还会在以上三项之前校验任务信封：

```bash
python3 scripts/manage_extraction_queue.py verify --task-id <task_id>
```

## 6. 当前边界

已经实现：

- V1严格加载、递归AST、结构契约；
- 约束感知Pairwise和覆盖后置验证；
- Fixture SQL静态生成；
- 目标错误Oracle数据模型；
- Source Unit原子性审计；
- 确定性SQL快照和Web/API；
- AI无关的内网任务队列。

尚未实现或尚未闭环：

- V1 fixture/scenario真实数据库执行；
- 目标SQLSTATE在具体版本上的校准；
- 多会话权限、事务和对象生命周期执行；
- GUC、函数、操作符、系统目录等非SQL命令的专用抽取Schema；
- 5800页文档全量任务目录和完整抽取。
