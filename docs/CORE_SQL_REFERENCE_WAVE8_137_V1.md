# SQL Reference Wave 8-137 Extraction V1

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

- SELECT全语法（WITH RECURSIVE/plan_hint/七修饰符/INTO/FROM/WHERE/GROUP BY ROLLUP/HAVING/WINDOW/ORDER BY NULLS/LIMIT FETCH OFFSET/锁定子句/UNION EXCEPT）
- 别名使用七条限制（同层/targetlist/前后顺序/volatile/窗口函数/join on/多别名）
- CTE RECURSIVE规则与类型cast一致约束
- dual虚拟表、TIMECAPSULE闪回查询（十类禁闪表、PCR UBTree、Snapshot too old、3秒偏差）
- joined_table五种JOIN与STRAIGHT_JOIN、USING/NATURAL、int条件隐式转换警告
- GROUP BY ONLY_FULL_GROUP_BY四条规则与LEFT/RIGHT JOIN示例
- UNION/EXCEPT去重与FOR UPDATE禁用、enable_union_all_order保序
- ORDER BY聚合列特例、中文拼音排序（gb18030_chinese_ci）
- LIMIT/FETCH/OFFSET、锁定子句FOR UPDATE/FOR SHARE/NOWAIT/WAIT N/SKIP LOCKED全语义、ustore限制
- 示例基线（基础查询/子查询四形态/UNION EXCEPT）

## Open questions

| ID | 内容 |
|---|---|
| `m_select_wave8_137_oq_runtime` | M兼容TIMECAPSULE闪回查询在TRUNCATE后时间点与CSN方式的差异行为、别名七条限制在复杂查询中的完整判定、SKIP LOCKED跳行锁的并发场景需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_137_v1.yaml
generated/core_sql_reference_wave8_137_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_137.py
python scripts/build_core_sql_reference_wave8_137.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_137.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容SELECT语句。
