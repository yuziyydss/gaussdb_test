# GaussDB 测试因子系统开发路线图 (Roadmap)

---

## 路线图总览

```
[Phase 1: 原型与单因子] ────> [Phase 2: 架构加固与状态机] ────> [Phase 3: 三层规格解耦] ────> [Phase 4: 规模化与文档抽取]
      (已完成)                       (已完成)                      (已完成)                     (进行中)
```

---

## Phase 1: 原型与基础能力 (已完成)

- [x] 因子基础数据模型 (Pydantic)
- [x] 三种组合算法 (Equivalence / Pairwise IPOG / Full Cartesian)
- [x] 基础 SQL 模板渲染
- [x] YAML 加载器与桩执行模式
- [x] Web UI 基础交互 (FastAPI + HTMX + Tailwind)
- [x] HTML 与 JSON 格式测试报告生成

---

## Phase 2: 架构加固与状态机引擎 (已完成)

- [x] **Schema 临时沙箱隔离**：执行前后自动创建并级联删除独立 Schema，彻底根治 DDL 隐式提交污染测试库
- [x] **多 SQLSTATE 容错匹配**：支持 `expected_sqlstates` 集合判定，消除语法/语义多阶段错误码假阳性误报
- [x] **数据库动态符号表 (`SchemaContext`)**：
  - `ColumnSymbol`, `TableSymbol`, `IndexSymbol` 元数据模型
  - 智能类型推荐器 (`pick_table`, `pick_column`, `pick_compatible_columns`)
  - 快照与回滚机制 (`snapshot` / `restore`)
  - DDL 状态推进器 (`apply_sql_effect_to_context`)
- [x] **业务场景流水线 (`ScenarioEngine`)**：支持 `[建表] -> [插数据] -> [查数据] -> [加列]` 时序状态机执行
- [x] **Web UI 场景链与数据库配置看板**：
  - 场景流水线可视化看板与一键执行
  - GaussDB 实例连接配置弹窗与异步连通性测试

---

## Phase 3: 规格解耦与高级 Oracle 体系 (已完成)

- [x] **三层解耦规格体系**：
  - 语法规范层 (`grammars/*.syntax.yaml`)：BNF 产生式、AST 插槽定义、多列列表展开 (`element_list`)
  - 全局兼容矩阵层 (`matrices/*.matrix.yaml`)：全局数据类型池、存储引擎客观限制规则
  - 组合测试清单层 (`manifests/*.manifest.yaml`)：参数绑定空间、组合强度定义 (T-way)
- [x] **下一代文法编译生成引擎 (`SpecSQLGenerator`)**：
  - 递归插槽展开与产生式渲染
  - 负向用例自动推导（选取非法类型时自动置为 `expected: error` 并继承 `expected_sqlstates`）
- [x] **CSP 智能约束求解器 (`ConstraintSolver`)**：支持一阶逻辑蕴含规则 (`P => Q`) 前置剪枝
- [x] **TLP (三值逻辑分区) 蜕变测试 Oracle**：自动派生 4 条三值聚合查询，全自动验证查询优化器计算正确性
- [x] **测试数据合成发生器 (`DataSeeder`)**：自动生成包含 0、极值、空串、特殊字符与 NULL 的测试数据
- [x] **规格静态校验工具 (`SpecLinter`)**：检查插槽闭合性、矩阵引用完整性与 CSP 语法

---

## Phase 4: 文档自动化抽取与规格资产扩充 (当前阶段)

- [ ] **Doc2Spec 自动化抽取工具链**：利用 LLM 自动将 GaussDB 官方 SQL 参考手册转化为 `*.syntax.yaml` 与 `*.matrix.yaml`
- [ ] **核心语法规范库扩充 (目标 30+ 语法)**：
  - DDL 语法：`CREATE INDEX` (B-tree/UBTree/GIN/GIST), `CREATE VIEW`, `CREATE SEQUENCE`, `CREATE TYPE`
  - DML 语法：`UPDATE`, `DELETE`, `TRUNCATE`, `INSERT MULTI`, `MERGE INTO`
  - TCL 语法：`TRANSACTION`, `SAVEPOINT`, `SET TRANSACTION ISOLATION LEVEL`
  - 专有特性：`USTORE TABLE`, 分区表 (`RANGE` / `LIST` / `HASH`)
- [ ] **全局矩阵扩展**：GaussDB 兼容模式差异矩阵 (`sql_compatibility = 'PG' | 'B' | 'A' | 'TD'`)
- [ ] **规格覆盖率度量器 (Spec Coverage Meter)**：自动统计文档产生式与兼容矩阵的测试覆盖率与缺口报告

---

## Phase 5: GaussDB 深度企业级能力 (规划中)

- [ ] **Astore vs Ustore 跨引擎差分测试**：同一查询在两引擎并发回放，自动比对结果集
- [ ] **分布式架构特性测试**：分布键 (`DISTRIBUTE BY HASH / REPLICATION`)、CN/DN 协同验证
- [ ] **用例自动最小化 (Delta Debugging)**：发生 Core Dump 或结果错误时，自动二分剪枝生成最小复现用例 (MRE)
- [ ] **CI/CD 流水线深度集成**：Git 提交触发增量特性测试与回归测试快照对比
