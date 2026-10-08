# SQL Reference Wave 8-164 Extraction V1

## 目标

抽取 高级包第十七批切片：`3.12.2.20 DBE_STATS` 第二切片——RESTORE/PURGE/历史查询/统计表族（页 2918–2927）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2918–2927） |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- RESTORE四接口全原型（TABLE含restore_cluster_index/no_invalidate暂不支持、PARTITION/COLUMN/SCHEMA、force锁定强行回退、级联范围差异）
- GS_TABLESTATS_HISTORY历史表定位回退节点（MIN(reltimestamp)+1 second）
- 三组回退示例基线（reltuples 6→3）
- PURGE_STATS（仅初始用户）+示例基线（仅剩6）
- GET_STATS_HISTORY_RETENTION（ALTER_STATS_HISTORY_RETENTION设置值）/GET_STATS_HISTORY_AVAILABILITY（最早可用时间）
- C_FUNCTION变体（XXXX_C_FUNCTION命名）与仅对普通表有效
- CREATE/DROP_STAT_TABLE（statstable reloptions标识、gs_stattab_oid_statid_type_nameinfo_index索引、级联删除依赖）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_164_oq_runtime` | force=TRUE强行回退锁定统计信息的实际效果、GS_TABLESTATS_HISTORY保留时长（ALTER_STATS_HISTORY_RETENTION）的默认值与清理调度、统计表statstable版本信息升级兼容需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_164_v1.yaml
generated/core_sql_reference_wave8_164_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_164.py
python scripts/build_core_sql_reference_wave8_164.py --check
python -m unittest tests.test_core_sql_reference_wave8_164 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改统计信息。
