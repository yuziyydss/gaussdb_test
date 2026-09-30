# Advanced Package Evidence Bundle V1

## 目标

`core.advanced_package_evidence.py` 将 Advanced Package Pilot V1 的静态接口合同、runtime dry run 和缺失的运行时证据汇总为可审计清单。

它解决的问题是：**高级包试点到底覆盖了什么、哪些 runtime 证据缺失、产物是否漂移**。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 证据产物 | 8 |
| 已存在产物 | 4 |
| 缺失产物 | 4 |
| 已建模支持包 | 22 / 22 |
| 未建模支持包 | 0 |
| 接口合同 | 251 |
| runtime candidate 接口 | 77 |
| manual review 接口 | 172 |
| static probe 接口 | 2 |
| runtime candidate 用例 | 27 |
| Runtime dry run 高级包单元 | 27 |
| Runtime dry run 高级包步骤 | 27 |

已建模的 22 个包：

- `DBE_OUTPUT`
- `DBE_RAW`
- `DBE_SQL`
- `DBE_MATCH`
- `DBE_UTILITY`
- `DBE_LOB`
- `DBE_FILE`
- `DBE_OBFUSCATION_TOOLKIT`
- `DBE_XMLGEN`
- `DBE_ALERT`
- `DBE_SESSION`
- `DBE_RANDOM`
- `DBE_APPLICATION_INFO`
- `DBE_SCHEDULER`
- `DBE_COMPRESSION`
- `DBE_DESCRIBE`
- `DBE_HEAT_MAP`
- `DBE_ILM`
- `DBE_ILM_ADMIN`
- `DBE_STATS`
- `DBE_XMLDOM`
- `DBE_XMLPARSER`

## 证据产物

| 名称 | 路径 | 当前状态 |
|---|---|---|
| `interface_inventory` | `environments/advanced_packages_v1.yaml` | 存在 |
| `candidate_matrix` | `generated/advanced_package_pilot/candidate_matrix.json` | 存在 |
| `runtime_dry_run` | `generated/runtime_validation_pilot/dry_run.json` | 存在 |
| `runtime_preflight_plan` | `generated/advanced_package_pilot/runtime_preflight_plan.json` | 存在 |
| `runtime_preflight_result` | `generated/advanced_package_pilot/runtime_preflight_result.json` | 缺失 |
| `runtime_preflight_audit` | `generated/advanced_package_pilot/runtime_preflight_audit.json` | 缺失 |
| `runtime_receipt` | `generated/runtime_validation_pilot/receipt.json` | 缺失 |
| `runtime_receipt_audit` | `generated/runtime_validation_pilot/receipt_audit.json` | 缺失 |

## 每个产物记录

- `name`
- `path`
- `exists`
- `sha256`
- `size_bytes`

缺失产物不会伪造哈希或大小。

## Runtime dry run 校验

Evidence Bundle 会核对高级包 runtime 单元：

- 数量必须等于 27 个 pilot test case
- 单元 ID 必须能映射到 pilot test case
- 每个单元保持：
  - `database_executed=false`
  - `runtime_verified=false`
  - `oracle.status=needs_verification`

## 命令

构建：

```bash
python scripts/build_advanced_package_evidence_bundle.py
```

校验：

```bash
python scripts/verify_advanced_package_evidence_bundle.py
```

写出 JSON 校验报告：

```bash
python scripts/verify_advanced_package_evidence_bundle.py \
  --output generated/advanced_package_pilot/evidence_bundle_verification.json
```

## 页面

```text
/advanced-package
```

## API

```text
GET /api/advanced-package/pilot
GET /api/advanced-package/candidate-matrix
GET /api/advanced-package/evidence-bundle
GET /api/advanced-package/evidence-bundle/verify
```

## Runtime候选覆盖

Evidence Bundle 会额外对账：

- `runtime_candidate_interface_count=77`
- `runtime_case_interface_count=77`
- `uncovered_runtime_candidate_interface_count=0`
- `runtime_candidate_case_coverage_complete=true`

这说明 77 个接口已登记为 runtime candidate，当前 27 个 dry-run 单元已覆盖全部 77 个 runtime candidate 接口；不再存在 runtime candidate 覆盖缺口。

## Preflight 状态

Evidence Bundle 现在还记录：

- `preflight_plan_valid=true`
- `preflight_result_present=false`
- `preflight_audit_present=false`
- `preflight_ready=false`

只有 result / audit 存在、审计有效、连接和元数据读取成功且 finding 为 0，`preflight_ready` 才会为 true。

## Runtime 状态

`/runtime` 页面与 `/api/runtime/status` 已纳入 Advanced Package Evidence Bundle：

- `advanced_package_static_ready=true`
- `advanced_package_runtime_executed=false`
- `advanced_package_all_complete=false`
- Runtime 产物总数为 13 个

## 边界

- 静态接口合同不证明数据库行为。
- Runtime dry run 不是 runtime receipt。
- 缺失 preflight result / audit 或 runtime receipt / audit 时，不能授权或宣称高级包行为验证通过。
- 22 个支持包均已建模；`DBE_XMLDOM` 的 27 个同名重载签名已闭合，静态合同覆盖不等于行为验证。
