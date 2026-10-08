# SQL Reference Wave 8-19 Extraction V1

## 目标

抽取 `1.13.19.3 SELECT`，补齐查询主语法、来源/连接、递归与层次查询、聚合分组、窗口框架、集合运算、分页和行锁定能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.19.3` | 44 | SELECT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 44 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- SELECT权限、targetlist别名复用和plan hint边界
- WITH/RECURSIVE CTE与物化行为
- ALL/DISTINCT/DISTINCT ON、INTO变量和文件导出
- FROM表/视图/子查询/表函数/分区/二级分区来源
- TABLESAMPLE三种采样方式与REPEATABLE
- TIMECAPSULE时间/CSN闪回约束
- INNER/LEFT/RIGHT/FULL/CROSS JOIN
- XMLTABLE、PIVOT与UNPIVOT兼容模式约束
- WHERE布尔条件与非标准外连接`(+)`
- START WITH/CONNECT BY层次递归、循环检测与NOCYCLE
- GROUP BY/ROLLUP/CUBE/GROUPING SETS/HAVING
- WINDOW命名定义与RANGE/ROWS frame边界
- UNION/INTERSECT/EXCEPT/MINUS集合约束
- ORDER BY、LIMIT/OFFSET/FETCH与FOR UPDATE/SHARE锁定

## Open questions

| ID | 内容 |
|---|---|
| `sql_wave8_19_oq_runtime` | SELECT各子句在真实表规模、并发事务、闪回、分区和兼容模式下的计划与行为矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_19_v1.yaml
generated/core_sql_reference_wave8_19_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_19.py
python scripts/build_core_sql_reference_wave8_19.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_19.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行SELECT或文件导出。
