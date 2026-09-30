# Core System Management Wave 2B-14 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.17 其它函数（第五批：空间/膨胀率估算与备机WAL接收写入统计）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 788–795，共8页 |
| 结构化 facts | 13 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 13 / 13 |

## 覆盖内容

### gs_stat_freespace

- 通过统计信息或采样估算表、分区表、索引的膨胀率。
- 输出空间使用统计信息和膨胀率信息。

关键边界：

- `relation_type='r'`表示行存数据表，`'i'`表示行存索引表。
- `sample_ratio=0`使用统计信息估算；`1`到`100`使用采样估算。
- `read_memory`当前暂时只支持`false`。
- 分区表、二级分区表或LOCAL分区索引的`partition_oid=0`时输出所有分区信息。
- 当前仅支持行存表；不支持时序表、段页式表、hashbucket表、本地临时表和全局临时表。
- 对不支持表类型的索引同样不支持空间统计估算。
- 备机上`sample_ratio=0`的统计信息估算无法保证实时准确率。
- `sample_ratio`超出0到100时报错。
- 目标不是普通relation或toast relation时报错。

### gs_walrcv_writer_stat

- 统计备机接收WAL日志write与sync的次数频率、数据量以及Xlog文件信息。

关键边界：

- `operation=-1`关闭统计开关，默认状态为关闭。
- `operation=0/1/2`分别打开、查询和重置统计。
- 关闭统计开关后重新打开时，会清理之前的统计信息。
- 输出包括写入总量、写入次数、write/sync时间、平均写入字节数、当前与最新Xlog段文件编号和统计起止时间。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b14_oq_freespace_matrix` | `gs_stat_freespace`在普通表、分区表、分区索引、不同`sample_ratio`、备机和各类不支持对象上的输出与错误矩阵 |
| `wave2b14_oq_walrcv_writer_evidence` | `gs_walrcv_writer_stat`在统计开关关闭/打开/查询/重置、真实WAL负载和主备环境下的行为与统计准确性 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b14_v1.yaml
generated/core_system_admin_wave2b14_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b14.py
python scripts/build_core_system_admin_wave2b14.py --check
python -m pytest -q tests/test_core_system_admin_wave2b14.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行空间膨胀率采样、WAL接收统计开关、统计重置或备机状态查询。
- 不宣称目标环境行为验证通过。
