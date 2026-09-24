# Advanced Package Pilot V1

## 目标

`environments/advanced_packages_v1.yaml` 将高级包从普通 SQL statement factor 中拆出来，作为独立的 PL/SQL 接口合同建模。试点覆盖：

- `DBE_OUTPUT`
- `DBE_RAW`
- `DBE_SQL`

当前目标是**可静态审计、可生成 runtime candidate、可后续接实机验证**，不是宣称数据库行为验证通过。

## 接口规模

| Package | 接口数 |
|---|---:|
| `DBE_OUTPUT` | 10 |
| `DBE_RAW` | 22 |
| `DBE_SQL` | 14 |
| 合计 | 46 |

每个接口登记：

- 所属包
- 完整调用名
- procedure / function / collection type
- 参数名、模式、类型、默认 SQL 值
- 返回类型
- 来源文件 SHA-256 与文档锚点
- confirmed fact 引用
- 执行策略
- 状态影响
- 清理要求

## Runtime candidate

当前只登记 5 个试点调用：

1. `DBE_OUTPUT` 直接输出：`PRINT` + `PRINT_LINE`
2. `DBE_OUTPUT` 缓冲区生命周期：`ENABLE` + `PUT` + `NEW_LINE`
3. `DBE_RAW` VARCHAR2 ↔ RAW 往返
4. `DBE_RAW` INTEGER ↔ RAW 大端往返
5. `DBE_SQL` 动态 SELECT 游标生命周期

所有试点 Oracle 状态均为：

```text
needs_verification
```

## DBE_SQL 清理边界

`DBE_SQL` 生命周期用例必须：

1. `REGISTER_CONTEXT` 打开游标
2. 正常路径执行动态 SQL 并读取结果
3. `SQL_UNREGISTER_CONTEXT` 关闭游标
4. 异常路径检查 `IS_ACTIVE`
5. 异常路径再次调用 `SQL_UNREGISTER_CONTEXT`
6. 重新抛出异常

不允许只验证正常路径而遗漏上下文清理。

## 不是已完成的事

- 未连接真实 GaussDB
- 未执行任何高级包调用
- 未确认输出、返回值或游标行为
- 未覆盖 22 个 `DBE_*` 支持包
- 未为 188 个 `DBMS_*` 不支持包生成负向 SQL
- 未实现高级包与 GUC overlay 的组合执行

因此当前结论只能是：**高级包接口合同和 runtime candidate 已静态闭环**，不能称为数据库行为验证通过。
