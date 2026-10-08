# SQL Reference Wave 8-68 Extraction V1

## 目标

抽取 `SET` 七种语法形式与 `SET CONSTRAINTS` 约束检查时机。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.19.5` | 5 | SET |
| `1.13.19.6` | 2 | SET CONSTRAINTS |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- SET用途与运行时可修改边界
- SESSION/LOCAL作用域与SET LOCAL特例
- TIME ZONE（缺省PRC、B模式时分写法限制）
- CURRENT_SCHEMA/SCHEMA
- NAMES字符集与COLLATE（5.7 s2、四参数等价）
- config_parameter取值、SHOW ALL例外、value形式
- B模式@@SESSION/@@变量、pg_settings.context
- 自定义用户变量：门槛、命名、未初始化NULL、连续赋值、存储类型转换、prepare限制
- expr敏感函数警告
- XML OPTION DOCUMENT/CONTENT
- 七种语法汇总
- 自定义变量与通用示例行为基线
- SET CONSTRAINTS IMMEDIATE/DEFERRED、三种约束特性、ALL/名称列表、改IMMEDIATE即检失败回退
- 事务块外无效
- 语法/参数/示例

## Open questions

| ID | 内容 |
|---|---|
| `set_wave8_68_oq_runtime` | SET各作用域（SESSION/LOCAL/@变量）与SET CONSTRAINTS推迟检查在真实事务、兼容模式和GUC参数组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_68_v1.yaml
generated/core_sql_reference_wave8_68_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_68.py
python scripts/build_core_sql_reference_wave8_68.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_68.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行SET语句。
