# SQL Reference Wave 8-134 Extraction V1

## 目标

抽取 M 兼容 `SELECT`（2.4.2.16.2，22 页最大语句节单批覆盖）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 22 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- SELECT全语法（WITH RECURSIVE/修饰符/INTO/FROM/WHERE/GROUP BY ROLLUP/HAVING/WINDOW/ORDER BY NULLS/LIMIT FETCH/锁定子句）
- 修饰符语义（ALL/DISTINCT|DISTINCTROW/STRAIGHT_JOIN/SQL_CALC_FOUND_ROWS/SQL_CACHE）
- 别名使用七条限制（同层引用/targetlist/前后顺序/volatile/窗口函数/join on/多别名）
- INTO三形式（表/OUTFILE FIELDS+LINES/DUMPFILE）与导出格式基线
- FROM六类源与五种JOIN、分区并集规则、index_hint_list
- GROUP BY WITH ROLLUP与join场景规则、HAVING列引用限制
- UNION/EXCEPT去重与FOR UPDATE禁用、enable_union_all_order保序
- FETCH FIRST/NEXT与OFFSET、锁定子句四种形式
- 子查询四示例（IN/ANY/ALL/聚合）与UNION/EXCEPT示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_select_wave8_134_oq_runtime` | M兼容别名七条限制在复杂查询中的完整判定、WITH CONSISTENT类窗口别名引用、enable_union_all_order保序对并行执行的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_134_v1.yaml
generated/core_sql_reference_wave8_134_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_134.py
python scripts/build_core_sql_reference_wave8_134.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_134.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容SELECT语句。
