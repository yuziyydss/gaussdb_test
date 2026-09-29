# GUC V2 Evidence Bundle

## 目标

`core.guc_evidence_bundle.py` 将 GUC V2 的静态、Preflight 和 Runtime 证据产物汇总为一个可审计的清单。它解决的问题是：**交付或评审时，哪些证据文件存在、哪些缺失、每个文件的哈希是什么**。

它不验证数据库行为，也不授权执行。

## 产物

构建：

```bash
python scripts/build_guc_v2_evidence_bundle.py
```

也可以使用一键静态链重建：

```bash
python scripts/build_guc_v2_chain.py
```

输出：

```text
generated/guc_environment_v2/evidence_bundle.json
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 证据产物总数 | 15 |
| 已存在 | 11 |
| 缺失 | 4 |
| 静态证据完整 | true |
| Preflight证据完整 | false |
| Runtime证据完整 | false |
| 全链证据完整 | false |

## 证据分层

### Static

- `environments/guc_parameters_v2.yaml`
- `generated/guc_reference_catalog/catalog.json`
- `generated/guc_candidate_matrix/matrix.json`
- `generated/guc_environment_v2/overlay_plans.json`
- `generated/guc_environment_v2/overlay_plans.sql`
- `generated/guc_environment_v2/capability_matrix.json`
- `generated/guc_environment_v2/requirement_adapter.json`
- `generated/guc_environment_v2/preflight_plan.json`
- `generated/guc_environment_v2/runtime_dry_run.json`
- `generated/guc_environment_v2/readiness.json`
- `generated/guc_environment_v2/audit.json`

### Preflight

- `generated/guc_environment_v2/preflight_result.json`
- `generated/guc_environment_v2/preflight_audit.json`

### Runtime

- `generated/guc_environment_v2/runtime_receipt.json`
- `generated/guc_environment_v2/runtime_receipt_audit.json`

## 字段

每个产物记录：

- `name`
- `path`
- `exists`
- `sha256`
- `size_bytes`

汇总记录：

- `artifact_count`
- `present_count`
- `missing_count`
- `static_complete`
- `preflight_complete`
- `runtime_complete`
- `all_complete`

## 校验

校验 Evidence Bundle 是否与当前产物文件一致：

```bash
python scripts/verify_guc_v2_evidence_bundle.py
```

输出示例：

```text
GUC V2 evidence bundle verification passed: artifacts=13 present=9 missing=4
```

也可写出 JSON 报告：

```bash
python scripts/verify_guc_v2_evidence_bundle.py \
  --output generated/guc_environment_v2/evidence_bundle_verification.json
```

API：

```text
GET /api/guc/v2/evidence-bundle/verify
```

## Runtime 状态

`/runtime` 页面与 `/api/runtime/status` 已纳入 `guc_v2_evidence_bundle`：

- 15 个证据产物
- 11 个当前存在
- 4 个缺失
- 静态证据完整
- Preflight / Runtime 证据不完整

## 边界

- 证据存在不等于数据库行为验证。
- 静态证据完整不授权执行。
- Preflight证据完整不授权 GUC 修改。
- Runtime证据仍需独立审计。
- 缺失 Runtime 证据时，运行时行为保持未验证。
