# SQL Reference Wave 8-128 Extraction V1

## 目标

抽取 M 兼容 `内部函数`（2.5.17，17 页，内部函数名称清单，数百个函数按命名族分组入账）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 内部函数定位与命名规律（_mysql后缀标识M兼容内部实现）
- binary/bit/blob/bool/bpchar/date/datetime/year各类型族转换与比较函数清单
- date_row_*/datetime_row_*行比较族、binary_str比较族、时间戳比较族
- recv/send收发族、typmodin/out族、literal字面量族、index支撑
- float/int转换（f4toi1/f8toi1）、variance方差内部族、param_cast参数转换族、xor_bool
- 数值杂项（div_any/double_bool_m/dtoi*/equal_*系列/gs_get_partkeyexpr）

## Open questions

| ID | 内容 |
|---|---|
| `m_if_wave8_128_oq_runtime` | M兼容内部函数清单随版本演进的增减、_mysql后缀函数与A模式同名函数的行为差异矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_128_v1.yaml
generated/core_sql_reference_wave8_128_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_128.py
python scripts/build_core_sql_reference_wave8_128.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_128.py
```

## 边界

- 本阶段只做原文事实抽取（内部函数名称清单），不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不调用内部函数。
