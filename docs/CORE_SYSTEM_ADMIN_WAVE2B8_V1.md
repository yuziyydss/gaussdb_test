# Core System Management Wave 2B-8 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.14 行存压缩系统函数
1.6.27.15 HTAP系统函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 715–737，共23页 |
| 结构化 facts | 17 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 17 / 17 |

## 覆盖内容

### 行存压缩系统函数

- `pg_get_ilmdef(pidx integer)`
- 按ILM策略序号返回策略信息，输出`ilm_policy_info`文本。

### HTAP系统函数

覆盖：

- `gs_htap_imcv_info`
- `gs_imcv_flush`
- `gs_htap_tmu_data`
- `gs_htap_tmu_chunk_meta`
- `gs_imcv_bgworker_status`
- `gs_htap_scan_hit_status`
- `gs_imcu_meta`
- `gs_imcv_status`
- `gs_htap_file_status`
- `gs_htap_data_maintenance`
- `gs_imcu_size_estimation`

关键边界：

- 通常需要`enable_htap=on`。
- 通常需要系统管理员或运维管理人员权限。
- `gs_imcv_flush`不允许在事务块内执行。
- 并行加载 / 重建会额外占用内存、CPU和I/O。
- `gs_htap_data_maintenance`仅作为卸载列存 / 落盘数据逃生手段，需谨慎使用。
- `gs_imcu_size_estimation`不支持备机执行。

### IMCU元信息

- 压缩方式：
  - `uncompressed`
  - `delta_plus_rle`
  - `lz4_compressed`
  - `dict_compressed`
- 元信息包含行数、空行、最大 / 最小值、求和值、内存 / 磁盘位置等。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b8_oq_htap_flush_matrix` | `gs_imcv_flush`在不同并行度、rebuild_mode、分区边界和事务块下的行为矩阵 |
| `wave2b8_oq_htap_maintenance_recovery` | `gs_htap_data_maintenance`卸载 / 落盘后的恢复、清理和状态变化 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b8_v1.yaml
generated/core_system_admin_wave2b8_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b8.py
python scripts/build_core_system_admin_wave2b8.py --check
python -m pytest -q tests/test_core_system_admin_wave2b8.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行HTAP刷新、维护或估算函数。
- 不宣称目标环境行为验证通过。
