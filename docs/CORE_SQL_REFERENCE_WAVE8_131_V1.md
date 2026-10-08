# SQL Reference Wave 8-131 Extraction V1

## 目标

抽取 M 兼容 2.x 收官批：`类型转换`、`表达式` 与 `注释`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 24 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- 四种SQL结构（函数调用/操作符/值存储/UNION、EXCEPT、CASE）与三种转换场景
- 隐式转换值存储三步解析（准确匹配/直接转换/长度转换atttypmod）
- 显式CAST全type清单（表2-86）、JSON显式转换行为表2-87、双冒号语法不建议
- UNSIGNED溢出转SIGNED边界基线（9223372036854775808→-9223372036854775808）
- UNION去重/UNION ALL、EXCEPT同UNION解析算法
- 表达式六小节（简单/条件/子查询/行/时间间隔/ODBC转义）
- BETWEEN复杂类型不一致基线、EXISTS短路执行、IN的NULL规则与s2前向兼容
- 注释：--单行（forbid_none_space_comment空格要求）、注释优先级低于引号

## Open questions

| ID | 内容 |
|---|---|
| `m_conv_expr_wave8_131_oq_runtime` | M兼容CAST边界值溢出的WARNING与截断规则在DECIMAL/DOUBLE组合下的完整行为、BETWEEN复杂类型与比较表达式结果不一致的判定路径、forbid_none_space_comment对存量SQL的兼容影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_131_v1.yaml
generated/core_sql_reference_wave8_131_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_131.py
python scripts/build_core_sql_reference_wave8_131.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_131.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容类型转换/表达式语句。
