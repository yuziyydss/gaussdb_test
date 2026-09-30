# GUC V2 Readiness

## 目标

`core.guc_readiness.py` 将 GUC V2 的执行准备状态分为四层，避免把静态产物、只读检查、显式授权和运行时证据混在一起：

1. 静态产物有效
2. 只读 Preflight 完成
3. 运行时执行已授权
4. 运行时行为已验证

当前仓库只能证明第 1 层；第 2 层等待数据库连接；第 3、4 层必须由独立授权和执行回执产生。

## 当前状态

| 指标 | 当前值 |
|---|---:|
| GUC Environment V2 参数 | 27 |
| Overlay计划 | 19 |
| Overlay SQL步骤 | 95 |
| Preflight查询 | 27 |
| 静态审计检查 | 25 |
| Preflight结果 | 缺失 |
| 执行授权 | 未授权 |
| 运行时验证 | 未验证 |
| Ready for authorized execution | `false` |

## 阻断项

当前阻断项包括：

- GUC V2 preflight result is missing.
- Runtime execution is not authorized.

## 命令

生成 readiness 报告：

```bash
python scripts/build_guc_v2_readiness.py
```

输出：

```text
generated/guc_environment_v2/readiness.json
```

API：

```text
GET /api/guc/v2/readiness
```

页面：

```text
/guc
/runtime
```

API：

```text
GET /api/guc/v2/readiness
GET /api/runtime/status
```

## 判定

`ready_for_authorized_execution` 只有在以下条件全部满足时才为 `true`：

- 静态审计有效
- GUC Environment V2 有效
- Overlay计划有效
- Runtime pilot计划有效
- Preflight计划有效
- Preflight结果存在且有效
- Preflight结果审计有效且绑定原计划

`scripts/run_guc_v2_preflight.py` 会同时生成 result 与 audit。
- 数据库连接成功
- 全部元数据读取成功
- 声明值域不匹配数为 0
- Preflight错误数为 0

即使该值为 `true`，也只表示“具备进入授权评审的条件”，不等于已授权或已执行。

## 边界

- 静态审计不证明数据库行为。
- Preflight只读，不修改GUC。
- Readiness不授权执行。
- 运行时验证必须由独立执行回执证明。
- 缺失执行回执时，运行时行为始终保持未验证。
