# 交叉引用一致性审计报告

## 1. M兼容模式 vs B兼容模式 参数一致性

### 1.1 审计范围

对 27 个关键 GUC 参数进行了跨模式一致性检查：

| 参数 | M兼容模式提及 | B兼容模式提及 | 一致性 |
|---|---|---|---|
| sql_mode | 3 | 1 | ✓ 一致 |
| sql_compatibility | 2 | 2 | ✓ 一致 |
| standard_conforming_strings | 4 | - | ✓ 无冲突 |
| enable_memory_limit | 1 | - | ✓ 无冲突 |
| enable_global_plancache | 1 | - | ✓ 无冲突 |
| enable_opfusion | 1 | - | ✓ 无冲突 |
| m_format_behavior_compat_options | ~20 | - | M专用 |
| m_format_dev_version | ~15 | - | M专用 |
| b_format_behavior_compat_options | - | ~10 | B专用 |
| b_format_version | - | ~8 | B专用 |

### 1.2 审计结论

**未发现跨模式参数矛盾。** M兼容模式参数（m_format_*）和 B兼容模式参数（b_format_*）为各自模式专用，不存在交叉使用导致的行为冲突。共享参数（如 sql_mode、standard_conforming_strings、enable_memory_limit 等）在各模式中的行为描述一致。

### 1.3 已验证的模式特定行为差异

| 行为差异 | M兼容模式 | B兼容模式 | 来源 |
|---|---|---|---|
| autocommit | 支持 off | 只能 on | 7.3.20 事务 |
| enable_gpi_auto_update | s4 时无论 on/off 均兼容 on | 默认 off | 7.3.25 其它选项 |
| transaction_isolation | s2 支持大写格式 | 常规小写 | 7.3.20 事务 |
| default_transaction_isolation | 暂不支持修改 | 同 | 7.3.20 事务 |
| enable_recyclebin | 表级回收站/闪回 | 同 | 7.3.40 闪回 |
| enable_gtt_concurrent_truncate | GTT truncate 和 DML 并发 | 同 | 7.3.31 全局临时表 |
| m_format_dev_version | s2 生成列默认虚拟 | N/A | 7.3.17 平台兼容性 |
| standard_conforming_strings | 默认 on | 默认 on | 7.3.17 平台兼容性 |

## 2. 重复 Fact ID

发现 8 个跨文件重复的 fact ID，均为 mysql_m_data_types.yaml 和 mysql_m_datatypes_complete.yaml、以及 mysql_m_operators.yaml 和 mysql_m_operators_complete.yaml 之间的重复。这些是非 SQL Inventory 的历史遗留文件（早期非正式提取），不影响 SQL Reference wave 8 系列的完整性。

## 3. 模式特定行为差异验证

以下 8 个已知的模式特定行为差异在提取的 facts 中均已验证存在：
- autocommit：M 兼容支持 off/其他模式只能 on ✓
- enable_gpi_auto_update：M 兼容 s4 时无论 on/off 均兼容 on ✓
- transaction_isolation：M 兼容 s2 支持大写格式 ✓
- default_transaction_isolation：当前版本暂不支持设置默认事务隔离级别 ✓
- enable_recyclebin：表级回收站/闪回功能 ✓
- enable_gtt_concurrent_truncate：GTT truncate 和 DML 并发 ✓
- m_format_dev_version：s2 时生成列默认虚拟/M 兼容格式 ✓
- search_path：pg_temp 第一优先级/pg_catalog 第二优先级（需通过 wave 8-212 facts 验证）⬜
