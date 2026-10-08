# SQL Reference Wave 8-158 Extraction V1

## 目标

抽取 高级包第十四批切片：`3.12.2.17 DBE_SCHEDULER` 第一切片——接口总账与任务创建/删除/运行族（页 2828–2840）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2828–2840） |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 31个接口总账（任务/程序/调度/任务类/证书/权限/启停/周期分析八族）
- CREATE_JOB 4种原型（内联/引用组合）与全参数语义（job_type三类型、repeat_interval三种写法、job_style仅REGULAR、EXTERNAL_SCRIPT权限证书前提、ilm前缀禁用）
- DROP_JOB/DROP_SINGLE_JOB（force/defer/commit_semantics三语义、TRANSACTIONAL须force=false）
- SET_ATTRIBUTE 5原型+value2保留位（mapping_date_to_datea、三族可选属性、置空与对象名限制）
- RUN_JOB（use_current_session语义）/RUN_BACKEND_JOB/RUN_FOREGROUND_JOB（仅external）
- 五组示例基线（program+schedule+job三步、12参内联、PLSQL_BLOCK运行、EXTERNAL_SCRIPT+credential全链路）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_158_oq_runtime` | EXTERNAL_SCRIPT任务在Windows节点的路径与权限差异、repeat_interval三种写法混用时的优先级、TRANSACTIONAL与ABSORB_ERRORS在多任务批量删除下的实际回滚/提交粒度需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_158_v1.yaml
generated/core_sql_reference_wave8_158_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_158.py
python scripts/build_core_sql_reference_wave8_158.py --check
python -m unittest tests.test_core_sql_reference_wave8_158 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不创建或运行定时任务。
