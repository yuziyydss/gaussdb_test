# GUC API V1

## 目标

`main.py` 暴露 GUC V2 的本地产物，用于浏览 27 个参数、19 个 session overlay 计划和 95 个 SQL 步骤。API 只读取本地文件，不连接数据库，不执行任何 GUC。

## 页面

```text
/guc
```

页面展示：

- GUC Environment V2 摘要
- 27 个参数清单
- 19 个 overlay 计划
- 95 个 SQL 步骤
- 静态证据边界

## API

### Summary

```text
GET /api/guc/v2/summary
```

返回：

- environment 元数据
- overlay plan 摘要
- policy / category 统计

### Parameters

```text
GET /api/guc/v2/parameters
GET /api/guc/v2/parameters?policy=session_overlay
GET /api/guc/v2/parameters?policy=manual_review
GET /api/guc/v2/parameters/{parameter_id}
```

支持按 `execution_policy` 过滤：

- `session_overlay`
- `manual_review`
- `read_only`
- `blocked`

### Plans

```text
GET /api/guc/v2/plans
GET /api/guc/v2/plans.sql
```

### Runtime plan

```text
GET /api/guc/v2/runtime-plan
```

返回 19 个 GUC overlay dry-run 单元和 95 个 SQL 步骤，详见 [GUC V2 Runtime Pilot](GUC_V2_RUNTIME_PILOT.md)。

### Preflight plan

```text
GET /api/guc/v2/preflight-plan
```

返回 27 个只读 `current_setting` 查询，详见 [GUC V2 Preflight](GUC_V2_PREFLIGHT.md)。

### Readiness

```text
GET /api/guc/v2/readiness
```

### Capabilities

```text
GET /api/guc/v2/capabilities
```

返回 19 个 GUC V2 环境能力适配项，详见 [GUC V2 Capability Adapter](GUC_V2_CAPABILITY_ADAPTER.md)。

### Requirement adapter

```text
GET /api/guc/v2/requirement-adapter
```

返回 9 个可转换环境门禁和 10 个显式阻断项，详见 [GUC V2 Requirement Adapter](GUC_V2_REQUIREMENT_ADAPTER.md)。

### Evidence bundle

```text
GET /api/guc/v2/evidence-bundle
```

### Evidence bundle verification

```text
GET /api/guc/v2/evidence-bundle/verify
```

返回静态、Preflight与Runtime证据清单，详见 [GUC V2 Evidence Bundle](GUC_V2_EVIDENCE_BUNDLE.md)。

### Execution gate

```text
GET /api/guc/v2/execution-gate
GET /api/guc/v2/execution-gate?authorized=true
```

返回技术就绪、显式授权与数据库可用的门禁预览，详见 [GUC V2 Execution Gate](GUC_V2_EXECUTION_GATE.md)。

返回静态、Preflight、授权与运行时证据分层，详见 [GUC V2 Readiness](GUC_V2_READINESS.md)。

### Audit

```text
GET /api/guc/v2/audit
```

返回跨层静态审计结果，详见 [GUC V2 Audit](GUC_V2_AUDIT.md)。

`plans.sql` 返回纯文本 SQL 计划，不返回执行结果。

## 边界

- API 不连接数据库。
- API 不执行 SQL。
- `plans.sql` 是静态计划，不是执行收据。
- `manual_review`、`read_only`、`blocked` 参数不会进入 plans。
- 页面与 API 均只读取本地 GUC V2 产物。
