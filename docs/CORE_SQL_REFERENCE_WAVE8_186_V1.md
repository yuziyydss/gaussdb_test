# SQL Reference Wave 8-186 Extraction V1

## 目标

抽取 CM 参数说明：`7.4.1 cm_agent 参数` + `7.4.2 cm_server 参数`（约139个参数，页 4838–4886）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 49 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- cm_agent日志参数（log_dir/log_file_size/log_min_messages/log_threshold_check_interval/log_max_size/log_max_count）
- cm_agent告警组件（alarm_component两种alarm-type模式）
- cm_agent切换参数（switch_heartbeat/election/upgrade_timeout）
- cm_agent DN参数（增量重建开关/降副本延迟12s/升副本延迟60s）
- cm_server日志/线程（thread_count 1000,1/thread_effective_time 20s/ctl_thread_count 0,1）/告警/同步/升级参数
- cm_agent网络/连接（heartbeat/connect/retries/status_check）+ 资源监控（CPU/内存/磁盘阈值）+ 异步日志
- cm_server HA参数（connect/heartbeat/status_interval/demote_delay）/DCF参数（enable_dcf/ddb_*系列）/SSL/安全参数
- 参数修改方式（配置文件+重启 vs cm_ctl在线修改）、风险模式

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_186_oq_runtime` | CM参数修改后reload vs restart的完整参数列表、thread_count调整对集群故障检测延迟的量化影响、双dorado仲裁在脑裂场景下的决策一致性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_186_v1.yaml
generated/core_sql_reference_wave8_186_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_186.py
python scripts/build_core_sql_reference_wave8_186.py --check
python -m unittest tests.test_core_sql_reference_wave8_186 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改CM参数。
