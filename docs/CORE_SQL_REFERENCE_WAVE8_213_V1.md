# SQL Reference Wave 8-213 Extraction V1

## 目标

抽取 GUC容错性/连接池/事务：`7.3.17.3 云服务产品版本号` + `7.3.18 容错性` + `7.3.19 连接池参数` + `7.3.20 事务`（页 4649–4659）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4（完整节合并） |
| 物理页 | 10 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 云服务版本号（7.3.17.3）：product_version（≤50字符）/hotpatch_version（≤1500字符/不能包含特殊字符）
- 容错性（7.3.18）：exit_on_error（ERROR→PANIC）/restart_after_crash（线程崩溃自动恢复）/omit_encoding_error（UTF-8编码转换错误忽略）/cn_send_buffer_size/data_sync_retry（fsync失败重试）/remote_read_mode（远程读功能/authentication认证）
- 连接池（7.3.19）：cache_connection（回收连接池连接/集中式不生效）
- 事务（7.3.20）：transaction_isolation（默认/M兼容s2大写格式/tx_isolation/@@session./@@transaction_隔离级别设置）/transaction_read_only（tx_read_only/pdb_transaction_read_only）/autocommit（M兼容支持off/pg_settings不能查询需SHOW/内部自动提交模式确认）/xc_maintenance_mode/allow_concurrent_tuple_update/enable_show_any_tuples（toast missing chunk问题）/replication_type（1=一主多备推荐）/pgxc_node_name（流复制槽名61字符限制）/enable_defer_calculate_snapshot/seqscan_csn_cache_num/enable_interp_reuse_tran/enable_lightweight_transaction/verify_clog_csnlog_mode
