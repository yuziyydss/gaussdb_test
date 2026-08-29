# GaussDB 规格驱动文法测试系统 (Next-Gen Testing Platform)

> 面向华为 GaussDB 数据库的工业级规格驱动自动化测试编译器：实现从产品文档（5800+页）到高质量测试用例、沙箱执行、蜕变验证与质量覆盖率闭环。

> 内网文档无法外传时，请从 [内网 AI 执行入口](INTRANET_AI_INSTRUCTIONS.md) 开始，并使用 [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md) 的离线任务队列。当前新规格的权威契约是 [Factor Package Schema V1](docs/FACTOR_PACKAGE_SCHEMA_V1.md)；下文部分旧版 `grammars/`、`matrices/`、`manifests/` 描述仅保留兼容背景。

---

## 一、 系统核心目标与设计理念

传统数据库测试多依赖“测试人员经验手工编写用例”或“纯随机模糊测试 (SQLsmith)”，存在维护成本高、无法验证复杂逻辑正确性、无真值基准等痛点。本项目通过**文法工程与编译器思想**实现全流程规格化：

* **文档到规格解耦 (Decoupled Specs)**：将客观文法 (`grammars/`)、全局语义与 GUC 矩阵 (`matrices/`) 与主观测试清单 (`manifests/`) 彻底解耦，避免规则冗余；
* **智能剪枝与求解 (CSP Pruning)**：内置一阶逻辑约束满足求解器（`P => Q`），在参数组合前置阶段剪除无效搜索空间；
* **动态符号状态机 (Symbol Table)**：维护全局 `SchemaContext`，驱动 `[建表] -> [插数据] -> [查数据] -> [加列]` 全生命周期业务场景链；
* **无需真值的蜕变测试 (TLP Oracle)**：利用三值逻辑分区（Ternary Logic Partitioning）数学不变性，自动验证 GaussDB 查询优化器与执行引擎计算正确性；
* **无污染沙箱隔离 (Schema Sandbox)**：动态创建独立 Schema 沙箱并在结束后级联清理，彻底根治 DDL 隐式提交污染测试库；
* **质量覆盖度闭环 (Spec Coverage Meter)**：自动度量文档提取的产生式分支、AST 插槽与约束规则覆盖率，并生成 **未覆盖特性缺口报告 (Gap Report)**。

---

## 二、 核心架构全景图

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                   GaussDB 产品文档 (SQL 参考手册 / 约束限制 / GUC 参数)                   │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ (Doc2Spec 抽取工具链)
        ┌───────────────────────────────────┼───────────────────────────────────┐
        ▼                                   ▼                                   ▼
【语法规范 (grammars/)】            【全局语义矩阵 (matrices/)】         【测试清单 (manifests/)】
• BNF 产生式与 AST 插槽             • 数据类型等价类池                  • 针对特性的参数空间绑定
• 子语法与 element_list 列表展开    • 存储引擎/表形态兼容矩阵           • 组合策略 (Pairwise / 3-way)
• 符号行为 (creates / consumes)     • GUC 参数池 & CSP 互斥规则         • 场景级附加约束规则
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
【Schema 沙箱执行器 (Executor)】    【TLP 蜕变测试 Oracle】             【覆盖率看板与 Web UI】
• 动态临时 Schema 隔离              • TLP 三值逻辑分区派生              • SpecCoverageMeter 覆盖率度量
• 执行完毕自动 DROP CASCADE 清理    • 完备性与谓词真值数学断言          • 文档特性缺口报告 (Gap Report)
• 杜绝 DDL 隐式提交污染测试库       • 验证查询优化器计算正确性          • Web 场景流水线与数据库配置看板
```

---

## 三、 项目完整目录结构

```
gaussdb_test/
├── grammars/                      # 1. 语法规范库 (*.syntax.yaml)
│   ├── ddl/create_table.syntax.yaml   # CREATE TABLE 主语法与列定义子语法
│   └── dml/select.syntax.yaml         # SELECT 查询主语法与各子句插槽
│
├── matrices/                      # 2. 全局语义兼容矩阵 (*.matrix.yaml)
│   ├── gaussdb_core.matrix.yaml       # 全局数据类型等价类池 + 存储引擎客观互斥规则
│   └── guc_parameters.matrix.yaml     # GaussDB 核心 GUC 参数池 (优化器开关/兼容模式)
│
├── manifests/                     # 3. 组合测试清单 (*.manifest.yaml)
│   ├── ddl/create_table_comprehensive.manifest.yaml # 表形态 × 引擎 × 数据类型两两组合
│   └── dml/select_tlp.manifest.yaml   # SELECT 查询与 TLP 蜕变测试清单
│
├── core/                          # 核心测试引擎与算法库
│   ├── spec_model.py              # 三层解耦规格数据契约与 SpecRegistry
│   ├── spec_generator.py          # AST 插槽展开与文法生成引擎
│   ├── spec_linter.py             # 规格完整性与语法静态校验器 (spec-lint)
│   ├── coverage_meter.py          # 文档特性覆盖率度量器与缺口分析器
│   ├── data_seeder.py             # 类型感知的边界测试数据合成发生器
│   ├── symbol_table.py            # 数据库动态符号表 (SchemaContext)
│   ├── scenario.py                # 业务场景流水线状态机 (ScenarioEngine)
│   ├── constraint_solver.py       # CSP 约束满足求解器 (P => Q 求解)
│   ├── oracle.py                  # TLP (三值逻辑分区) 蜕变测试 Oracle
│   ├── executor.py                # Schema 沙箱隔离执行器 (真实/桩模式)
│   ├── factor_model.py            # 兼容旧版单一因子数据模型
│   ├── generator.py               # 旧版因子用例生成器
│   ├── combinator.py              # Pairwise (IPOG) / 笛卡尔积纯算法
│   └── reporter.py                # HTML / JSON 测试报告生成器
│
├── web/                           # Web 交互平台 (FastAPI + HTMX + Tailwind)
│   ├── templates/                 # UI 模板 (场景看板/清单生成/覆盖率大屏/DB配置)
│   └── static/
│
├── docs/                          # 详细官方设计与演进指南
│   ├── SPEC_SPECIFICATION_GUIDE.md    # 三类标准规格文件设计范式与编写规范
│   ├── DOC2SPEC_EXTRACTION_GUIDE.md   # Doc2Spec 产品文档自动抽取指南与 Prompt 模板
│   ├── LARGE_DOC_EXTRACTION_AND_GUC_GUIDE.md # 海量文档(5800+页)防遗漏与 GUC 归档
│   ├── EVOLUTION_PLAN.md              # 下一代架构与演进规划设计书
│   ├── ARCHITECTURE.md                # 系统全景架构概览
│   ├── ROADMAP.md                     # 开发路线图
│   └── FACTOR_GUIDE.md                # 单因子编写指南 (向后兼容)
│
├── tests/                         # 自动化单元测试套件 (25/25 Green)
│   ├── test_core.py               # 基础模型与沙箱判定测试
│   ├── test_symbol_table.py       # 符号表增删改查与快照回滚测试
│   ├── test_scenario.py           # 场景流水线时序流测试
│   ├── test_oracle_and_csp.py     # TLP 蜕变测试与 CSP 约束求解测试
│   ├── test_spec_engine.py        # 规格编译、Linter 与数据发生测试
│   ├── test_coverage_meter.py     # 覆盖率度量与缺口报告测试
│   └── test_api.py                # Web 路由与 API 集成测试
│
├── factors/                       # 向后兼容的旧版单文件因子目录
├── reports/                       # 生成的 HTML/JSON 测试报告输出目录
├── main.py                        # FastAPI 应用启动入口
└── requirements.txt               # 项目 Python 依赖
```

---

## 四、 快速开始

### 1. 环境准备与依赖安装

```bash
# 克隆仓库
git clone https://github.com/yuziyydss/gaussdb_test.git
cd gaussdb_test

# 安装依赖
pip install -r requirements.txt
```

### 2. 运行自动化单元测试套件 (100% 验收验证)

```bash
python3 -m unittest discover -s tests
# 运行全部 25 项测试 (覆盖模型、符号表、场景流、TLP、CSP、规格引擎、覆盖率与 API)
```

### 3. 启动 Web 交互看板

```bash
python3 main.py
# 浏览器打开 http://localhost:8000
```

* **数据库配置**：点击右上角 **「数据库配置」** $\to$ 输入 GaussDB 主机、端口并测试连通性；
* **测试清单 (Manifests)**：点击左侧 **「测试清单」** $\to$ 浏览参数空间并一键生成规格测试用例；
* **场景流水线 (Scenarios)**：点击左侧 **「表全生命周期场景」** $\to$ 一键运行多因子状态迁移测试；
* **质量度量 (Coverage)**：点击左侧 **「文档特性覆盖度量」** $\to$ 查看全景覆盖率大屏并导出 Markdown 缺口报告。

---

## 五、 详细文档导航

| 文档名称 | 链接路径 | 核心内容 |
| :--- | :--- | :--- |
| **三类标准规格文件设计范式** | [`docs/SPEC_SPECIFICATION_GUIDE.md`](docs/SPEC_SPECIFICATION_GUIDE.md) | `*.syntax.yaml`、`*.matrix.yaml`、`*.manifest.yaml` 的 Schema 契约、产生式插槽与一阶逻辑规则语法 |
| **Doc2Spec 文档自动抽取指南** | [`docs/DOC2SPEC_EXTRACTION_GUIDE.md`](docs/DOC2SPEC_EXTRACTION_GUIDE.md) | 大模型（DeepSeek/Gemini/GPT-4）从产品文档抽取 YAML 的标准 Prompt 模板与 SOP 流程 |
| **海量文档抽取与 GUC 归档规范** | [`docs/LARGE_DOC_EXTRACTION_AND_GUC_GUIDE.md`](docs/LARGE_DOC_EXTRACTION_AND_GUC_GUIDE.md) | 5800+ 页文档切片与 TOC 目录对账机制、GUC 上下文因子建模与 NoREC 优化器差分测试 |
| **下一代架构演进方案** | [`docs/EVOLUTION_PLAN.md`](docs/EVOLUTION_PLAN.md) | 痛点诊断与沙箱隔离、多错误码、状态机、TLP、CSP 六大支柱深度技术设计 |
| **系统架构概览** | [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | 端到端数据流与各模块职责划分 |
| **系统开发路线图** | [`docs/ROADMAP.md`](docs/ROADMAP.md) | 里程碑阶段归档与后续规划 |
| **单因子编写指南** | [`docs/FACTOR_GUIDE.md`](docs/FACTOR_GUIDE.md) | 旧版单文件 YAML 因子编写参考（向后兼容） |

---

## 六、 当前系统状态汇总

- [x] **Schema 临时沙箱隔离**：执行前后自动创建并级联删除独立 Schema，彻底根治 DDL 隐式提交污染测试库
- [x] **多 SQLSTATE 容错匹配**：支持 `expected_sqlstates` 候选集判定，消除语法/语义阶段错误码假阳性误报
- [x] **动态符号表 (`SchemaContext`)**：类型推断、智能符号推荐（`pick_table`/`pick_column`）、快照与回滚
- [x] **时序业务场景流水线 (`ScenarioEngine`)**：驱动 `[建表] -> [插数据] -> [查数据] -> [加列]` 状态迁移
- [x] **TLP (三值逻辑分区) 蜕变测试 Oracle**：自动派生 4 条三值聚合查询，全自动验证优化器计算正确性
- [x] **CSP 智能约束求解器**：支持一阶逻辑蕴含规则（`P => Q`）与点分变量，组合前置可行域剪枝
- [x] **三层规格解耦体系**：`grammars/` (语法) + `matrices/` (全局矩阵与 GUC) + `manifests/` (测试清单)
- [x] **测试数据合成发生器 (`DataSeeder`)**：自动生成涵盖 0、极值、空串、特殊字符与 NULL 的测试数据
- [x] **规格静态校验工具 (`SpecLinter`)**：静态检查语法插槽闭合性与引用完整性
- [x] **文档特性覆盖率度量器 (`SpecCoverageMeter`)**：自动统计文法、类型与约束覆盖率并导出缺口报告
- [x] **全量自动化测试**：25 项单元测试 100% 覆盖并通过 (Green)
- [x] **Web UI 看板与数据库配置**：提供场景流水线看板、清单生成器、数据库连通性测试与覆盖率大屏
