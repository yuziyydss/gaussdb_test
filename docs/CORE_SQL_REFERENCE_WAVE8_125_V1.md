# SQL Reference Wave 8-125 Extraction V1

## 目标

抽取 M 兼容 `类型转换函数`、`网络地址函数` 与 `聚合函数`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 25 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CAST/CONVERT 12类type转换（BINARY截断0x00填充/CHAR截断不填充/DECIMAL M65 D30/FLOAT p分界/UNSIGNED）
- INET6_ATON/NTOA、INET_ATON/NTOA（省略段补齐基线）、IS_IPV4
- 聚合函数全集：AVG/BIT_AND/BIT_OR/BIT_XOR/COUNT/COUNT DISTINCT多参数/GROUP_CONCAT（group_concat_max_len）/JSON_ARRAYAGG/JSON_OBJECTAGG/MAX/MIN/STD/STDDEV/STDDEV_POP/STDDEV_SAMP/SUM/VARIANCE/VAR_POP/VAR_SAMP
- 聚合输入顺序精度差异基线（std 15.02396266299967）
- over_clause窗口用法

## Open questions

| ID | 内容 |
|---|---|
| `m_conv_agg_wave8_125_oq_runtime` | CAST的BINARY/CHAR长度与max_allowed_packet联动截断边界、聚合函数输入顺序导致精度差异的可复现规律、INET6_ATON对IPv6缩写形式的支持范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_125_v1.yaml
generated/core_sql_reference_wave8_125_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_125.py
python scripts/build_core_sql_reference_wave8_125.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_125.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容转换/聚合语句。
