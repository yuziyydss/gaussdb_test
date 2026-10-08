# SQL Reference Wave 8-121 Extraction V1

## 目标

抽取 M 兼容 2.5 函数与操作符第一批：`操作符概述`、`逻辑操作符`、`位运算操作符` 与 `模式匹配操作符`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 14 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- 表2-35操作符全集（逻辑/位/模式匹配/比较/算术/类型转换六类，含<=>NULL安全等于、BETWEEN AND三元、DIV/MOD）
- 表2-36九大类操作数类型
- 逻辑四操作符（!优先级高于NOT、交换性）与NOT/AND/OR/XOR完整真值表
- 逻辑运算类型提升归类（XOR/整型→BIGINT、其他→DOUBLE）
- 位运算六操作符与优先级链
- LIKE规则六条（整串匹配/_%/逃逸字符/~~!~~等价/字符序大小写）与四组示例
- REGEXP正则语法（^$.?*+|{}[]）、等价类、字符类12种、[.characters.]字符名表
- 转义字符串开关on/off两套转义表与多字节警告

## Open questions

| ID | 内容 |
|---|---|
| `m_op_match_wave8_121_oq_runtime` | M兼容<=>NULL安全等于与IS的优先级组合、REGEXP字符类在多字节字符下的匹配行为、转义字符串开关切换对存量数据的兼容性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_121_v1.yaml
generated/core_sql_reference_wave8_121_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_121.py
python scripts/build_core_sql_reference_wave8_121.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_121.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容操作符语句。
