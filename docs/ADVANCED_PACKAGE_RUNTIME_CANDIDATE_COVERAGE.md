# Advanced Package Runtime Candidate Coverage API

## 目标

`/api/advanced-package/runtime-candidate-coverage` 返回高级包 runtime candidate 接口与 runtime dry run 的覆盖对账结果。

## 字段

- `runtime_candidate_interface_count`
- `runtime_case_interface_count`
- `uncovered_runtime_candidate_interface_count`
- `runtime_candidate_case_coverage_complete`
- `runtime_candidate_interface_ids`
- `runtime_case_interface_ids`
- `uncovered_runtime_candidate_interface_ids`

## 边界

- 该 API 只读取本地产物，不连接数据库。
- 不执行高级包调用。
- 不修改任何 GUC 或 PL/SQL 状态。
- 覆盖完成只表示静态用例覆盖，不表示数据库行为验证通过。
