# Core SPM Plan Management Wave 3-1 Extraction V1

## 目标

细抽 `1.6.28 SPM计划管理函数`，本轮完成该章全部函数的首轮结构化抽取。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 804–812，共9页 |
| 结构化 facts | 21 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 21 / 21 |

## 覆盖内容

### 计划演进与状态

- `GS_SPM_EVOLUTE_PLAN`
- `GS_SPM_SET_PLAN_STATUS`

关键边界：

- 两个函数均属于`DBE_SQL_UTIL` schema。
- `GS_SPM_EVOLUTE_PLAN`要求计划基线相关表存在。
- `GS_SPM_SET_PLAN_STATUS`生效时会同步刷新`gs_spm_baseline.invalid=false`。
- 计划状态支持`ACC`、`UNACC`和`FIXED`；`FIXED`是特殊`ACC`状态，匹配优先级高于`ACC`。

### Baseline展示、加载、验证与删除

- `GS_SPM_DISPLAY_PLANS`
- `GS_SPM_RELOAD_PLAN`
- `GS_SPM_VALIDATE_PLAN`
- `GS_SPM_DELETE_PLAN`

关键边界：

- `GS_SPM_DISPLAY_PLANS`查看单条SQL的所有baseline。
- `GS_SPM_RELOAD_PLAN`把baseline从系统表加载到SPM global cache。
- `GS_SPM_VALIDATE_PLAN`返回`t`表示计划可用，`f`表示不可用。
- `GS_SPM_DELETE_PLAN`执行期间异常中止时，可能导致`gs_spm_baseline`记录数超过GUC参数`spm_plan_capture_max_plannum`指定的数量。

### 历史计划

- `GS_SPM_GET_PLAN_HISTORY`
- `GS_SPM_ACCEPT_HISTORICAL_PLAN`
- `GS_SPM_DELETE_PLAN_HISTORY`

关键边界：

- `GS_SPM_GET_PLAN_HISTORY`查看指定时间点之前的历史计划。
- 历史计划`source`支持`AUTO`、`MANUAL`和`STORE`。
- `GS_SPM_ACCEPT_HISTORICAL_PLAN`只支持把历史计划设置为`ACC`或`FIXED`。
- `namespace_oids`可选：不指定时不区分Schema查找最新历史记录；指定时在指定Schema OID列表内查找。
- `GS_SPM_DELETE_PLAN_HISTORY`通过SQL hash、计划hash、上一个计划hash、用户OID和创建时间定位历史记录。

## Open questions

| ID | 内容 |
|---|---|
| `spm_wave3_1_oq_status_transition_matrix` | `ACC`、`UNACC`、`FIXED`之间的状态转换、`gs_spm_baseline.invalid`刷新、失败报错和`FIXED`优先级行为 |
| `spm_wave3_1_oq_history_namespace_matrix` | 历史计划查看、接受和删除在时间边界、`namespace_oids`、多Schema和删除定位下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_spm_plan_wave3_1_v1.yaml
generated/core_spm_plan_wave3_1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_spm_plan_wave3_1.py
python scripts/build_core_spm_plan_wave3_1.py --check
python -m pytest -q tests/test_core_spm_plan_wave3_1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行计划演进、状态修改、baseline加载/验证/删除或历史计划接受/删除。
- 不宣称目标环境行为验证通过。
