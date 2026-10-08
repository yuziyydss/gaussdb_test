# SQL Reference Wave 8-117 Extraction V1

## 目标

抽取 M 兼容 `PREPARE`、`PURGE`、`REINDEX`、`RENAME TABLE` 与 `RESET`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- PREPARE会话级生命周期（回滚不删除/DEALLOCATE显式删）、17类可预备语句清单（M兼容特有含DDL/COMMIT/ANALYZE）
- PURGE三形式权限矩阵、enable_recyclebin/recyclebin_retention_time前提、gs_recyclebin四级回收基线
- REINDEX三类触发场景、五种类型语义（TOAST/unusable限制）、DATABASE/SYSTEM禁事务块
- CONCURRENTLY全机制（ShareUpdateExclusiveLock、禁系统表/INVALID/PCR/二级分区GSI、失败自动清理_ccnew、死锁场景、Astore两次扫描/Ustore一次扫描+cctmp临时表）
- lpi_parallel_method并行限制
- RENAME TABLE多表改名（TABLE/TABLES互通）
- RESET仅支持ALL（role/session authorization不恢复）

## Open questions

| ID | 内容 |
|---|---|
| `m_ppr_wave8_117_oq_runtime` | PREPARE支持的DDL语句在事务回滚后的实际存活边界、PURGE与recyclebin_retention_time的竞态、REINDEX CONCURRENTLY死锁的复现条件需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_117_v1.yaml
generated/core_sql_reference_wave8_117_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_117.py
python scripts/build_core_sql_reference_wave8_117.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_117.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容PREPARE/PURGE/REINDEX语句。
