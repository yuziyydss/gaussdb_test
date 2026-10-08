# SQL Reference Wave 8-64 Extraction V1

## 目标

合并抽取 R 段前部：`REASSIGN OWNED` 属主变更与 `REFRESH INCREMENTAL/REFRESH MATERIALIZED/REFRESH SYSTEM OBJECT` 刷新族。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.18.1` | 2 | REASSIGN OWNED |
| `1.13.18.2` | 2 | REFRESH INCREMENTAL MATERIALIZED VIEW |
| `1.13.18.3` | 2 | REFRESH MATERIALIZED VIEW |
| `1.13.18.4` | 2 | REFRESH SYSTEM OBJECT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- REASSIGN OWNED用途与删除角色前准备、语法与角色名
- 原角色+目标角色权限要求；仅初始用户可改为初始化用户
- test_jim/test_tom行为基线与DROP USER CASCADE清理
- 增量刷新仅支持增量物化视图；基表SELECT权限
- 全量刷新对全量与增量物化视图均可用
- REFRESH INCREMENTAL/REFRESH MATERIALIZED语法与mv_name
- ASTORE表示例与DROP清理闭环
- REFRESH SYSTEM OBJECT写入GS_SYSTEM_OBJECTS_VERSION
- 内部语法、507.0之前升级调用、upgrade_mode不为0、仅初始用户

## Open questions

| ID | 内容 |
|---|---|
| `refresh_sysobj_wave8_64_oq_runtime` | REASSIGN OWNED权限传递、增量/全量物化视图刷新一致性以及REFRESH SYSTEM OBJECT升级流程中的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_64_v1.yaml
generated/core_sql_reference_wave8_64_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_64.py
python scripts/build_core_sql_reference_wave8_64.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_64.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行属主/刷新语句。
