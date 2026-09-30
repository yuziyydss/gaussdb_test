# Core Internal, Cache and Recovery Wave 7-1 Extraction V1

## 目标

细抽3个内部与维护相关章节：

```text
1.6.39 内部函数
1.6.40 Global SysCache特性函数
1.6.42 Multixact回收函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 3 |
| 物理页并集 | 918–931与951–952，共16页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 3 / 3 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### 内部函数

覆盖选择率、统计收集、排序、类型转换、聚合、Hash、Btree、Psort、UGIN、GIN、GiST、Ubtree、GsIVFFLAT、GsDiskANN、BM25、PL/pgSQL、集合、外表、远程备机读取、增量重建、段页式、账本、AI、视图、事务快照、XMLType、pivot、subtype、nesttable和indexbytable内部函数族。

关键边界：

- 这些函数仅用于内部逻辑实现，不建议用户使用。
- `gs_insert_delete_txn_snapshot`当前版本调用返回`f`，无实际操作。

### Global SysCache

- `gs_gsc_table_detail`
- `gs_gsc_catalog_detail`
- `gs_gsc_clean`
- `gs_gsc_dbstat_info`

关键边界：

- 均需`SYSADMIN`权限。
- `database_id=NULL/-1`表示所有数据库，`0`表示共享表，其他数字表示指定数据库及共享表。
- PDB/Non-PDB只能查看或清理本域数据。
- `gs_gsc_clean`不会清理正在使用的数据。
- 命中率明显下降时可能提示`global_syscache_threshold`过小。

### Multixact回收

- `gs_vacuum_multixact`

关键边界：

- 仅主DN可执行。
- 仅初始用户或`sysadmin`属性用户可调用。
- 回收逻辑基于`PG_DATABASE.datminmxid`。
- 全局临时表可能阻碍`datminmxid`推进，需要在其会话执行`vacuum freeze`。

## Open questions

| ID | 内容 |
|---|---|
| `internal_wave7_1_oq_internal_matrix` | 内部选择率、类型转换、索引和聚合辅助函数在不同数据分布、索引类型和版本边界下的行为矩阵 |
| `internal_wave7_1_oq_gsc_multixact_evidence` | GSC统计/清理和Multixact回收在不同多租模式、缓存压力、全局临时表和主DN状态下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_internal_wave7_1_v1.yaml
generated/core_internal_wave7_1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_internal_wave7_1.py
python scripts/build_core_internal_wave7_1.py --check
python -m pytest -q tests/test_core_internal_wave7_1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不调用内部函数、不清理GSC、不执行Multixact回收。
- 不宣称目标环境行为验证通过。
