# SQL Reference Wave 8-177 Extraction V1

## 目标

抽取 小节收编批：`1.1 GaussDB SQL`、`1.4.1-1.4.7 字符集和字符序`（7节）、`4.1 修订记录`、`4.2 GaussDB数据库兼容性概述`、`4.4.1 MySQL数据库兼容性概述`、`5.1 工具参考简介`（页 50–3576 共11节）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- 1.1 GaussDB SQL：SQL定义五类任务、SQL发展简史1986-2019、GaussDB支持SQL:2016
- 1.4 字符集和字符序：客户端连接转换流程与5个系统参数、数据库级CREATE DATABASE语法、模式/表/列级继承链、表达式合并优先级、合并规则
- 4.1/4.2 兼容性说明章节结构与概述
- 4.4.1 MySQL兼容性概述：Database/Schema映射差异、INDEX从属差异、对象层次一对多包含关系
- 5.1 工具参考：角色分类（客户端/服务端）与场景分类（10类工具）

## Open questions

| ID | 内容 |
|---|---|
| `misc_wave8_177_oq_runtime` | 字符集合并规则在多层级混用场景下的优先级判定、SQL_ASCII数据库中DBE_XMLDOM等高级包的兼容性表现、MySQL兼容性M-Compatibility模式与B模式的Schema映射差异对应用迁移的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_177_v1.yaml
generated/core_sql_reference_wave8_177_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_177.py
python scripts/build_core_sql_reference_wave8_177.py --check
python -m unittest tests.test_core_sql_reference_wave8_177 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
