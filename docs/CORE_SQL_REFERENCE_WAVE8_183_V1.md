# SQL Reference Wave 8-183 Extraction V1

## 目标

抽取 Oracle兼容性说明第四切片：`4.3.11.1 单行函数`（数值/字符/日期时间/比较/转换/编码/环境函数差异，页 3206–3225）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3206–3225） |
| 物理页 | 20 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 函数分类：数值/字符/日期时间/转换/通用比较/环境/编码等函数族
- 数值函数：26个函数支持状态；MOD/REMAINDER/ROUND/TANH返回类型差异
- 字符函数：CHR/LOWER/LTRIM/NCHR/NLS_LOWER/NLS_UPPER/REGEXP_REPLACE差异
- 日期时间函数：ADD_MONTHS/SYSDATE/EXTRACT/ROUND差异
- 转换函数：TO_DATE（多语种/返回类型/j格式/无分隔符差异）、TO_NUMBER（$不支持/逗号规则）、TO_NCHAR/TO_BINARY_*
- 通用比较：GREATEST/LEAST（NLS_SORT不支持）
- 环境函数：SYS_CONTEXT/SYS_GUID/UID/USER/USERENV差异
- 编码函数：UNISTR返回类型差异

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_183_oq_runtime` | MOD/REMAINDER/ROUND返回类型差异在复杂表达式中的级联影响、LOWER隐式时间转换在mapping_date_to_datea开启后的行为、TO_DATE无分隔符解析与NLS参数交互、REGEXP_REPLACE 'n'选项多行匹配差异需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_183_v1.yaml
generated/core_sql_reference_wave8_183_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_183.py
python scripts/build_core_sql_reference_wave8_183.py --check
python -m unittest tests.test_core_sql_reference_wave8_183 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
