# GUC V2 Preflight

## 目标

`core.guc_preflight.py` 为 GUC Environment V2 生成 **只读、域感知** 的运行前检查计划。它覆盖 27 个参数，读取当前值并判断是否落在声明值域内，但不修改任何 GUC，也不执行目标 SQL。

## 输出

构建静态计划：

```bash
python scripts/build_guc_v2_preflight_plan.py
```

输出：

```text
generated/guc_environment_v2/preflight_plan.json
```

连接数据库后执行只读检查：

```bash
python scripts/run_guc_v2_preflight.py \
  --output generated/guc_environment_v2/preflight_result.json
```

该命令会同时生成：

```text
generated/guc_environment_v2/preflight_result.json
generated/guc_environment_v2/preflight_audit.json
```

如需指定审计输出路径：

```bash
python scripts/run_guc_v2_preflight.py \
  --output generated/guc_environment_v2/preflight_result.json \
  --audit-output generated/guc_environment_v2/preflight_audit.json
```

该命令只会执行：

```sql
SELECT current_setting('<parameter>', true) AS value;
```

不会执行：

```sql
SET ...
INSERT ...
UPDATE ...
DELETE ...
CREATE ...
DROP ...
ALTER ...
```

## 结果字段

每个参数记录：

- `parameter_id`
- `parameter_name`
- `sql`
- `status`
- `value`
- `in_declared_domain`
- `error`

汇总记录：

- `query_count`
- `success_count`
- `error_count`
- `domain_mismatch_count`

## 判定

- `connected`：至少一个查询成功
- `metadata_read`：全部查询成功
- `domain_mismatch_count`：查询成功但当前值不在声明值域内
- 查询失败不会伪造成功
- 值域不匹配是发现项，不等于数据库执行失败

## 结果审计

执行 Preflight 后，使用独立审计器：

```bash
python scripts/audit_guc_v2_preflight_result.py \
  --result generated/guc_environment_v2/preflight_result.json \
  --plan generated/guc_environment_v2/preflight_plan.json \
  --output generated/guc_environment_v2/preflight_audit.json
```

详见 [GUC V2 Preflight Audit](GUC_V2_PREFLIGHT_AUDIT.md)。

## 边界

- Preflight 不执行目标 SQL。
- Preflight 不修改 GUC。
- Preflight 不证明行为正确性。
- 运行时行为仍需单独授权与执行回执。
- `current_setting` 返回值仍可能受版本、租户或会话上下文影响。
