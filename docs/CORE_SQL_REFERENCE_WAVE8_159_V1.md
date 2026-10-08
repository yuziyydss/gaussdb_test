# SQL Reference Wave 8-159 Extraction V1

## 目标

抽取 高级包第十五批切片：`3.12.2.17 DBE_SCHEDULER` 第二切片——程序/调度/任务类/证书/权限/启停/周期分析族（页 2841–2863），DBE_SCHEDULER 收官。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2841–2863） |
| 物理页 | 23 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- STOP_SINGLE_JOB（force终止信号/打断信号）、GENERATE_JOB_NAME（JOB$_前缀递增、public临时序列权限要求）
- CREATE_PROGRAM/DEFINE_PROGRAM_ARGUMENT（out_argument预留）、DROP_PROGRAM/SINGLE（force引用禁用）
- SET_JOB_ARGUMENT_VALUE双原型（按位置/按名称、赋空支持）
- CREATE_SCHEDULE三种repeat_interval基线、DROP_SCHEDULE/SINGLE（force引用禁用）
- CREATE_JOB_CLASS/DROP_JOB_CLASS/SINGLE（force作业禁用转默认类）
- GRANT/REVOKE_USER_AUTHORIZATION（SYSADMIN）、CREATE/DROP_CREDENTIAL（password兼容处理、os用户名禁止）
- ENABLE/ENABLE_SINGLE/DISABLE/DISABLE_SINGLE（force依赖与三种commit_semantics）
- EVAL_CALENDAR_STRING/EVALUATE_CALENDAR_STRING（OUT next_run_date）与FREQ=hourly示例基线

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_159_oq_runtime` | GENERATE_JOB_NAME临时序列在并发调用下的序号连续性、DISABLE(force=false)依赖检测的范围（job/program/schedule交叉引用）、EVALUATE_CALENDAR_STRING对FREQ与BYHOUR组合的完整日历语义需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_159_v1.yaml
generated/core_sql_reference_wave8_159_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_159.py
python scripts/build_core_sql_reference_wave8_159.py --check
python -m unittest tests.test_core_sql_reference_wave8_159 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改调度对象。
