# Advanced Package Execution Gate

## 目标

`core.advanced_package_gate.py` 在高级包 runtime pilot 执行前做失败关闭检查。它把静态证据、runtime plan、显式授权和数据库启用状态分开判断。

## 技术就绪

技术就绪要求：

1. Advanced Package Evidence Bundle 存在且无漂移。
2. Runtime Validation Pilot Dry Run 存在且结构有效。
3. Runtime dry run 包含 29 个单元、37 个执行步骤。
4. Preflight plan、result 和 audit 全部存在且有效。
5. Preflight 必须成功连接、完整读取元数据，且 finding 数为 0。

## 显式授权

需要同时满足：

```text
--authorized
GAUSSDB_RUNTIME_PILOT_AUTHORIZED=true
```

## 数据库可用

需要：

```text
GAUSSDB_ENABLED=true
```

并且连接配置有效。

## Preflight 门禁

当前缺省没有 `runtime_preflight_result.json` 和 `runtime_preflight_audit.json`，因此即使静态证据有效并提供了授权，Execution Gate 仍然阻断执行。

Preflight finding 未清零时也会阻断。

## 防重入

如果已存在：

```text
generated/runtime_validation_pilot/receipt.json
generated/runtime_validation_pilot/receipt_audit.json
```

执行门禁会阻断再次执行。

## 页面

`/advanced-package` 页面提供 Execution Gate 面板，展示静态证据、Runtime plan、授权请求、环境授权、数据库状态和阻断项。

## API

```text
GET /api/advanced-package/execution-gate
GET /api/advanced-package/execution-gate?authorized=true
```

## 边界

- 静态证据完整不授权执行。
- Runtime dry run 不是执行收据。
- 执行仍需要真实数据库连接。
- 执行后必须生成 receipt 和独立 audit。
