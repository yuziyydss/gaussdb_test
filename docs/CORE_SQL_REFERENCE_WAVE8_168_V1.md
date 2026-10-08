# SQL Reference Wave 8-168 Extraction V1

## 目标

抽取 高级包第二十一批切片：`3.12.2.21 DBE_TASK`（定时任务11接口，页 2971–2981）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2971–2981） |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 11接口全原型：SUBMIT（what四类混合、interval 'null'只执行一次STATUS='d'、作业号1~3000000）/JOB_SUBMIT（兼容参数）/ID_SUBMIT（入参作业号）/CANCEL/RUN/FINISH（broken与'4000-1-1'）/UPDATE/CHANGE/CONTENT（可执行成功才生效、模式名要求）/NEXT_TIME（小于当前日期立即执行一次）/INTERVAL
- 约束：运行中'r'状态锁定修改、仅经高级包管理JOB（DML直改PG_JOB危害）、主节点故障的'r'/'s'状态与调度恢复、跨主节点同步超时重发与信息不一致、并发JOB 0.1ms启动延迟
- 安全提示：what中创建用户日志记录密码明文
- 示例基线：SUBMIT作业号31031/512、PERFORM形式、ID_SUBMIT(101)、FINISH(101,true)、UPDATE/CHANGE/CONTENT/INTERVAL链路

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_168_oq_runtime` | JOB与主节点绑定在故障切换后的调度恢复时序、job_status='r'卡死任务的解锁手段、并发JOB 0.1ms启动延迟在高并发场景的累积影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_168_v1.yaml
generated/core_sql_reference_wave8_168_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_168.py
python scripts/build_core_sql_reference_wave8_168.py --check
python -m unittest tests.test_core_sql_reference_wave8_168 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不提交或修改定时任务。
