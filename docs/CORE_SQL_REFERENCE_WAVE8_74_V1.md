# SQL Reference Wave 8-74 Extraction V1

## 目标

抽取 EXPLAIN 族：`EXPLAIN` 执行计划显示（全选项）、`EXPLAIN PLAN` 计划存储与 `EXPLAIN AUTOHINT` 内核自动调用。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.11.5` | 8 | EXPLAIN |
| `1.13.11.6` | 2 | EXPLAIN PLAN |
| `1.13.11.7` | 2 | EXPLAIN AUTOHINT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- EXPLAIN用途（扫描方式/JOIN方式）
- 预计开销指标、ANALYZE实际执行、事务回滚防改动、审计类型
- 两种语法与14个选项（ANALYZE/VERBOSE/COSTS/CPU/DETAIL/BUFFERS/TIMING/PLAN/BLOCKNAME/OUTLINE/ADAPTCOST/FORMAT/OPTEVAL/PERFORMANCE）
- ANALYZE双参数后者生效；PLAN on不打印返回EXPLAIN SUCCESS
- BLOCKNAME/OUTLINE pretty模式要求
- ADAPTCOST基数估计与aplan/cplan
- PERFORMANCE字段明细（ex c/r、inc cyc、shared hit等）
- OPTEVAL仅四类SCAN算子且仅与COSTS/VERBOSE/FORMAT共存
- behavior oracle：Seq Scan、CPU行、JSON/YAML、COSTS FALSE、Aggregate、二级分区Iterations/Selected Subpartitions、OPTEVAL明细
- EXPLAIN PLAN存储PLAN_TABLE、session/用户隔离、STATEMENT_ID 30字节限制、禁止INSERT/UPDATE/ANALYZE
- 行为基线（TPCH-Q4标签与清理）
- EXPLAIN AUTOHINT内核自动调用、session/用户隔离、PLAN/EXECUTE两类exec_type与argument格式、用户直接调用报错阻拦

## Open questions

| ID | 内容 |
|---|---|
| `explain_wave8_74_oq_runtime` | EXPLAIN各选项组合、PLAN_TABLE存储与AUTOHINT内核调用路径在真实查询和智能计划管理场景下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_74_v1.yaml
generated/core_sql_reference_wave8_74_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_74.py
python scripts/build_core_sql_reference_wave8_74.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_74.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行EXPLAIN语句。
