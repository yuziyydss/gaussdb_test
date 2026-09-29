# GUC Environment V2

## 目标

`environments/guc_parameters_v2.yaml` 在 V1 20 个试点参数基础上扩展到 27 个参数。它消费 [GUC Candidate Matrix V1](GUC_CANDIDATE_MATRIX_V1.md) 的下一批 7 个 confirmed fact 候选，并保留原 V1 的安全边界。

V2 不是数据库行为验证结果，也不是自动执行声明。

## 规模

| 指标 | 当前值 |
|---|---:|
| 参数总数 | 27 |
| `session_overlay` | 19 |
| `manual_review` | 6 |
| `read_only` | 1 |
| `blocked` | 1 |
| 新增 confirmed fact 候选 | 7 |
| 新增 session overlay | 5 |
| 新增 manual review | 2 |

## 新增分类

| 分类 | 参数 |
|---|---|
| `data_import_export` | `a_format_enable_copy_empty_lobs`, `enable_copy_case_sensitive`, `enable_copy_when_filler`, `enable_log_copy_illegal_chars` |
| `runtime_statistics` | `enable_plan_trace`, `enable_save_datachanged_timestamp`, `track_procedure_sql` |

## 评审结论

### 进入 `session_overlay`

以下5个参数满足：

1. 唯一 `USERSET`
2. 布尔型且值域为 `on/off`
3. 有 `confirmed` runtime parameter fact
4. 无需重启
5. 仅会话内设置即可验证并恢复

- `a_format_enable_copy_empty_lobs`
- `enable_copy_case_sensitive`
- `enable_copy_when_filler`
- `enable_log_copy_illegal_chars`
- `track_procedure_sql`

### 保留 `manual_review`

以下2个参数虽然满足基础候选条件，但与 DML/系统表记录存在耦合，先不自动执行：

- `enable_plan_trace`
- `enable_save_datachanged_timestamp`

保留原因：

- `enable_plan_trace` 可能影响 DML 计划追踪和 `GS_PLAN_TRACE` 系统表记录。
- `enable_save_datachanged_timestamp` 与 DML 和分区操作的数据改动时间收集耦合。

在目标 SQL 执行合同明确排除或显式管理这些副作用前，二者不进入 session overlay。

## Session overlay 计划

V2 沿用 V1 的固定顺序：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

只允许：

```sql
SELECT current_setting('<parameter>', true) AS value;
SET <parameter> = '<value>';
```

不允许：

```sql
ALTER SYSTEM ...
ALTER DATABASE ...
ALTER ROLE ...
RESET <parameter>;
```

## 运行前检查

V2 提供 27 个只读 `current_setting` 查询，见 [GUC V2 Preflight](GUC_V2_PREFLIGHT.md)。

## 执行就绪

静态、Preflight、授权与运行时证据见 [GUC V2 Readiness](GUC_V2_READINESS.md)。

## 静态审计

四层产物可通过 [GUC V2 Audit](GUC_V2_AUDIT.md) 做跨层校验。

## 浏览与 API

可通过 [GUC API V1](GUC_API_V1.md) 的 `/guc` 页面和 `/api/guc/v2/*` 路由浏览 V2参数与计划。

## 计划导出

19个session overlay参数已导出为 [GUC Overlay Plan Export V1](GUC_OVERLAY_PLAN_EXPORT_V1.md)，共95个SQL步骤；该导出仍是静态计划。

## 边界

- 未连接真实 GaussDB。
- 未执行任何 GUC 行为验证。
- `confirmed fact` 是来源评审状态，不是运行时证据。
- V2 只是试点扩展，不代表全量 GUC 行为闭环。
- `enable_plan_trace` 与 `enable_save_datachanged_timestamp` 保留人工复核，不因候选条件满足而自动放宽。
