# Core System Management Wave 2B-7 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.12 hashbucket系统函数
1.6.27.13 Undo系统函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 696–714，共19页 |
| 结构化 facts | 28 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 28 / 28 |

## 覆盖内容

### hashbucket系统函数

覆盖迁移 / 重分布相关函数：

- `gs_redis_get_plan`
- `gs_redis_get_bucket_statistics`
- `gs_redis_set_distributed_db`
- `gs_redis_hashbucket_update_segment_header`
- `gs_redis_local_get_segment_header`
- `gs_redis_local_update_segment_header`
- `gs_redis_hashbucket_update_inverse_pointer`
- `gs_redis_local_get_inverse_pointer`
- `gs_redis_local_update_inverse_pointer`
- `gs_redis_local_set_hashbucket_frozenxid`
- `gs_redis_set_hashbucket_frozenxid`
- `gs_redis_set_nextxid`
- `gs_redis_set_csn`
- `gs_redis_check_bucket_flush`
- `gs_redis_get_flush_page_lsn`
- `gs_redis_show_bucketxid`
- `gs_redis_drop_bucket_files`
- `gs_redis_local_drop_bucket_files`

关键边界：

- 文档中所有hashbucket重分布 / header / 反向指针 / frozenxid / nextxid / CSN / 刷页 / 文件清理函数当前版本均标注“暂不支持”。

### Undo系统函数

- 回滚段存储方式：通过`gs_global_config.undostoragetype`确认；`page`为页式，`segpage`为预留且暂不支持。
- 元信息与事务槽：
  - `gs_undo_meta`
  - `gs_undo_translot`
  - `gs_undo_meta_dump_zone`
  - `gs_undo_meta_dump_spaces`
  - `gs_undo_meta_dump_slot`
  - `gs_undo_translot_dump_slot`
  - `gs_undo_translot_dump_xid`
- Undo记录解析：
  - `gs_undo_record`
  - `gs_undo_dump_record`
  - `gs_undo_dump_xid`
  - `gs_undo_dump_parsepage_mv`
- 校验函数：
  - `gs_verify_undo_record`
  - `gs_verify_undo_slot`
  - `gs_verify_undo_meta`
- 监控函数：
  - `gs_stat_undo`
  - `gs_async_rollback_worker_status`
  - `gs_async_rollback_xact_status`
  - `gs_undo_recycler_status`
  - `gs_undo_launcher_status`

关键状态：

- Undo事务槽状态：
  - 0：已提交
  - 1：正在执行中
  - 2：回滚中
  - 3：回滚完成

关键边界：

- `gs_undo_meta`仅支持页式存储。
- `gs_undo_dump_parsepage_mv`需系统管理员或运维管理人员。
- verify系列函数目前只支持磁盘校验模式，且仅支持业务非运行时离线执行。
- PDB环境下部分监控函数返回空或仅返回本PDB数据。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b7_oq_hashbucket_unsupported_matrix` | hashbucket函数在不同目标版本下的实际报错 / 返回边界 |
| `wave2b7_oq_undo_offline_matrix` | Undo dump / verify在页式 / 段页式、内存 / 磁盘、PDB和运行状态下的矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b7_v1.yaml
generated/core_system_admin_wave2b7_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b7.py
python scripts/build_core_system_admin_wave2b7.py --check
python -m pytest -q tests/test_core_system_admin_wave2b7.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行hashbucket迁移 / 重分布函数。
- 不执行Undo dump / verify或监控函数。
- 不宣称目标环境行为验证通过。
