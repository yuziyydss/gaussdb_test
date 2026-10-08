# SQL Reference Wave 8-102 Extraction V1

## 目标

抽取 M 兼容章开头批：`SQL简介`、`关键字`、`字符集与字符序`、`库级字符集和字符序` 与 `标识符说明`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `2.1` | 2 | SQL简介 |
| `2.2` | 30 | 关键字 |
| `2.3` | 4 | 字符集与字符序 |
| `2.3.2` | 2 | 库级字符集和字符序 |
| `2.4.1` | 2 | 标识符说明 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 42 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- SQL定位、五类任务、GaussDB默认支持SQL:2016大部分特性
- 关键字四分类（保留/非保留/保留（可以是函数或类型）/非保留（不能是函数或类型））
- 非保留关键字作变量名限制（BEGIN/CURSOR/DECLARE等22词）
- 不能直接作列别名的关键字清单（类型词+JOIN等）
- 七种字符集及默认字符序、binary经SQL_ASCII实现、名称字母数字匹配
- 十六种字符序及空白填充差异、UCA排序
- CREATE/ALTER DATABASE|SCHEMA的CHARSET/COLLATE四写法
- 字符集字符序四条选择规则与server_encoding缺省
- 标识符引号规则（反引号默认、ANSI_QUOTES双引号）、无引号字符集、U+0000/U+10000限制
- lower_case_table_names=0/1大小写敏感矩阵、列名存储与比较差异

## Open questions

| ID | 内容 |
|---|---|
| `mcompat_intro_wave8_102_oq_runtime` | 多字符集混用在SQL_ASCII外字符集库中的转码边界、utf8_unicode_ci与0900_ai_ci排序差异、关键字在存储过程与预编译语句中的实际可用性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_102_v1.yaml
generated/core_sql_reference_wave8_102_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_102.py
python scripts/build_core_sql_reference_wave8_102.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_102.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行关键字/字符集相关语句。
