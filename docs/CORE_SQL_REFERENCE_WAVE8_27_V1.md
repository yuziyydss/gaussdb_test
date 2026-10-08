# SQL Reference Wave 8-27 Extraction V1

## 目标

抽取 `1.13.21.1 UPDATE`，补齐单表/多表更新、视图与子查询更新、分区更新、游标定位更新和RETURNING能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.21.1` | 8 | UPDATE |

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

- UPDATE主语法、单表/多表更新和RETURNING
- UPDATE、SELECT权限与系统表保护
- 生成列、STREAM并发更新和多表视图/RULE限制
- WITH/RECURSIVE CTE与plan_hint
- 表、ONLY、DATABASE LINK、视图/子查询目标
- PARTITION/SUBPARTITION更新和分区并集
- SET列赋值、DEFAULT、多列子查询
- FROM表列表、Boolean条件
- WHERE CURRENT OF游标更新
- CTE UPDATE RETURNING驱动INSERT与CHECK OPTION行为

## Open questions

| ID | 内容 |
|---|---|
| `upd_wave8_27_oq_runtime` | UPDATE在真实并发、分区路由、视图/子查询、多表更新、游标定位和RETURNING组合下的结果、锁等待与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_27_v1.yaml
generated/core_sql_reference_wave8_27_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_27.py
python scripts/build_core_sql_reference_wave8_27.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_27.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行UPDATE或DML。
