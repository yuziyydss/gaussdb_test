# GUC Environment V1

## 目标

`environments/guc_parameters_v1.yaml` 将 GUC 从 SQL syntax factor 中拆出来，作为独立的环境能力建模。当前目标是建立可审计、可恢复、可失败关闭的 **session overlay 试点**，不是宣称全量 GUC 行为闭环。

## 当前试点

- 参数数量：20
- `session_overlay`：14
- `manual_review`：4
- `read_only`：1
- `blocked`：1

试点覆盖：

- SQL 兼容模式与 B/M 行为配置
- 查询计划算子开关
- 事务默认隔离级别与只读状态
- 计划缓存策略与 SQL Beta 特性
- WAL 同步策略、全局计划缓存、B 平台版本等需人工复核或阻断的参数

## 模型边界

每个参数登记：

- 参数名与分类
- 值类型与值域
- 默认值
- GaussDB context type：`INTERNAL` / `USERSET` / `SUSET` / `SIGHUP` / `POSTMASTER`
- 可设置层级
- 是否动态
- 是否需要重启
- 执行策略
- 安全试点值
- 恢复策略
- 来源文件 SHA-256 与锚点
- runtime parameter fact 引用

## 执行策略

| 策略 | 含义 |
|---|---|
| `session_overlay` | 只允许会话内 `SET`，必须捕获原值、验证目标值、恢复原值并验证恢复 |
| `read_only` | 只允许读取，例如 `sql_compatibility` |
| `manual_review` | 文档可设置，但存在值域未闭合、联动参数或运行风险，暂不自动执行 |
| `blocked` | 例如 `POSTMASTER` 参数，自动执行必须阻断 |

## Session overlay 计划

`core.guc_environment.GucEnvironmentPlanner` 生成的步骤顺序固定为：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

计划只允许：

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

恢复时使用捕获到的原值执行 `SET`，而不是 `RESET`，避免把会话恢复到继承默认值而非测试前状态。

## 事实校验

参数中的 `fact_refs` 必须引用 `docs/compat_facts/runtime_params_*.yaml` 中状态为 `confirmed` 的事实。当前两个 `needs_verification` 事实不得绑定到参数：

- `guc_td_compatible_truncation`
- `guc_max_wal_size`

## 不是已完成的事

- 未连接真实 GaussDB
- 未执行任何 GUC 行为验证
- 未完成全部产品文档 GUC 的参数级建模
- 未实现 GUC 参数间依赖/互斥的通用约束求解
- 未接入 SQL factor 的运行时执行器

因此当前结论只能是：**GUC 环境模型和 session overlay 计划已静态闭环**，不能称为数据库行为验证通过。
