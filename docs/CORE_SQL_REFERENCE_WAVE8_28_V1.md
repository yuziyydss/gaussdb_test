# SQL Reference Wave 8-28 Extraction V1

## 目标

抽取 `1.13.10.3 DELETE`，补齐单表/多表删除、分区删除、视图/子查询删除、游标定位删除和RETURNING能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.3` | 8 | DELETE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DELETE主语法、无WHERE全删行为和RETURNING
- DELETE、SELECT权限边界
- 多表视图/RULE限制与Stream计划并发边界
- WITH/RECURSIVE CTE和plan_hint
- 表、ONLY、DATABASE LINK、子查询/视图目标
- 保留键表、CHECK OPTION和系统视图限制
- PARTITION/SUBPARTITION与B模式多分区删除
- USING目标表规则、Boolean条件
- WHERE CURRENT OF游标删除
- CTE DELETE RETURNING驱动关联删除
- TRUNCATE替代全量DELETE建议

## Open questions

| ID | 内容 |
|---|---|
| `del_wave8_28_oq_runtime` | DELETE在真实并发、分区路由、视图/子查询、多表删除、游标定位和RETURNING组合下的结果、锁等待与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_28_v1.yaml
generated/core_sql_reference_wave8_28_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_28.py
python scripts/build_core_sql_reference_wave8_28.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_28.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DELETE或DML。
