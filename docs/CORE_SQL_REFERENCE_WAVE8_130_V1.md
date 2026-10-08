# SQL Reference Wave 8-130 Extraction V1

## 目标

抽取 M 兼容 `数据类型`（2.6，33 页大章单批覆盖布尔/二进制/字符串/日期时间/位串/数值/JSON/枚举/集合九大类）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 33 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 九大类数据类型全集与存储空间（BINARY 255/VARBINARY 65532/BLOB 65535/LONGBLOB 1GB-1/TEXT家族/DATE 4字节/TIME与DATETIME 8字节/BIT 64字节/NUMERIC最大81位/JSON 1073741817字节/SET 4~8字节）
- 有符号/无符号整数完整范围（表2-77/2-78）
- 2位年份转换（70~99→19xx、00~69→20xx）、sql_mode（strict_trans_tables/allow_invalid_dates/no_zero_in_date/no_zero_date）行为矩阵
- TIME -838:59:59~838:59:59、T分隔符、毫秒截断
- BIT截断补零、x'0'=x'00'、enable_bit_out_to_hex十六进制显示、JDBC 4字节对齐
- pad_char_to_full_length、ZEROFILL显示宽度、'||'连接符不支持
- ENUM下标映射与非法值0插入、SET bitmap存储与64成员/分区键禁用/索引整型限制/回收站不入
- 布尔与BIT严格/宽松模式示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_dt2_wave8_130_oq_runtime` | M兼容strict_trans_tables与非严格模式在各类类型下的截断值边界、BIT的enable_bit_out_to_hex与JDBC工具适配、SET类型bitmap存储在64成员满配下的性能需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_130_v1.yaml
generated/core_sql_reference_wave8_130_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_130.py
python scripts/build_core_sql_reference_wave8_130.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_130.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容类型语句。
