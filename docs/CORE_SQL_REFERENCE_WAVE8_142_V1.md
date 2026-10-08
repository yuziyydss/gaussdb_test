# SQL Reference Wave 8-142 Extraction V1

## 目标

抽取 高级包第一批切片：`3.12.1.1 PKG_SERVICE`（动态SQL CONTEXT 与定时任务接口；3.12 高级包共446页，按切片分批覆盖）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2640–2650） |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 接口总账：动态SQL类9个 + 定时任务类6个 + OUT参数读取类2个
- CONTEXT生命周期闭环（REGISTER→SET_SQL→RUN→NEXT_ROW→取值→UNREGISTER释放内存）与SQL_CLEAN_ALL_CONTEXTS
- SQL_SET_SQL仅SELECT、text≤1G、language_flag（1非兼容/2 A兼容）
- SQL_RUN/SQL_NEXT_ROW/SQL_GET_VALUE/SQL_SET_RESULT_TYPE全原型与参数语义
- JOB全生命周期：JOB_CANCEL/JOB_FINISH（broken与next_time='4000-1-1'规则）/JOB_SUBMIT（content混合语句、sysdate立即执行、interval表达式、STATUS='d'、作业号1~3000000、PERFORM与current_schema提示）/JOB_UPDATE空值不更新语义
- SUBMIT_ON_NODES（ALL_NODE/postgres限定、capture_view_to_json基线）与ISUBMIT_ON_NODES（sysadmin/monitor admin权限、入参作业号）
- SQL_GET_ARRAY_RESULT/SQL_GET_VARIABLE_RESULT获取存储过程OUT参数
- JOB示例基线（28269/1506/14131/101四个作业号与UPDATE/FINISH/CANCEL链路）

## Open questions

| ID | 内容 |
|---|---|
| `pkgsvc_wave8_142_oq_runtime` | JOB_SUBMIT在集群多节点下的作业调度与STATUS流转、SQL_SET_SQL大文本（接近1G）解析边界、SQL_GET_ARRAY_RESULT对多维数组OUT参数的绑定行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_142_v1.yaml
generated/core_sql_reference_wave8_142_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_142.py
python scripts/build_core_sql_reference_wave8_142.py --check
python -m unittest tests.test_core_sql_reference_wave8_142 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不提交定时任务或执行动态SQL。
