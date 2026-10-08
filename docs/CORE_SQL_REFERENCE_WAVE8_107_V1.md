# SQL Reference Wave 8-107 Extraction V1

## 目标

抽取 M 兼容 `BEGIN`、`CLEAN CONNECTION`、`CHECKPOINT`、`COMMENT`、`COMMIT`、`CREATE AUDIT POLICY` 与 `CREATE DATABASE`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 7 |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 7 / 7 |
| chapter has facts | 7 / 7 |

## 覆盖能力

- BEGIN四种隔离级别（SERIALIZABLE等价REPEATABLE READ为M兼容特有）、第一个DML后禁改隔离级别
- CLEAN CONNECTION仅TO ALL、FORCE SIGTERM清理、CHECK用于DROP DATABASE前置检查
- CHECKPOINT系统管理员+运维管理员权限、gs_guc三参数调间隔
- COMMENT十二类对象、单注释覆盖语义、注释无安全机制警告、ROLE注释权限特例
- COMMIT创建者/系统管理员权限、跨会话提交
- M兼容审计策略（gs_auditing_policy*系统表、DDL/DML操作全集、IF NOT EXISTS、63字节命名）
- M兼容CREATE DATABASE=SCHEMA、pg_/gs_role_前缀禁用、初始用户重名禁用
- m_db示例基线（审计/连接清理/注释/事务）

## Open questions

| ID | 内容 |
|---|---|
| `m_bccc_wave8_107_oq_runtime` | M兼容SERIALIZABLE等价REPEATABLE READ的锁行为差异、CLEAN CONNECTION FORCE对长事务连接的清理边界、CHECKPOINT期间IO尖峰对业务影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_107_v1.yaml
generated/core_sql_reference_wave8_107_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_107.py
python scripts/build_core_sql_reference_wave8_107.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_107.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容事务/审计/建库语句。
