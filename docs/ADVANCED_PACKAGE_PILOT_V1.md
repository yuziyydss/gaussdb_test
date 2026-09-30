# Advanced Package Pilot V1

## 目标

`environments/advanced_packages_v1.yaml` 将高级包从普通 SQL statement factor 中拆出来，作为独立的 PL/SQL 接口合同建模。试点覆盖：

- `DBE_OUTPUT`
- `DBE_RAW`
- `DBE_SQL`
- `DBE_MATCH`
- `DBE_UTILITY`
- `DBE_LOB`
- `DBE_FILE`
- `DBE_OBFUSCATION_TOOLKIT`
- `DBE_XMLGEN`
- `DBE_ALERT`
- `DBE_TASK`
- `DBE_SESSION`
- `DBE_RANDOM`
- `DBE_APPLICATION_INFO`
- `DBE_SCHEDULER`
- `DBE_COMPRESSION`
- `DBE_DESCRIBE`
- `DBE_HEAT_MAP`
- `DBE_ILM`
- `DBE_ILM_ADMIN`
- `DBE_STATS`
- `DBE_XMLDOM`
- `DBE_XMLPARSER`

当前目标是**可静态审计、可生成 runtime candidate、可后续接实机验证**，不是宣称数据库行为验证通过。

## 接口规模

| Package | 接口数 |
|---|---:|
| `DBE_OUTPUT` | 10 |
| `DBE_RAW` | 22 |
| `DBE_SQL` | 14 |
| `DBE_MATCH` | 1 |
| `DBE_UTILITY` | 14 |
| `DBE_LOB` | 19 |
| `DBE_FILE` | 8 |
| `DBE_OBFUSCATION_TOOLKIT` | 7 |
| `DBE_XMLGEN` | 2 |
| `DBE_ALERT` | 5 |
| `DBE_TASK` | 5 |
| `DBE_SESSION` | 4 |
| `DBE_RANDOM` | 2 |
| `DBE_APPLICATION_INFO` | 4 |
| `DBE_SCHEDULER` | 3 |
| `DBE_COMPRESSION` | 6 |
| `DBE_DESCRIBE` | 3 |
| `DBE_HEAT_MAP` | 1 |
| `DBE_ILM` | 2 |
| `DBE_ILM_ADMIN` | 5 |
| `DBE_STATS` | 36 |
| `DBE_XMLDOM` | 75 |
| `DBE_XMLPARSER` | 8 |
| 合计 | 251 |

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

当前已登记 27 个试点调用，覆盖：

- `DBE_OUTPUT`：直接输出、缓冲区生命周期、`PUT_LINE`、缓冲区大小、`DISABLE`
- `DBE_RAW`：VARCHAR2/INTEGER往返、长度、子串、连接、复制、比较、位运算、DOUBLE/FLOAT/NUMBER往返
- `DBE_SQL`：动态 SELECT 游标生命周期、绑定变量、`RUN_AND_NEXT`
- `DBE_TASK`：提交、运行、更新、完成、取消
- `DBE_XMLDOM`：document创建、遍历、属性、输出、释放生命周期
- `DBE_XMLDOM`：22个文档本地overload生命周期
- `DBE_STATS`：历史保留时间与最早可用时间只读函数

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

## 静态链

可以用一条命令重建 runtime dry run 与 Evidence Bundle，并校验哈希稳定：

```bash
python scripts/build_advanced_package_chain.py --check
```

详见 [Advanced Package Static Chain](ADVANCED_PACKAGE_CHAIN.md)。

## 扩展候选

22个支持的 `DBE_*` 包已进入 Candidate Matrix 并建立静态接口合同。新增的 8 个包保持 manual review：`DBE_XMLDOM` 覆盖核心类型与节点接口首批，`DBE_STATS` 覆盖核心统计信息维护子集；后续仍需按文档补全重载和长签名。详见 [Advanced Package Candidate Matrix](ADVANCED_PACKAGE_CANDIDATE_MATRIX.md)。

## Coverage & Policy Audit

新增8包的覆盖缺口和执行策略复审由独立 Policy Audit 维护：99/99 个 distinct callable、126/126 个文档签名已建模，38 个接口已进入 runtime case 设计，6 个 ILM 接口首批 block。详见 [Advanced Package Policy Audit](ADVANCED_PACKAGE_POLICY_AUDIT.md)。

## Evidence Bundle

Pilot V1 现在有独立 Evidence Bundle：

```bash
python scripts/build_advanced_package_evidence_bundle.py
python scripts/verify_advanced_package_evidence_bundle.py
```

输出：

```text
generated/advanced_package_pilot/evidence_bundle.json
```

## 不是已完成的事

- 未连接真实 GaussDB
- 未执行任何高级包调用
- 未确认输出、返回值或游标行为
- 新增包的完整重载、长签名与运行时用例尚未补全
- 未为 188 个 `DBMS_*` 不支持包生成负向 SQL
- 未实现高级包与 GUC overlay 的组合执行

因此当前结论只能是：**高级包接口合同和 runtime candidate 已静态闭环**，不能称为数据库行为验证通过。
