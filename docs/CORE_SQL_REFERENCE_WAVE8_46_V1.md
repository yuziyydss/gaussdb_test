# SQL Reference Wave 8-46 Extraction V1

## 目标

合并抽取 `DROP DATABASE` 与 `DROP TABLESPACE`，补齐数据库删除、库级回收站、PURGE语义和表空间删除边界。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.10` | 3 | DROP DATABASE |
| `1.13.10.42` | 2 | DROP TABLESPACE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- DROP DATABASE权限与保护数据库
- 活跃连接、事务块和失败重试行为
- 库级回收站开启/关闭与不可撤销边界
- `DROP DATABASE [IF EXISTS] ... [PURGE]`
- `gs_db_recyclebin`回收站与PURGE示例
- DROP TABLESPACE权限、空表空间约束
- 事务块限制与并发`\db`查询影响
- `DROP TABLESPACE [IF EXISTS]`

## Open questions

| ID | 内容 |
|---|---|
| `dropdbtbs_wave8_46_oq_runtime` | DROP DATABASE/DROP TABLESPACE在真实连接、事务、回收站和并发元命令组合下的删除结果与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_46_v1.yaml
generated/core_sql_reference_wave8_46_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_46.py
python scripts/build_core_sql_reference_wave8_46.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_46.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DROP DATABASE或DROP TABLESPACE。
