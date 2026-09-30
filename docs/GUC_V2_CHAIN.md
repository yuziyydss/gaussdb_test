# GUC V2 Static Chain

## 目标

`scripts/build_guc_v2_chain.py` 用一条命令重建 GUC V2 的完整静态证据链。它只生成静态计划和审计产物，不连接数据库，不执行 Preflight，不执行 Runtime Pilot。

## 命令

```bash
python scripts/build_guc_v2_chain.py
```

检查当前静态链是否可稳定重建：

```bash
python scripts/build_guc_v2_chain.py --check
```

`--check` 会先记录 11 个静态产物的 SHA-256，重建后再对比。任何哈希变化都会导致退出码 1。

## 构建顺序

1. `GUC Reference Schema V2`
2. `GUC Candidate Matrix V1`
3. `GUC Overlay Plan Export V1`
4. `GUC V2 Capability Matrix`
5. `GUC V2 Requirement Adapter`
6. `GUC V2 Preflight Plan`
7. `GUC V2 Runtime Pilot Dry Run`
8. `GUC V2 Cross-Layer Static Audit`
9. `GUC V2 Readiness`
10. `GUC V2 Evidence Bundle`

## 输出

```text
generated/guc_reference_catalog/catalog.json
generated/guc_candidate_matrix/matrix.json
generated/guc_environment_v2/overlay_plans.json
generated/guc_environment_v2/overlay_plans.sql
generated/guc_environment_v2/capability_matrix.json
generated/guc_environment_v2/requirement_adapter.json
generated/guc_environment_v2/preflight_plan.json
generated/guc_environment_v2/runtime_dry_run.json
generated/guc_environment_v2/audit.json
generated/guc_environment_v2/readiness.json
generated/guc_environment_v2/evidence_bundle.json
```

## 当前结果

```text
artifacts=15
present=11
missing=4
static=True
preflight=False
runtime=False
```

## 场景消费

`GUC V2 Requirement Resolver` 会在场景准备阶段消费 Requirement Adapter，解析 `guc_*` 环境门禁；该步骤是代码路径，不是本静态链的磁盘产物。
`GUC V2 Execution Selector` 会继续消费 Resolver 结果，选择具体执行值并生成五步 overlay 计划；该步骤同样是代码路径，不生成本链的独立磁盘产物。

## 边界

- 不连接 GaussDB。
- 不执行 Preflight。
- 不执行 Runtime Pilot。
- 不生成 Preflight result / audit。
- 不生成 Runtime receipt / audit。
- 静态证据完整不代表数据库行为验证通过。
