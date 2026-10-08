# SQL Reference Wave 8-40 Extraction V1

## 目标

合并抽取 `ALTER TRIGGER` 与 `DROP TRIGGER`，补齐触发器重命名、属主变更、删除、依赖处理和禁用能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.42` | 2 | ALTER TRIGGER |
| `1.13.10.45` | 5 | DROP TRIGGER |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- ALTER TRIGGER用途、权限和三权分立约束
- 触发器重命名与OWNER变更语法
- 新名称唯一性/长度、新属主和初始化用户限制
- ALTER TRIGGER示例与生命周期链路
- DROP TRIGGER权限、IF EXISTS、CASCADE/RESTRICT
- 匿名块隐式函数随触发器删除
- 单个触发器禁用与所有触发器禁用

## Open questions

| ID | 内容 |
|---|---|
| `trig_wave8_40_oq_runtime` | ALTER/DROP TRIGGER在真实权限、依赖对象、匿名块隐式函数和禁用触发器组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_40_v1.yaml
generated/core_sql_reference_wave8_40_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_40.py
python scripts/build_core_sql_reference_wave8_40.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_40.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER/DROP TRIGGER或DDL。
