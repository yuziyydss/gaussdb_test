# GUC Overlay Plan Export V1

## 目标

`core/guc_plan_export.py` 将 [GUC Environment V2](GUC_ENVIRONMENT_V2.md) 中的 19 个 `session_overlay` 参数导出为确定性 JSON 与 SQL 计划。它解决的问题是：**把安全策略变成可审计、可复跑、可人工执行的静态计划**。

它不是执行收据，也不表示已经连接数据库。

## 输出

构建：

```bash
python scripts/build_guc_overlay_plans.py
```

输出：

```text
generated/guc_environment_v2/overlay_plans.json
generated/guc_environment_v2/overlay_plans.sql
```

## 规模

| 指标 | 当前值 |
|---|---:|
| 环境参数总数 | 27 |
| 导出计划数 | 19 |
| 排除参数数 | 8 |
| SQL步骤总数 | 95 |

排除的 8 个参数来自：

- `manual_review`：6
- `read_only`：1
- `blocked`：1

## SQL 边界

每个计划固定为：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

只生成：

```sql
SELECT current_setting('<parameter>', true) AS value;
SET <parameter> = '<value>';
```

不生成：

```sql
ALTER SYSTEM ...
ALTER DATABASE ...
ALTER ROLE ...
RESET <parameter>;
```

恢复时使用捕获到的原值执行 `SET`，不使用 `RESET`。

## 校验

导出加载时会校验：

- 环境文件 SHA-256；
- 计划数量、排除数量、步骤数量；
- 参数 ID / 名称唯一性；
- 固定步骤顺序；
- 所有步骤是否必须成功；
- 汇总统计是否与 payload 一致。

## API

计划可通过 [GUC API V1](GUC_API_V1.md) 浏览：`/guc`、`/api/guc/v2/plans` 与 `/api/guc/v2/plans.sql`。

## 边界

- 静态计划不等于数据库行为验证。
- 未连接 GaussDB，未执行任何 SQL。
- `overlay_plans.sql` 只是计划，不是执行收据。
- `manual_review`、`read_only` 和 `blocked` 参数不会进入导出。
- 计划中的“原值”来自环境模型声明；真实执行前仍需先捕获会话当前值。
