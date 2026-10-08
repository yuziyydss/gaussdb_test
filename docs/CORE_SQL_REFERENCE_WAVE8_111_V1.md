# SQL Reference Wave 8-111 Extraction V1

## 目标

抽取 M 兼容 `CREATE TABLE`（2.4.2.8.16，20 页单节成批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 20 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 全局/本地临时表双模式（ON COMMIT PRESERVE/DELETE ROWS）与会话隔离语义
- 全局临时表五不支持场景、max_active_global_temporary_table开关、clog回收风险
- UNLOGGED非日志表WAL不记录/不复制/备机报错
- table_option四项“最后一个生效”与ENGINE/ROW_FORMAT不生效
- LIKE继承清单与WITH/PARTITION BY覆盖规则
- 字段字符集BINARY→BLOB映射、表默认继承
- 存储参数FILLFACTOR/INIT_TD公式/USTORE默认与track_counts前提/enable_tde
- 生成列STORED/VIRTUAL与表达式限制、分区键/外键/索引交互、默认VIRTUAL条件（s2）
- CHECK精度基线（enable_precision_decimal前后INSERT行为）
- ON UPDATE时间戳属性约束、DEFAULT两种格式与update_expr精度一致
- 自增列AUTO_INCREMENT=10的NULL/100/0三种插入行为基线
- 外键约束特点五条与999报错基线

## Open questions

| ID | 内容 |
|---|---|
| `m_create_table_wave8_111_oq_runtime` | 全局临时表在长连接场景clog不回收的实际风险、多字符集混用转码边界、生成列精度传递开关前后差异、USTORE下INIT_TD调整对现有数据页的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_111_v1.yaml
generated/core_sql_reference_wave8_111_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_111.py
python scripts/build_core_sql_reference_wave8_111.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_111.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容CREATE TABLE语句。
