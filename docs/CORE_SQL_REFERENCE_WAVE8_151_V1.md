# SQL Reference Wave 8-151 Extraction V1

## 目标

抽取 高级包第十批切片：`3.12.2.6 DBE_HEAT_MAP`（行冷热信息）与 `3.12.2.7 DBE_ILM`（策略评估与压缩Job停用）。注：两小节页面（2755–2760）已随 wave 8-150 切片纳入页级覆盖，本波补齐内容级 facts 账。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2755–2760，两个完整小节） |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_HEAT_MAP：ROW_HEAT_MAP全原型与8个输出参数（RELATIVE_FNO取值同FILE_ID）、运维类不做可见性判断、跨页透明压缩writetime为空；示例基线（example1表空间/file_id 17291）
- DBE_ILM：EXECUTE_ILM全原型（POLICY_NAME='ALL POLICIES'不支持小写、EXECUTION_MODE暂不区分在线/离线、TURBO_FORCE/BLKSTART/BLKEND）、JOBNAME命名规则与Invalid program name、并发FAILED（tuple concurrently updated）、DDL警告、PUBLIC+CREATE JOB权限与owner要求、二级分区SUBOBJECT_NAME规则、事务COMMIT后生效与锁超时风险、TURBO_FORCE对statistics字段影响
- STOP_ILM（TASK_ID/P_DROP_RUNNING_JOBS/P_JOBNAME）与Resources busy重试提示
- 示例基线：ILM_ADMIN初始化七步、ADVANCED策略表、Task ID is:1、STOP_ILM(-1,true,NULL)
- HEAT_MAP/COMPRESSION/ILM三包联动

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_151_oq_runtime` | EXECUTE_ILM生成Job的调度时延与TURBO_BLKSTART/BLKEND范围校验、STOP_ILM强制停止后压缩数据的一致性、并发EXECUTE_ILM锁超时的触发概率需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_151_v1.yaml
generated/core_sql_reference_wave8_151_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_151.py
python scripts/build_core_sql_reference_wave8_151.py --check
python -m unittest tests.test_core_sql_reference_wave8_151 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ILM评估或压缩。
