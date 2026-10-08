# SQL Reference Wave 8-70 Extraction V1

## 目标

抽取 `SHOW` 运行时参数查询、`SHOW EVENTS` 定时任务查询与 `SHUTDOWN` 节点关闭。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.19.10` | 3 | SHOW |
| `1.13.19.11` | 2 | SHOW EVENTS |
| `1.13.19.12` | 2 | SHUTDOWN |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- SHOW语法与特殊目标（CURRENT_SCHEMA/TIME ZONE/隔离级别/SESSION AUTHORIZATION/ALL）
- SHOW ALL例外参数（max_datanodes）
- SHOW VARIABLES LIKE模式匹配
- 行为基线：timezone/PRC、current_schema、read committed、omm1、ALL/LIKE
- SHOW EVENTS用途与B模式限制
- FROM/IN、LIKE、WHERE子句语义
- 定时任务字段与跨schema查询行为基线
- SHUTDOWN用途与管理员权限
- FAST/IMMEDIATE语义与缺省FAST
- 关闭行为基线

## Open questions

| ID | 内容 |
|---|---|
| `show_wave8_70_oq_runtime` | SHOW EVENTS定时任务查询、SHUTDOWN各关闭模式在真实B模式环境、权限和集群状态下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_70_v1.yaml
generated/core_sql_reference_wave8_70_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_70.py
python scripts/build_core_sql_reference_wave8_70.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_70.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行SHOW/SHUTDOWN语句。
