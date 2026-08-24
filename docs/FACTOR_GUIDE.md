# 因子编写指南

## 最小因子

```yaml
id: select_basic
name: SELECT
category: DML
template: "SELECT {select_clause} FROM {table_name}"
params:
  select_clause:
    classes:
      - name: 全部列
        values: ["*"]
      - name: 指定列
        values: ["col_1"]
constants:
  table_name: "t_factor_test"
default_strategy: equivalence
```

## 带预期结果的因子

```yaml
params:
  column_datatype:
    classes:
      - name: 整数
        values: ["INTEGER"]
        expected: success
      - name: 非法类型
        values: ["FAKETYPE"]
        expected: error
        expected_sqlstate: "42704"
```

等价类标了 expected 后，生成的每条用例都带预期结果。
组合多参数时，最严格原则：任一参数预期 error 则整条预期 error。

## 带 fixture 依赖的因子

```yaml
setup:
  - factor: create_table          # 引用的因子 ID
    strategy: equivalence          # fixture 用哪种策略
    context:                       # 固定 fixture 参数
      column_datatype: INTEGER
```

执行时自动把 fixture 的 SQL 拼在 test SQL 前面。

## 带 fixture 矩阵的因子

```yaml
setup:
  - factor: create_table
    matrix: true                   # 用所有数据类型交叉
```

引擎自动展开: target 的所有组合 × fixture 的所有组合。
不同 fixture 配置下预期可能不同，用 expected_matrix 规则覆盖：

```yaml
expected_matrix:
  - when_fixture: {column_datatype: "VARCHAR(100)"}
    when_param: {value: "'abc'"}
    then: {expected: success}
```

## 带上下文叠加的因子

```yaml
context_overlays:
  - name: 分区表上下文
    setup:
      - factor: create_partitioned_table
    params_override:
      table_name: "t_factor_part"
    expected_override:
      value:
        "NULL":
          expected: error
          sqlstate: "23514"
```

同一因子在不同上下文下重跑，SQL 和预期都可以覆盖。

## 等价类设计原则

1. 有效等价类：正常值、边界值、典型代表
2. 无效等价类：类型错误、越界、空值、非法语法
3. 每个等价类取一个代表值即可，不需要穷举
4. 高风险参数可以加更多等价类，低风险参数可以少加

## 复合参数

当模板里某个占位符需要由多个参数组合而成时，用 composites：

```yaml
composites:
  column_def:
    template: "col_1 {column_datatype} {column_constraint}"
```

composites 支持字符串简写：

```yaml
composites:
  column_def: "col_1 {column_datatype} {column_constraint}"
```

## 命名规范

- 文件名: 下划线，如 `create_table.yaml`
- 因子 id: 下划线，如 `create_table`
- 目录: 按 `factors/ddl/`、`factors/dml/` 分类
- doc_ref: 文档章节路径，如 `"SQL参考/DDL/CREATE-TABLE"`

## 覆盖策略选择

- equivalence: 代表值笛卡尔积，用例少，适合日常
- pairwise: 两两覆盖，用例中等，适合 CI
- full_cartesian: 全笛卡尔积，用例多，适合发布前
