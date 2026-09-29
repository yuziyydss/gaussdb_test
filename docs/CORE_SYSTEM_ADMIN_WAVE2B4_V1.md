# Core System Management Wave 2B-4 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.9 咨询锁函数
1.6.27.10 逻辑复制函数（槽管理与文本/二进制decode基础）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 627–642，共16页 |
| 结构化 facts | 28 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 28 / 28 |

## 覆盖内容

### 咨询锁函数

- 会话级排他锁：`pg_advisory_lock`
- 会话级共享锁：`pg_advisory_lock_shared`
- 会话级释放：`pg_advisory_unlock`
- 会话级共享释放：`pg_advisory_unlock_shared`
- 全量释放：`pg_advisory_unlock_all`
- 事务级排他锁：`pg_advisory_xact_lock`
- 事务级共享锁：`pg_advisory_xact_lock_shared`
- 非阻塞尝试：`pg_try_advisory_lock`
- 非阻塞共享尝试：`pg_try_advisory_lock_shared`

关键语义：

- 键可用一个64位键或两个32位键。
- 排他锁阻塞等待；`try_*`不阻塞。
- 多次锁定会入栈，需要对应多次解锁。
- 事务级锁在事务结束自动释放，不能显式释放。
- `(65535,65535)`仅sysadmin可用。
- 会话结束时隐含调用`pg_advisory_unlock_all()`。

### 逻辑复制函数：槽管理与decode基础

前提：

```text
wal_level = logical
```

函数覆盖：

- `pg_create_logical_replication_slot`
- `pg_create_physical_replication_slot`
- `pg_drop_replication_slot`
- `pg_logical_slot_peek_changes`
- `pg_logical_slot_get_changes`
- `pg_logical_slot_peek_binary_changes`
- `pg_logical_slot_get_binary_changes`
- `pg_replication_slot_advance`

关键语义：

- `output_order=0`为LSN序复制槽。
- `output_order=1`为CSN序复制槽。
- CSN序仅分布式强一致解码使用。
- `peek_*`解码但不推进复制槽。
- `get_*`解码并推进复制槽。
- `pg_replication_slot_advance`直接推进槽位，不输出结果。
- 需要SYSADMIN / REPLICATION权限或`gs_role_replication`。
- non-PDB和PDB对复制槽的操作范围不同。
- `gs_roach`开头的复制槽名保留给内部备份工具。

### 解码选项

覆盖：

- `include-xids`
- `skip-empty-xacts`
- `include-timestamp`
- `only-urls`
- `exclude-users`
- `dynamic-resolution`
- `restart-lsn`
- `decode-sequence`
- `enable-decode-position`
- `enable-rowno`

关键限制：

- `decode-sequence`当前仅允许`false`，`true`会启动报错。
- 某些选项只可配置而不实际生效。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b4_oq_advisory_lock_concurrency_matrix` | 会话/事务、排他/共享、try/blocking和多会话栈行为的并发矩阵 |
| `wave2b4_oq_logical_decode_option_matrix` | 不同插件和复制槽类型下的解码选项、输出格式和权限矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b4_v1.yaml
generated/core_system_admin_wave2b4_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b4.py
python scripts/build_core_system_admin_wave2b4.py --check
python -m pytest -q tests/test_core_system_admin_wave2b4.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行咨询锁或逻辑复制函数。
- 不宣称目标环境行为验证通过。
- `1.6.27.10`剩余的并行解码、replication origin、SQL apply、逻辑字典等子族后续抽取。
