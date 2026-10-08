# SQL Reference Wave 8-120 Extraction V1

## 目标

抽取 M 兼容 `UPDATE`、`USE` 与 `VACUUM`（2.4.2 语句章收官批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- UPDATE单表/多表语法、IGNORE六场景错误降级、分区更新并集规则、子查询/INTO OUTFILE/DUMPFILE、ONLY保留语法
- 生成列禁写、STREAM计划并发限制、系统表禁改字符编码、enable_update_tuple_count去重
- UPDATE示例基线（子查询更新/视图更新/RETURNING）
- USE当前模式指定、USAGE权限与database()验证（NULL报错基线）、SHOW DATABASES
- VACUUM三种语法、FULL重建表机制与排他锁/死锁风险、INIT_TD等存储参数、DELETE后VACUUM FULL回收规则、vacuum_defer_cleanup_age、xc_maintenance_mode
- 示例基线（VACUUM VERBOSE ANALYZE）

## Open questions

| ID | 内容 |
|---|---|
| `m_update_use_vacuum_wave8_120_oq_runtime` | M兼容UPDATE IGNORE六场景降级的具体值映射、enable_update_tuple_count去重对统计口径的影响、VACUUM FULL与段页式表空间复用的实际回收率需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_120_v1.yaml
generated/core_sql_reference_wave8_120_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_120.py
python scripts/build_core_sql_reference_wave8_120.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_120.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容UPDATE/VACUUM语句。
