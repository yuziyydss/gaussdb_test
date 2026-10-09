# SQL Reference Wave 8-190 Extraction V1

## 目标

抽取 MySQL兼容M模式操作符：`4.4.2.3 操作符`（操作符差异/操作符表4-155/操作符组合差异表4-156/索引差异表4-157，页 3379–3397）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 18 |
| 结构化 facts | 28 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 操作符差异概述：ORDER BY NULL排序差异、NULL显示差异、字符串转double非法字符串告警差异、比较返回1/0 vs t/f、含NULL列与不可转换常量比较差异
- 表4-155操作符差异：<> / <=>索引差异、行表达式差异（<=>行比较/IS NULL/ISNULL/ROW单列）、`--`取反vs注释（forbid_none_space_comment）、`!!`阶乘vs取非、[NOT] REGEXP（元字符/\\b/转义/右单括号/|空值/[:blank:]/非贪婪/BINARY字符集）、LIKE操作数限制与JDBC setFloat PBE差异、[NOT] BETWEEN AND（结合方向/操作数限制/between_and_independent_compare/repeat()特殊场景）、IN（操作数限制/ROW IN/精度传递FLOAT/DOUBLE/多列IN）、`!`操作数限制、`#`注释、BINARY关键字优先级、取负(-)类型精度（enable_precision_decimal）、`/**/`注释、xor常数优化、IS NULL优先级、短路求值差异（AND/OR/XOR/比较/位运算）、+,-,*,/,% mod div内嵌b''常量unsigned标识
- 表4-156操作符组合差异：LIKE位运算/算术运算组合、BETWEEN嵌套结合方向、BETWEEN比较/模式匹配/IN组合、IN嵌套、!NOT组合等MySQL不支持而GaussDB支持的场景
- 索引差异：仅支持UBTree/B-tree、B-tree/UBTree操作符族索引扫描、YEAR类型JDBC PBE无法利用索引、LIKE前缀索引最大长度2676 vs 3072、索引支持差异矩阵（表4-157：BIT/SET/ENUM/TIME/YEAR/带日期时间/整型/二进制/定点/浮点/字符串索引字段与各常量类型组合）、整型索引字段与定点型常量索引支持条件（disable_int_cmp_num_index/非用户变量/非CASE WHEN/非子查询）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_190_oq_runtime` | 操作符短路求值/索引支持矩阵/YEAR类型PBE索引等差异的完整影响范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_190_v1.yaml
generated/core_sql_reference_wave8_190_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_190.py
python scripts/build_core_sql_reference_wave8_190.py --check
python -m unittest tests.test_core_sql_reference_wave8_190 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
