# Core System Management Wave 2B-9 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.16 NVMe系统函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 738–746，共9页 |
| 结构化 facts | 11 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 11 / 11 |

## 覆盖内容

### NVMe系统函数

- `gs_candidate_slots_stat`
- `gs_nvme_queue_stat`
- `gs_nvme_hit_ratio`
- `gs_nvme_page`
- `gs_nvme_shm_header`
- `gs_nvme_thread_status`
- `gs_nvme_heat_map_status`
- `gs_check_segment_table`
- `gs_nvme_spdk_stat`

关键边界：

- `gs_check_segment_table`用于开启大容量NVMe缓存优化前的检查；`SUCCESS`表示当前库不存在段页式表，`FAILED`表示存在。
- 除`gs_check_segment_table`的开启前检查用途外，其余NVMe系统函数仅支持启用NVMe缓存后使用。
- `gs_nvme_heat_map_status`的`range`支持`0、3、4、5、10、20、30、40、-1`；`-1`表示`MAX_HEAT`。
- `gs_nvme_page`支持查询页面状态或解析页面并输出存放路径，覆盖heap、uheap、btree、ubtree等表类型。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b9_oq_nvme_page_matrix` | `gs_nvme_page`在不同relation / fork / block / parse参数和表类型下的输出矩阵 |
| `wave2b9_oq_nvme_metrics_baseline` | NVMe队列、命中率、热度分布和SPDK统计需开启NVMe后的基线与压力场景验证 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b9_v1.yaml
generated/core_system_admin_wave2b9_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b9.py
python scripts/build_core_system_admin_wave2b9.py --check
python -m pytest -q tests/test_core_system_admin_wave2b9.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行NVMe状态查询、页面解析或缓存开启前检查。
- 不宣称目标环境行为验证通过。
