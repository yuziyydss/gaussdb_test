# Core System Management Wave 2B-6 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.11 段页式存储函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 674–695，共22页 |
| 结构化 facts | 25 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 25 / 25 |

## 覆盖内容

### 空间收缩

- `local_space_shrink(tablespacename,databasename)`
- `gs_space_shrink(tablespace,database,extent_type,forknum)`

关键边界：

- `local_space_shrink`目前只支持当前连接database。
- `extent_type`有效范围[2,5]；`1`表示段页式元数据，不支持收缩。
- `gs_space_shrink`仅限工具使用，不建议用户直接调用。

### 页面与位置诊断

- `gs_seg_dump_page`按tablespace/file/bucketnode/block或按relid/block解析页面
- `gs_seg_get_spc_location`按物理位置或relation查询空间位置
- `gs_seg_get_location`返回全局block id对应位置

关键边界：

- `gs_seg_dump_page`仅sysadmin或运维管理员可执行。
- 返回解析结构，不包含实际用户数据。

### 布局查询

- `gs_seg_get_segment_layout`
- `gs_seg_get_datafile_layout`
- `gs_seg_get_slice_layout`
- `gs_seg_get_segment`
- `gs_seg_get_extents`

覆盖段布局、1~5号数据文件布局、slice布局、段信息和扩展信息。

### 残留清理

- `gs_seg_free_spc_remain_segment`
- `gs_seg_auto_free_remain_segment`
- `gs_seg_free_spc_remain_extent`

关键边界：

- 同一节点同一database不允许并发运行多个残留清理操作。
- 在线清理需开启`enable_auto_segment_remain_cleanup=on`。
- offline方式是兜底或可靠保证，需谨慎执行。

### 数据文件与扩展查询

- `gs_seg_get_datafiles(database_name)`
- `gs_seg_get_spc_extents(...)`

关键边界：

- 仅管理员可查。
- contents包括permanent、unlogged、temporary、temporary2。
- 扩展页面类型包括segment head、fork head、level1 page和data extent。

## 枚举映射

### bucketnode

| 值 | 含义 |
|---:|---|
| 1024 | 段页式普通表 |
| 1025 | 段页式全局临时表 |
| 1026 | 段页式unlogged表 |
| 1027 | 段页式本地临时表 |

### forknum

| 值 | 含义 |
|---:|---|
| 0 | main fork |
| 1 | fsm fork |
| 2 | vm fork |

### extent type

| 文件号 | extent type |
|---:|---:|
| 1 | 1 |
| 2 | 8 |
| 3 | 128 |
| 4 | 1024 |
| 5 | 4096 |

## Open questions

| ID | 内容 |
|---|---|
| `wave2b6_oq_dump_page_permission_matrix` | `gs_seg_dump_page`在不同页面类型、forknum、bucketnode和PDB/Non-PDB下的输出 / 权限矩阵 |
| `wave2b6_oq_cleanup_concurrency` | 残留清理函数的并发限制、GUC开关和失败恢复行为 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b6_v1.yaml
generated/core_system_admin_wave2b6_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b6.py
python scripts/build_core_system_admin_wave2b6.py --check
python -m pytest -q tests/test_core_system_admin_wave2b6.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行段页式收缩、页面dump或残留清理函数。
- 不宣称目标环境行为验证通过。
