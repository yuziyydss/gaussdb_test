# SQL Reference Wave 8-73 Extraction V1

## 目标

抽取 `VACUUM` 空间回收（含在线VACUUM FULL）与 `VALUES` 常数表，完成 V 段及 `1.13` SQL 语法叶子章节收尾。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.22.1` | 6 | VACUUM |
| `1.13.22.2` | 2 | VALUES |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- VACUUM用途、表范围、权限矩阵（所有者/VACUUM权限/库所有者/跳过无权限表）
- 事务块禁止与每日清理建议
- FULL基础语义（重建表、段页式/非段页式空间归还、统计信息丢失）
- FULL限制（排他锁、死锁、系统表跳过、DELETE后延迟回收、与读写并发对比、Ustore AUTOVACUUM差异）
- VERBOSE/括号顺序/vacuum_defer_cleanup_age/IO延迟
- VACUUM ANALYZE组合、FREEZE、ANALYZE统计
- 在线VACUUM FULL：ONLINE/OFFLINE、不支持场景、M库排除、事务/存储过程禁止、磁盘预留、膨胀/长事务/阻塞、online$$ddl$$模式、失败残留清理
- 分区表GPI重建与取消/资源争抢
- 四种语法与FREEZE BUCKETS暂不支持
- column_name/partition/subpartition参数
- parallel_threads/max_catchup_times在线参数
- behavior oracle：ctid复用、VACUUM FULL 3048kB→0 bytes、ONLINE
- VALUES用途、大结果行限制、IN LIST vs IN VALUES LIST三类差异
- 语法与参数（DEFAULT仅INSERT顶层、FETCH count缺省1）
- 多行插入与分页行为基线

## Open questions

| ID | 内容 |
|---|---|
| `vacuum_wave8_73_oq_runtime` | VACUUM（含FULL/ONLINE失败清理路径）与VALUES派生表在真实存储引擎、并发DML和资源管控组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_73_v1.yaml
generated/core_sql_reference_wave8_73_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_73.py
python scripts/build_core_sql_reference_wave8_73.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_73.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行VACUUM/VALUES语句。
