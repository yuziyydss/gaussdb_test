# SQL Reference Wave 8-39 Extraction V1

## 目标

抽取 `1.13.9.56 CREATE TRIGGER`，补齐触发器创建语法、触发时机、事件、条件表达式、匿名块和特殊变量能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.56` | 8 | CREATE TRIGGER |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 触发器用途、普通行存表/视图支持和命名触发顺序
- 性能边界、创建者权限判断和TRIGGER权限
- BEFORE/AFTER/INSTEAD OF返回值与OLD/NEW语义
- 重载函数隐式变量、MERGE INTO和REPLACE INTO触发限制
- 主语法、OR REPLACE、CONSTRAINT触发器
- 名称、事件、UPDATE OF和生成列触发
- 引用表、DEFERRABLE、INITIALLY时机
- ROW/STATEMENT、WHEN条件、匿名块和执行函数
- 表/视图支持的触发器种类矩阵
- plpgsql触发器特殊变量

## Open questions

| ID | 内容 |
|---|---|
| `trig_wave8_39_oq_runtime` | CREATE TRIGGER在真实表/视图、BEFORE/AFTER/INSTEAD OF、约束触发器、MERGE/REPLACE INTO和匿名块组合下的触发顺序与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_39_v1.yaml
generated/core_sql_reference_wave8_39_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_39.py
python scripts/build_core_sql_reference_wave8_39.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_39.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE TRIGGER或DDL。
