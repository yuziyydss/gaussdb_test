# SQL Reference Wave 8-218 Extraction V1

## 目标

抽取 GUC Undo/DCF参数设置：`7.3.38 Undo` + `7.3.39 DCF 参数设置`（页 4763–4778）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 15 |
| 结构化 facts | 6 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- Undo（7.3.38，仅Ustore有效）：undo_space_limit_size（256GB默认/80%触发强制回收/snapshot too old风险/长事务大事务调大参考gs_stat_undo）/undo_limit_size_per_transaction（32GB默认/超1TB实际生效1TB/undo size exceeds threshold回滚）
- DCF基础（7.3.39）：enable_dcf（模式切换命令勿手动修改）/dcf_ssl（复用ssl）/dcf_config/data_path/log_path（OM配置）/dcf_node_id
- DCF线程/阈值：dcf_max_workers/dcf_truncate_threshold/dcf_election_timeout（时钟差异约束/手动模式禁止修改）
- DCF模式/日志：dcf_enable_auto_election_priority/dcf_election_switch_threshold/dcf_run_mode（0自动/1手动/2去使能）/dcf_log_level（9种级别竖线组合/NONE不能混用）/dcf_log_backup_file_count/dcf_max_log_file_size/dcf_socket_timeout/dcf_connect_timeout
- DCF内存/流控：dcf_mec_fragment_size/dcf_stg_pool_max_size/init_size/dcf_mec_pool_max_size/dcf_flow_control_disk_rawait_threshold/net_queue_message_num_threshold/cpu_threshold/dcf_mec_batch_size等
- DCF安全/多数派：dcf_encrypt_algorithm（PLAIN/AES_256_GCM/SM4_CBC）/dcf_log_file_permission（600/640）/dcf_log_path_permission（700/750）/dcf_majority_groups（策略化多数派/group故障需build时移除）/dcf_node_id_map（DN备机名与DCF node_id映射/synchronous_standby_names需包含/设置不当集群安装升级失败）/dcf_candidate_names（自动模式选举候选者依赖dcf_node_id_map）/dcf_thread_effective_time（I/O hang检测0关闭超时触发降备）
