# GaussDB 测试因子系统架构概览 (Next-Gen Architecture)

> 规格驱动的 GaussDB 自动化测试系统：从产品文档到高质量测试用例与执行闭环。

---

## 一、 系统全景架构与数据流

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                   GaussDB 产品文档 (SQL 参考手册 / 约束限制 / 引擎特性)                   │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ (Doc2Spec 抽取工具链)
        ┌───────────────────────────────────┼───────────────────────────────────┐
        ▼                                   ▼                                   ▼
【语法规范 (grammars/)】            【全局语义矩阵 (matrices/)】         【测试清单 (manifests/)】
• BNF 产生式与 AST 插槽             • 数据类型等价类池                  • 针对特性的参数空间绑定
• 子语法与 element_list 列表展开    • 存储引擎/表形态兼容矩阵           • 组合策略 (Pairwise / 3-way)
• 符号行为 (creates / consumes)     • CSP 互斥规则 & 错误码集合         • 场景级附加约束规则
        │                                   │                                   │
        └───────────────────────────────────┼───────────────────────────────────┘
                                            │
                                            ▼
                               ┌─────────────────────────┐
                               │ SpecRegistry 规格注册表  │
                               │ SpecLinter 静态完整性检查│
                               └────────────┬────────────┘
                                            │
        ┌───────────────────────────────────┼───────────────────────────────────┐
        ▼                                   ▼                                   ▼
【CSP 约束求解器】                  【AST 插槽生成引擎】                【动态符号表与场景流水线】
• ConstraintSolver 规则求值         • SpecSQLGenerator 递归展开         • SchemaContext 对象状态管理
• 前置可行域剪枝                    • 自动推导 expected & SQLSTATE      • ScenarioEngine 时序状态机
• 过滤非法搜索空间                  • DataSeeder 测试数据合成发生器     • 动态表/列符号消费与绑定
        │                                   │                                   │
        └───────────────────────────────────┼───────────────────────────────────┘
                                            │
                                            ▼
                               ┌─────────────────────────┐
                               │  List[GeneratedCase]    │
                               │  (SQL + 预期错误码集合)  │
                               └────────────┬────────────┘
                                            │
        ┌───────────────────────────────────┼───────────────────────────────────┐
        ▼                                   ▼                                   ▼
【Schema 沙箱执行器 (Executor)】    【TLP 蜕变测试 Oracle】             【测试报告与 Web UI】
• 动态临时 Schema 隔离              • TLP 三值逻辑分区派生              • HTML / JSON 丰富测试报告
• 执行完毕自动 DROP CASCADE 清理    • 完备性与谓词真值数学断言          • Web 场景流水线可视化看板
• 杜绝 DDL 隐式提交污染测试库       • 验证查询优化器计算正确性          • 数据库连接管理与连通性测试
```

---

## 二、 核心模块职责划分

### 1. 规格定义与生成层
* **`core/spec_model.py`**：定义三类解耦规格文件的 Pydantic 数据模型契约（`SyntaxDef`, `MatrixDef`, `ManifestDef`）及扫描注册表 `SpecRegistry`。
* **`core/spec_generator.py`**：下一代文法编译与生成引擎。消费测试清单，展开 AST 插槽与 `element_list` 多列列表，自动推导负向用例的 `expected: error` 与 `expected_sqlstates`。
* **`core/spec_linter.py`**：规格静态校验器。在测试生成前检查语法插槽闭合性、矩阵引用完整性与 CSP 约束语法。
* **`core/data_seeder.py`**：类型感知的数据发生器。为 `SchemaContext` 中的表自动填充涵盖极值、0、空串、特殊字符与 NULL 的高质量测试数据。

### 2. 状态机与符号拓扑层
* **`core/symbol_table.py`**：定义 `ColumnSymbol`, `TableSymbol`, `IndexSymbol` 与核心容器 `SchemaContext`。提供类型分类推断与智能符号推荐器（`pick_table`, `pick_column`, `pick_compatible_columns`），并内置 DDL 状态推进器（`apply_sql_effect_to_context`）。
* **`core/scenario.py`**：业务场景流水线引擎（`ScenarioEngine`）。编排多因子时序执行，驱动 `[建表] -> [插数据] -> [查数据] -> [结构变更]` 全生命周期状态迁移。

### 3. 组合算法与约束求解层
* **`core/combinator.py`**：纯算法模块，提供等价类笛卡尔积、IPOG 两两覆盖（Pairwise）与全笛卡尔积。
* **`core/constraint_solver.py`**：CSP 约束满足求解器。解析并执行一阶逻辑蕴含规则（`P => Q`），在前置阶段裁剪非法组合空间。

### 4. Oracle 断言与执行层
* **`core/oracle.py`**：TLP（三值逻辑分区）蜕变测试 Oracle。自动将带有 WHERE 过滤的查询派生为 4 条三值聚合查询，并在真库执行时验证数学等式不变性，全自动校验 GaussDB 查询优化器的计算正确性。
* **`core/executor.py`**：具备 **Schema 级临时沙箱隔离** 能力的 GaussDB 执行器。支持环境变量自动加载配置、多 SQLSTATE 候选集合容错匹配、连接存活检查与 Core Dump 崩溃捕获。
* **`core/reporter.py`**：生成包含预期错误码集合、捕获 SQLSTATE 与判定结论的 Tailwind HTML / JSON 报告。

### 5. Web UI 与交互层
* **`main.py` & `web/`**：FastAPI Web 服务。支持因子浏览、单因子用例生成、全生命周期场景流水线可视化执行、以及 GaussDB 数据库连接配置与连通性测试。

---

## 三、 三类标准规格文件与目录结构

```
gaussdb_test/
├── grammars/              # 语法规范定义 (*.syntax.yaml)
│   ├── ddl/               # DDL 语法 (CREATE TABLE, ALTER TABLE, CREATE INDEX 等)
│   ├── dml/               # DML 语法 (INSERT, SELECT, UPDATE, DELETE 等)
│   └── tcl/               # TCL 语法 (TRANSACTION, SAVEPOINT 等)
├── matrices/              # 全局语义兼容矩阵 (*.matrix.yaml)
│   └── gaussdb_core.matrix.yaml  # 全局数据类型池 + 存储引擎兼容规则
├── manifests/             # 组合测试清单 (*.manifest.yaml)
│   ├── ddl/               # DDL 组合测试清单
│   └── dml/               # DML / TLP 蜕变测试清单
├── factors/               # 兼容旧版单一因子 YAML 目录
├── core/                  # 核心测试引擎与算法
├── web/                   # Web 页面与模板
├── tests/                 # 自动化单元测试套件
└── reports/               # 生成的 HTML/JSON 测试报告
```

---

## 四、 向后兼容机制

* 系统对旧版 `factors/*.yaml` 保持 **100% 向后兼容**。
* 旧版单文件因子与新版三层解耦规格可并存运行，统一由 `core/executor.py` 在沙箱中执行并生成标准测试报告。
