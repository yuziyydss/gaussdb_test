# SQL Reference Wave 8-52 Extraction V1

## 目标

合并抽取 `CREATE RESOURCE POOL`、`ALTER RESOURCE POOL` 与 `DROP RESOURCE POOL`，完成资源池生命周期闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.39` | 4 | CREATE RESOURCE POOL |
| `1.13.7.26` | 3 | ALTER RESOURCE POOL |
| `1.13.10.32` | 2 | DROP RESOURCE POOL |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CREATE RESOURCE POOL权限、升级/多租限制和主语法
- 控制组名称、层次与Timeshare组
- `ACTIVE_STATEMENTS`、`MAX_DOP`、内存和内存比例
- `io_limits`、`io_priority`及其复杂作业边界
- `max_worker`、`max_connections`、动态/共享内存和并发数
- 默认资源池控制组行为
- ALTER RESOURCE POOL权限与`WITH (...)`语法
- 控制组和资源池存在性约束
- DROP RESOURCE POOL权限、角色关联限制和`IF EXISTS`

## Open questions

| ID | 内容 |
|---|---|
| `respool_wave8_52_oq_runtime` | CREATE/ALTER/DROP RESOURCE POOL在真实控制组、多租配置、并发负载和角色关联组合下的资源管控与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_52_v1.yaml
generated/core_sql_reference_wave8_52_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_52.py
python scripts/build_core_sql_reference_wave8_52.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_52.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE/ALTER/DROP RESOURCE POOL。
