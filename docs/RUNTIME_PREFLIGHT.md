# Runtime Preflight

## 目标

`scripts/run_runtime_preflight.py` 只做数据库连接和只读 GUC 探测，不执行 runtime pilot SQL，不修改任何配置。

当前检查：

- 数据库版本
- `sql_compatibility`
- `enable_seqscan`
- `default_transaction_read_only`
- `behavior_compat_options`

## 使用

```bash
python scripts/run_runtime_preflight.py \
  --output generated/runtime_validation_pilot/preflight.json
```

默认读取环境变量：

- `GAUSSDB_HOST`
- `GAUSSDB_PORT`
- `GAUSSDB_DATABASE`
- `GAUSSDB_USER`
- `GAUSSDB_PASSWORD`

也可以显式传入连接参数：

```bash
python scripts/run_runtime_preflight.py \
  --host HOST \
  --port PORT \
  --database DATABASE \
  --user USER \
  --password-env GAUSSDB_PASSWORD \
  --output generated/runtime_validation_pilot/preflight.json
```

## 边界

- 只执行 `SELECT`
- 不执行 `SET`
- 不执行任何 runtime pilot SQL
- 不创建或删除对象
- 不证明高级包行为
- 不证明 runtime verification
- 输出不包含密码
