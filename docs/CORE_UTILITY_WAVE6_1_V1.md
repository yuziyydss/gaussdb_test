# Core Utility Functions Wave 6-1 Extraction V1

## 目标

细抽并一次性完成5个相邻的小型系统函数章节：

```text
1.6.30 触发器函数
1.6.31 HashFunc函数
1.6.32 提示信息函数
1.6.33 全局临时表函数
1.6.34 故障注入系统函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 5 |
| 物理页并集 | 900–909，共10页 |
| 结构化 facts | 22 |
| Open questions | 2 |
| Source resolved | 5 / 5 |
| Facts bound to scope | 22 / 22 |

## 覆盖内容

### 触发器函数

- `pg_get_triggerdef(oid)`
- `pg_get_triggerdef(oid, boolean)`
- `suppress_redundant_updates_trigger()`

关键边界：

- pretty布尔参数只在创建触发器时指定了`WHEN`条件的情况下生效。
- `suppress_redundant_updates_trigger`只能在触发器定义时调用，且仅在`BEFORE UPDATE`触发器中生效。

### HashFunc

- `ora_hash`
- `hash_array`
- `hash_numeric`
- `hash_range`
- `hashbpchar`
- `hashchar`
- `hashenum`
- `hashfloat4`
- `hashfloat8`
- `hashinet`
- `hashint1`
- `hashint2`

关键边界：

- `ora_hash`需要`a_format_version=10c`和`a_format_dev_version=s2`。
- `behavior_compat_options=a_hash_bpchar`时按保留字符串末尾空格计算hash。
- `hashint1`和`hashint2`返回`uint32`。

### 提示信息

- `report_application_error()`

关键边界：

- `log`必选；`code`可选，范围为`-20999`到`-20000`。

### 全局临时表与SQL诊断

- `pg_get_gtt_relstats`
- `pg_get_gtt_statistics`
- `pg_gtt_attached_pid`
- `dbe_perf.get_global_full_sql_by_timestamp`
- `dbe_perf.get_global_slow_sql_by_timestamp`
- `statement_detail_decode`
- `pg_list_gtt_relfrozenxids`

关键边界：

- 统计接口基于当前会话的指定全局临时表。
- 线程池开启且会话detach时，`pg_gtt_attached_pid`的pid为0。
- `statement_detail_decode`的format支持`plaintext`或`json`；plaintext下pretty控制换行或逗号分隔。
- `pid=0`行表示所有会话中最旧的冻结事务xid。

### 故障注入

- `gs_fault_inject`

关键边界：

- 该函数不能调用；调用时报`unsupported fault injection`。
- 不会对数据库产生影响或改变。

## Open questions

| ID | 内容 |
|---|---|
| `utility_wave6_1_oq_trigger_hash_matrix` | 触发器pretty输出和各类哈希函数在兼容参数、边界类型、NULL/特殊值下的输出矩阵 |
| `utility_wave6_1_oq_gtt_sql_evidence` | 全局临时表统计、附着会话、冻结xid与实例级SQL在多会话、线程池开关和真实负载下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_utility_wave6_1_v1.yaml
generated/core_utility_wave6_1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_utility_wave6_1.py
python scripts/build_core_utility_wave6_1.py --check
python -m pytest -q tests/test_core_utility_wave6_1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不创建触发器、不调用哈希函数、不抛出应用错误、不查询全局临时表、不执行故障注入。
- 不宣称目标环境行为验证通过。
