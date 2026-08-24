# GaussDB 测试因子库

> 规格驱动的数据库测试系统：从产品文档到测试用例的自动化管道

## 目标

把数据库测试从"人凭经验想用例"变成"系统从文档推导用例"：

- **可度量**：覆盖度 = 已建因子覆盖的文档特性数 / 文档总特性数
- **可追溯**：每个因子带 `doc_ref` 指向产品文档章节
- **可组合**：fixture 链 + 矩阵 + 上下文叠加，自动发现跨因子交互
- **可回归**：基线快照 + 版本 diff，自动检测行为变更
- **可继承**：测试知识编码在 YAML 里，不随人员流动而流失

## 快速开始

```bash
# 安装依赖
pip install -r requirements.txt

# 启动 Web 应用
python main.py
# 打开 http://localhost:8000

# 或用 API 生成测试用例
curl http://localhost:8000/api/factors
curl http://localhost:8000/api/generate/create_table?strategy=pairwise
```

## 因子库是什么

因子库 = `factors/` 目录下一组 YAML 文件。每个文件定义一个可测试的 SQL 构造（如 CREATE TABLE、INSERT），包含：

- **模板**：SQL 骨架，用 `{param}` 占位
- **参数**：可变化维度，按等价类组织
- **等价类**：行为相似的值归为一类，每类取代表值
- **预期结果**：每个等价类标注 expected（success/error + SQLSTATE）
- **前置依赖**：fixture 链，声明先执行哪些其他因子
- **上下文叠加**：在不同环境（表形态、兼容模式）下重跑，预期可覆盖

引擎读取 YAML，按组合策略展开，自动生成带预期结果的测试用例。

## 目录结构

```
gaussdb_test/
  core/               # 引擎
    factor_model.py   # 因子数据模型 (Pydantic)
    combinator.py     # 组合算法 (equivalence/pairwise/cartesian)
    generator.py      # SQL 生成 + fixture 链 + 矩阵 + 上下文叠加
    executor.py       # GaussDB 执行器 (桩模式/真实模式)
    reporter.py       # HTML + JSON 报告
    registry.py       # YAML 因子加载器
  factors/            # 因子库 (YAML 文件集合)
    ddl/              # DDL 因子
    dml/              # DML 因子
  web/                # Web UI
    templates/        # Jinja2 + HTMX + Tailwind
    static/
  docs/               # 项目文档
  reports/            # 生成的测试报告
  main.py             # FastAPI 应用入口
```

## 四种组合策略

| 策略 | 机制 | 适用 |
|------|------|------|
| 单因子内 Pairwise | 因子内部多参数两两组合 | 单条 SQL 参数交互 |
| 固定 Fixture | target + 固定前置 | 前置不需变化的简单测试 |
| Fixture 矩阵 | target × fixture 所有配置 | 跨因子交互发现 (核心) |
| 场景链 | 多因子顺序执行 | 多步业务场景验证 |

## 四种因子角色

| 角色 | 定义 |
|------|------|
| 被因子 (Target) | 测试的直接对象 |
| 前置因子 (Fixture) | 测试前建立场景 |
| 上下文因子 (Context) | 修饰被测因子行为 |
| 预期因子 (Oracle) | 定义应该发生什么 |

## 详细文档

- [架构概览](docs/ARCHITECTURE.md)
- [开发路线图](docs/ROADMAP.md)
- [因子编写指南](docs/FACTOR_GUIDE.md)
- [完整分类框架](../outputs/factor-framework.md)
- [从零到懂](../outputs/factor-library-explained.md)

## 当前状态

- 因子模型：已增强（expected, doc_ref, setup, context_overlays, expected_matrix）
- 组合引擎：已增强（fixture 链, 矩阵, 上下文叠加）
- 执行器：桩模式可用，真实执行需安装 psycopg2
- 因子数量：5 个（目标 200+）
- Web UI：基础可用，待增强预期结果展示
