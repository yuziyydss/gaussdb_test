# GUC V2 Execution Gate

## 目标

`core.guc_execution_gate.py` 在 GUC V2 runtime pilot 执行前做失败关闭检查。它把三类条件分开：

1. 技术就绪
2. 显式授权
3. 数据库可用

任意一层不满足，执行都会被阻断。

## 技术就绪

技术就绪要求：

- 静态审计有效
- GUC Environment V2 有效
- Overlay计划有效
- Preflight计划有效
- Preflight结果存在且有效
- Preflight连接成功
- Preflight读取全部元数据
- 声明值域不匹配数为 0
- Preflight错误数为 0
- Runtime pilot计划有效

## 显式授权

显式授权要求同时满足：

```text
--authorized
GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED=true
```

只提供其中一个不够。

## 数据库可用

数据库可用要求：

```text
GAUSSDB_ENABLED=true
```

并且后续数据库连接配置有效。

## 当前状态

当前仓库中：

- 静态审计有效
- Runtime pilot计划有效
- Preflight计划有效
- Preflight结果缺失

因此：

- `technical_ready=false`
- `authorization_ready=true`（仅当同时提供 CLI flag 和环境变量）
- `database_ready=true`（仅当 `GAUSSDB_ENABLED=true`）
- `allowed=false`

## 阻断输出示例

```text
GUC V2 runtime execution blocked:
- GUC V2 preflight is not ready.
```

## 边界

- 静态计划不授权执行。
- Preflight成功也不授权执行。
- 授权与数据库可用必须同时满足。
- 执行结果仍需独立 receipt 和 audit。

## API

```text
GET /api/guc/v2/execution-gate
GET /api/guc/v2/execution-gate?authorized=true
```

该 API 只做门禁预览，不执行数据库操作。
