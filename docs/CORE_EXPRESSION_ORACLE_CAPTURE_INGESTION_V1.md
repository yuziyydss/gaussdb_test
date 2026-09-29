# Core Expression Oracle Capture Ingestion V1

## 目标

把已经通过独立 audit 的 batch runtime receipt 转换成标准 oracle capture slots。

Ingestion 不执行 SQL，不做出 oracle review decision，也不生成 executable oracle promotion。

## 输入

必须提供：

1. Batch execution plan artifact
2. Batch runtime receipt artifact / payload
3. receipt 的 `plan_sha256`

当前支持：

```text
batch_01_scalar_types_conditionals
batch_02_strings_and_conversion
batch_03_structured_types
batch_04_aggregates_windows_datetime
```

## 前置校验

Ingestion 前必须通过 receipt audit：

- `valid=true`
- `plan_verified=true`
- `plan_sha256` 一致
- plan step IDs 一致
- 每步 SQL 一致
- authorization 全部为 true
- preflight audit SHA 非 placeholder
- counts 一致

## Capture 转换

| Receipt step | Capture slot |
|---|---|
| `success` | `captured` |
| `failed` | `capture_failed` |

成功步骤必须有 rows；失败步骤必须有 error 和 SQLSTATE。

转换时保留：

- rows
- notices
- error
- SQLSTATE
- duration_ms
- server version
- SQL compatibility
- connected database
- connected user

每个非 pending capture 自动计算 canonical evidence hash：

```text
SHA-256(canonical JSON(sql, rows, notices, error, sqlstate, duration_ms, environment))
```

## 停止策略

receipt 必须遵守 stop-on-first-failure：

- 失败步骤后的 receipt step 会被 schema 拒绝
- 后续未执行 probe 的 capture slots 保持 `pending_capture`

## 输出

Ingestion payload 包含：

- source execution plan path / SHA-256
- source receipt hash
- plan SHA-256
- receipt audit result
- full capture registry
- ingestion summary
- `ingestion_sha256`

## 命令

```bash
python scripts/ingest_core_expression_oracle_capture.py \
  --batch-id batch_02_strings_and_conversion \
  --receipt generated/core_expression_probe_batches_v1/batch_02_strings_and_conversion_receipt.json \
  --output generated/core_expression_oracle_capture_v1/batch_02_capture_ingestion.json
```

## 边界

- ingestion 不执行 SQL。
- ingestion 不判断结果是否符合 oracle。
- captured result 不代表行为验证通过。
- review decision 必须另行记录。
