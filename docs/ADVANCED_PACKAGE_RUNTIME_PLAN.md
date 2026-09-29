# Advanced Package Runtime Plan API

## 目标

`/api/advanced-package/runtime-plan` 返回高级包 Runtime Validation Pilot 的 dry-run 计划，用于查看 29 个单元和 37 个 SQL 步骤。

## 边界

- 只返回静态计划，不连接数据库。
- 不执行任何 SQL。
- 不授权运行。
- 不生成 runtime receipt。
