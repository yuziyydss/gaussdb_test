# Advanced Package Runtime Preflight Plan V1

## 目标

`core.advanced_package_runtime_preflight.py` 把 27 个高级包 runtime case 映射到可授权执行前的前置检查计划。它回答：

- 需要读取哪些全局环境值？
- 每个包需要哪些权限？
- 每类 case 需要什么 fixture？
- 执行边界和资源清理是什么？
- 哪些接口仍不能进入首批 runtime batch？

它不连接 GaussDB，不执行 SQL，不创建对象，不生成 runtime receipt。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Runtime plan 总单元 | 29 |
| GUC overlay 单元 | 2 |
| 高级包 runtime case | 27 |
| 覆盖 runtime candidate 接口 | 77 |
| 只读 preflight 查询 | 8 |
| low risk case | 22 |
| medium risk case | 5 |
| 扩展包 runtime candidate 覆盖 | 38 / 38 |
| case 覆盖 | complete |

## 只读 preflight 查询

| Key | 作用 |
|---|---|
| `server_version` | 记录数据库版本 |
| `current_database` | 确认目标数据库 |
| `current_user` | 确认执行角色 |
| `sql_compatibility` | XML 相关 case 确认 A 兼容模式 |
| `server_encoding` | 确认 XML 输入编码边界 |
| `client_encoding` | 确认客户端/服务端编码一致 |
| `behavior_compat_options` | 记录兼容行为选项 |
| `enable_ilm` | 记录 ILM 状态；ILM 执行仍排除 |

所有查询均为 `SELECT`，不包含 `SET`、`CALL`、DDL 或 DML。

## 包级前置合同

| Package | Execution class | Risk | 关键边界 |
|---|---|---|---|
| `DBE_OUTPUT` | `session_buffer_lifecycle` | low | session 本地输出，依赖 notice 捕获 |
| `DBE_RAW` | `pure_function_value` | low | 纯函数转换，无持久对象 |
| `DBE_SQL` | `dynamic_sql_context` | medium | 正常/异常路径都必须关闭 context |
| `DBE_XMLDOM` | `xml_document_lifecycle` | medium | 释放 document/node/list/text；禁止文件写 overload |
| `DBE_XMLPARSER` | `xml_parser_lifecycle` | medium | 释放 parser 和 document；避免外部 DTD |
| `DBE_STATS` | `statistics_history_read` | low | 仅两个只读历史函数，不执行 ANALYZE/purge |

## 输出

```text
generated/advanced_package_pilot/runtime_preflight_plan.json
```

## Result 与 Audit

Preflight 支持两段独立产物：

1. `runtime_preflight_result.json`
   - 只记录 8 个 SELECT 查询结果
   - 记录 connected、metadata_read、finding/error 数量
   - 显式声明没有执行 runtime SQL、没有改 GUC、没有建对象
2. `runtime_preflight_audit.json`
   - 对 plan id、runtime plan fingerprint、query identity / SQL、summary 和 validation status 独立对账
   - finding 是待复核项，不等于 query error
   - audit 不执行 SQL，也不证明高级包行为

Result 的 machine-readable 校验结果为：

- `passed`
- `finding`
- `not_evaluated`

其中：

- `sql_compatibility != A` 会产生 finding
- `server_encoding/client_encoding = SQL_ASCII` 会产生 finding
- 查询失败会产生 error，并阻止 `metadata_read=true`
- finding 不会自动宣布 result invalid，但必须复核后才能授权 runtime execution

## 命令

构建静态 preflight plan：

```bash
python scripts/build_advanced_package_runtime_preflight.py
```

校验静态 preflight plan：

```bash
python scripts/verify_advanced_package_runtime_preflight.py
```

对已配置 GaussDB 执行只读 preflight 并生成 audit：

```bash
python scripts/run_advanced_package_runtime_preflight.py \
  --output generated/advanced_package_pilot/runtime_preflight_result.json
```

单独审计已有 result：

```bash
python scripts/audit_advanced_package_runtime_preflight_result.py \
  --result generated/advanced_package_pilot/runtime_preflight_result.json \
  --output generated/advanced_package_pilot/runtime_preflight_audit.json
```

重建整条静态链：

```bash
python scripts/build_advanced_package_chain.py --check
```

## Evidence Bundle 与 Execution Gate

Evidence Bundle 现在登记 preflight plan、result 和 audit 三类产物，并输出 `preflight_ready`。

Execution Gate 的要求是：

```text
preflight_plan_valid=true
preflight_result_valid=true
preflight_audit_valid=true
preflight_connected=true
preflight_metadata_read=true
preflight_finding_count=0
```

任何一项未满足都会阻断授权执行。

## 边界

- Preflight plan 不是 preflight result；preflight result 也不是 runtime receipt。
- 只读 preflight 不证明高级包行为。
- Runtime evidence 必须由 receipt 和独立 audit 提供。
- ILM 执行与文件写入接口继续排除在首批授权执行外。
