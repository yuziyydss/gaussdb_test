# Core Corruption Detection/Repair Wave 7-7 Extraction V1

## 目标

细抽 `1.6.41 数据损坏检测修复函数`，覆盖文件丢失、页面坏块、Undo Zone、UBTree回收队列以及表/索引一致性检测修复。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 931–951，共21页 |
| 结构化 facts | 27 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 27 / 27 |

## 覆盖内容

### 文件与页面检测修复

- `gs_verify_data_file`
- `gs_repair_file`
- `local_bad_block_info`
- `local_clear_bad_block_info`
- `gs_verify_and_tryrepair_page`
- `gs_repair_page`
- `gs_seg_verify_datafile`
- `gs_edit_page_bypath`
- `gs_repair_page_bypath`
- `gs_edit_repair_page`
- `gs_get_standby_bad_block_info`

关键边界：

- 仅支持有正常主备连接的主DN修复文件或页面。
- 临界区内访问损坏页面会触发PANIC，不支持自动修复。
- 文件大小为0时不修复，需要先删除后再修复。
- `gs_verify_and_tryrepair_page`只修复内存页面，物理修复需等内存页落盘后完成。
- 段页式文件共用存储，部分丢段/未生成文件的校验结果有特殊边界。
- 备机坏块类型包括`NOT_PRESENT`、`NOT_INITIALIZED`、`LSN_CHECK_ERROR`和`CRC_CHECK_ERROR`。

### Undo与UBTree回收队列

- `gs_repair_undo_byzone`
- `gs_verify_urq`
- `gs_urq_dump_stat`
- `gs_repair_urq`

关键边界：

- Undo修复按zone_id执行；zone被活跃线程占用时会强制结束占用线程。
- UBTree回收队列仅支持USTORE索引表。
- `gs_repair_urq`为有损重建，删除并重建空回收队列文件。
- `gs_urq_dump_stat`输出回收队列详细统计。

### 表/索引一致性校验

- `gs_check_table`
- `gs_check_index`
- `gs_inconsistency_info`

关键边界：

- 支持Astore/Ustore表和B-tree/UB-tree索引一致性校验。
- 错误码0表示未发现一致性问题；非0需联系工程师定位。
- 校验模式支持`increment`和`full`；断点续做信息不持久化，进程重启后丢失。
- 默认低优先级IO流控；仅初始用户、系统管理员、运维管理员或监控管理员可执行。
- 属于高危操作，建议业务低峰期并保证数据尽量静态。

## Open questions

| ID | 内容 |
|---|---|
| `corruption_wave7_7_oq_repair_matrix` | 文件/页面/Undo/回收队列修复在不同主备状态、段页式、压缩表、并发临界区和异常中断下的行为矩阵 |
| `corruption_wave7_7_oq_check_evidence` | 表/索引一致性校验在Astore/Ustore、B-tree/UB-tree、增量/全量校验、断点续做和高负载下的一致性与性能影响 |

## 产物

```text
docs/compat_facts/core_corruption_wave7_7_v1.yaml
generated/core_corruption_wave7_7_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_corruption_wave7_7.py
python scripts/build_core_corruption_wave7_7.py --check
python -m pytest -q tests/test_core_corruption_wave7_7.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不校验或修复文件/页面、不重建回收队列、不执行表/索引一致性校验。
- 不宣称目标环境行为验证通过。
