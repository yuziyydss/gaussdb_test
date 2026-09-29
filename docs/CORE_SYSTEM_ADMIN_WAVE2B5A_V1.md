# Core System Management Wave 2B-5A Extraction V1

## 目标

继续细抽 `1.6.27.10 逻辑复制函数` 的剩余部分。Wave 2B-5A 覆盖 area changes、复制槽列表、并行解码状态 / 参数 / 重置、性能观测和线程信息。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 641–661，共21页 |
| 结构化 facts | 21 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 21 / 21 |

## 覆盖内容

### Area changes 解码

- `pg_logical_get_area_changes(start_lsn,upto_lsn,upto_nchanges,decoding_plugin,xlog_path,options)`
- 按 LSN 区间或指定 Xlog 文件解码
- 返回 `text,xid,text`

关键约束：

- 要求 `wal_level=logical`
- 单条元组建议不超过 500MB；500MB~1GB会报错
- 不支持不落 Xlog 的数据页复制日志解码
- 不支持 VACUUM FULL 之前日志解码
- 不能解码扩容前 Xlog
- 一次解码建议约一个 Xlog 文件，粗估内存为 Xlog 文件大小2~3倍
- `enable-ddl`关闭时检测到 DDL会对所有表不解码，且不支持 toast/clob/blob
- `enable-ddl`打开时支持 DDL 解码
- UPDATE / DELETE 需要 `REPLICA IDENTITY`

### 复制槽与状态

- `pg_get_replication_slots`
- `gs_get_parallel_decode_status`
- `gs_get_slot_decoded_wal_time`
- `gs_get_logical_decode_parameter`
- `gs_logical_parallel_decode_status`
- `gs_logical_parallel_decode_reset_status`
- `gs_get_parallel_decode_thread_info`

### 性能观测

- `gs_logical_decode_start_observe`
- `gs_logical_decode_stop_observe`
- `gs_logical_decode_observe_data`
- `gs_logical_decode_observe`
- `gs_logical_decode_observe_status`

指标包括：

- `logical_decode_rate`
- `wal_read_rate`
- `parser_rate`
- `decoder_rate`
- `sender_rate`
- `net_send_rate`

## PDB / Non-PDB 边界

- non-PDB 通常可查询全部或 Non-PDB + PDB 信息
- PDB 仅查询本 PDB
- reset / observe 操作的范围也遵循同样边界

## Open questions

| ID | 内容 |
|---|---|
| `wave2b5a_oq_area_changes_matrix` | area changes 在 DDL、TOAST、大元组、扩容前后和同构 DN 场景下的结果矩阵 |
| `wave2b5a_oq_parallel_decode_metrics` | 并行解码29项指标、重置行为和性能观测需不同并发规模与槽类型验证 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b5a_v1.yaml
generated/core_system_admin_wave2b5a_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b5a.py
python scripts/build_core_system_admin_wave2b5a.py --check
python -m pytest -q tests/test_core_system_admin_wave2b5a.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行逻辑复制或并行解码函数。
- 不宣称目标环境行为验证通过。
- replication origin、分布式解码、SQL apply 等后续子族留待 Wave 2B-5B。
