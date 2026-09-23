# PDF 质量抽取增量：CREATE LLM FRESH SYNTAX（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接外部模型服务、不注入真实API Key。

目标章节：

- `general/ddl/create_llm.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_llm_fresh_syntax
```

新增 3 个非秘密静态语法代表：

```sql
CREATE LLM QUERY MODEL g_create_llm USING (
  MODEL = 'static-syntax-model',
  URL = 'https://llm-static-syntax.invalid/path/to/api',
  API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789'
);

CREATE LLM EMBED MODEL g_create_llm USING (
  MODEL = 'static-syntax-model',
  URL = 'https://llm-static-syntax.invalid/path/to/api',
  API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789'
);

CREATE LLM RERANK MODEL g_create_llm USING (
  MODEL = 'static-syntax-model',
  URL = 'https://llm-static-syntax.invalid/path/to/api',
  API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789'
);
```

`API_KEY` 占位符显式包含 `STATIC_SYNTAX_ONLY_NOT_A_SECRET`，长度满足正文16–256字节要求，但不是秘密；URL 使用 `.invalid` 非解析域，不指向任何外部服务。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_llm manifest | 0 | 1 |
| create_llm candidate | 0 | 3 |
| syntax feature | 未登记 | covered / representative |
| 全库 manifest | 904 | 905 |
| 全库 candidate | 5,441 | 5,444 |
| 全库 distinct SQL | 5,353 | 5,356 |
| 有 manifest 的因子包 | 305 | 306 |
| 无 manifest 的因子包 | 12 | 11 |
| generation model complete | 284 / 305 | 285 / 306 |

`create_llm` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明QUERY/EMBED/RERANK三种有限SQL形态可以静态生成，不证明：

- 外部模型服务存在、可解析或可调用
- HTTPS证书、CA链或TLS行为可信
- 真实API Key注入、保存或脱敏行为
- OBS加密密钥文件契约
- 模型登记、调用、预测或删除行为
- completion/embedding与completions/embeddings路径冲突已解决

`create_llm_feature_runtime` 继续保留为 `needs_profile`。

## 验证

- `tests.test_create_llm_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有外部服务连接，没有真实秘密注入，没有Git提交或推送。
