# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LIII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不调用内核AUTOHINT任务、不执行EXPLAIN AUTOHINT。

目标章节：

- `general/utility/explain_autohint.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `explain_autohint` 从无普通manifest、生成模型未闭合提升为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

新增 2 个 manifest：

- `manifest_explain_autohint_kernel_syntax`
- `manifest_explain_autohint_user_call_negative`

新增 3 个候选：

| 类型 | 候选 | 预期 |
|---|---|---|
| 正向 | `EXPLAIN AUTOHINT 1 PLAN '[]' FOR SELECT 1;` | syntax_only success |
| 负向 | 原文示例1：`EXPLAIN AUTOHINT 2 PLAN ... FOR SELECT ...` | 原文确认错误 |
| 负向 | 原文示例2：`EXPLAIN AUTOHINT 2 EXECUTE ... FOR SELECT ...` | 原文确认错误 |

用户直接调用错误来自原文：

```text
ERROR: Can not get exploration cache for cache id: 2.
```

模型登记：

- `oracle_status = confirmed`
- `error_message_regex = Can not get exploration cache for cache id: 2`

同时修正生成器基础校验：单引号字符串内的JSON大括号不再被误判为未解析BNF占位符；字符串外的大括号仍会拒绝。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| explain_autohint static coverage | false | true |
| static coverage complete | 229 / 307 | 230 / 308 |
| generation model complete | 297 / 307 | 298 / 308 |
| 全库 manifest | 929 | 931 |
| 全库 candidate | 5,502 | 5,505 |
| 全库 distinct SQL | 5,412 | 5,415 |
| 有 manifest 的因子包 | 307 | 308 |
| 无 manifest 的因子包 | 10 | 9 |

## 保留边界

本轮只证明有限静态语法和原文错误身份，不证明：

- 内核AUTOHINT任务实际调用协议
- cache_id、计划HASH或会话内部上下文行为
- PLAN/EXECUTE结果存储、HINT探索或推荐行为
- 用户直接调用以外的错误路径

## 验证

- `tests.test_static_coverage_closures_20260921_liii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
