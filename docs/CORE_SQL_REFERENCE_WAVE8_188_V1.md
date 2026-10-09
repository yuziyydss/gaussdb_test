# SQL Reference Wave 8-188 Extraction V1

## 目标

抽取 MySQL兼容M模式数据类型：`4.4.2.1 数据类型`（整数/任意精度/浮点/日期时间/字符串/二进制/JSON类型及属性和转换，页 3292–3331）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 39 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 整数类型（BOOL/TINYINT/SMALLINT/MEDIUMINT/INT/BIGINT + CTAS列长度差异）
- 任意精度/浮点类型（DECIMAL/NUMERIC/FLOAT/DOUBLE/REAL + extra_float_digits差异）
- 日期时间类型（DATE/DATETIME/TIMESTAMP/TIME/YEAR + 精度截断 vs 报错 + explicit_defaults_for_timestamp=on/off行为差异）
- 字符串类型（CHAR/VARCHAR/TEXT系列 + LONGTEXT 1GB vs 4GB + 默认值/主键/索引/外键差异 + 十六进制输出差异）
- 二进制类型（BINARY/VARBINARY/BLOB系列 + 填充0x20 vs 0x00 + 主键/索引/外键差异 + hex输出差异基线）
- JSON类型（最大长度/字符集/COLLATE/ORDER BY差异）
- 数据类型属性与转换

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_188_oq_runtime` | CTAS场景下enable_precision_decimal开关对列长度计算的影响边界、LONGTEXT 1GB vs 4GB差异对迁移的影响、TIMESTAMP explicit_defaults_for_timestamp参数在GaussDB中的等价行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_188_v1.yaml
generated/core_sql_reference_wave8_188_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_188.py
python scripts/build_core_sql_reference_wave8_188.py --check
python -m unittest tests.test_core_sql_reference_wave8_188 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
