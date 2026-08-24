# 架构概览

## 数据流

```
factors/*.yaml (因子定义)
       |
       v
  FactorRegistry.load()     ← 扫描目录, 加载 YAML
       |
       v
  generate_cases(factor, strategy, registry)
       |
       +---> combinator.generate()        # 参数组合 (equivalence/pairwise)
       +---> _resolve_setup()             # fixture 链解析
       +---> _generate_matrix()           # fixture 矩阵交叉
       +---> context_overlays 处理         # 上下文叠加
       |
       v
  List[GeneratedCase] (SQL + expected + setup + context)
       |
       v
  Executor.execute_batch()  ← 执行 SQL, 捕获结果
       |
       v
  List[ExecResult] (status + verdict)
       |
       v
  Reporter.generate_report()  ← HTML + JSON 报告
```

## 模块职责

### factor_model.py
因子定义的 Pydantic 数据模型。定义了 EquivalenceClass、ParamDef、SetupDef、FactorDef。
关键方法：values_for_strategy()、merge_expected()、render_sql()、has_matrix_setup()。

### combinator.py
纯算法模块，三种组合策略：generate_equivalence()、generate_pairwise() (IPOG)、generate_cartesian()。
不依赖任何其他模块。

### generator.py
SQL 生成引擎。读取 FactorDef，调用 combinator 组合参数，渲染 SQL，解析 fixture 链，
处理矩阵和上下文叠加。输出 GeneratedCase 列表。
关键函数：generate_cases(factor, strategy, registry)。

### executor.py
SQL 执行器。桩模式返回 skipped；真实模式连接 GaussDB，执行 SQL，
捕获 SQLSTATE，检测 core dump，与 expected 比对，输出 verdict (pass/fail/crash)。

### registry.py
YAML 因子加载器。扫描 factors/ 目录，加载所有 .yaml 文件为 FactorDef。
支持热加载（reload）。

### reporter.py
报告生成器。接收 cases + results，输出 HTML（Tailwind 风格）和 JSON。

## 因子 YAML Schema

| 字段 | 必填 | 说明 |
|------|------|------|
| id | 是 | 因子唯一标识 |
| name | 是 | 因子中文名 |
| category | 是 | 分类 (DDL/DML/DCL/TCL/...) |
| doc_ref | 否 | 产品文档章节引用 |
| description | 否 | 因子描述 |
| template | 是 | SQL 模板 |
| params | 是 | 可参数化维度 |
| params.classes[].expected | 否 | 等价类预期结果 |
| params.classes[].expected_sqlstate | 否 | 预期 SQLSTATE |
| composites | 否 | 复合参数 |
| constants | 否 | 固定值 |
| setup | 否 | 前置因子依赖 (fixture) |
| setup[].matrix | 否 | 是否矩阵模式 |
| context_overlays | 否 | 上下文叠加 |
| expected_matrix | 否 | 跨因子预期规则 |
| default_strategy | 否 | 默认策略 (equivalence/pairwise/full_cartesian) |

## 向后兼容

所有新增字段都有默认值。不带 expected/doc_ref/setup 的旧 YAML 因子
仍然正常加载和生成。新增能力是增量叠加，不破坏已有功能。
