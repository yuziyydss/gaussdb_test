# Core Text Search Wave 7-6 Extraction V1

## 目标

细抽 `1.6.12 文本检索函数和操作符`，覆盖文本检索操作符、query/vector构造、高亮排名、查询重写以及解析和词典调试函数。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 397–404，共8页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### 文本检索操作符

- `@@`：tsvector与tsquery匹配。
- `@@@`：`@@`的同义词。
- `||`：连接tsvector。
- `&&`、`||`、`!!`、`<->`：tsquery的与、或、非和词组操作。
- `@>`、`<@`：tsquery包含与被包含。
- tsvector/tsquery还支持普通B-tree比较操作符。

### 构造与编辑

- `get_current_ts_config`
- `plainto_tsquery`
- `phraseto_tsquery`
- `to_tsquery`
- `to_tsvector`
- `to_tsvector_for_batch`
- `setweight`
- `strip`
- `tsquery_phrase`
- `querytree`

关键边界：

- `plainto_tsquery`使用`&`连接并忽略标点。
- `phraseto_tsquery`使用`<->`连接并忽略标点。
- `setweight`权重仅支持A/B/C/D。
- `strip`删除位置信息和权重。
- `to_tsvector_for_batch`示例语义与`to_tsvector`一致。

### 统计、排名与高亮

- `length`
- `numnode`
- `ts_headline`
- `ts_rank`
- `ts_rank_cd`
- `ts_stat`

关键边界：

- `numnode`统计单词加操作符数量。
- `ts_headline`高亮查询匹配项。
- `ts_rank`执行文档查询排名。
- `ts_rank_cd`使用覆盖密度排序。

### 查询重写与调试

- `ts_rewrite`两个重载
- `ts_debug`
- `ts_lexize`
- `ts_parse`两个重载
- `ts_token_type`两个重载

关键边界：

- 文本检索调试函数为内部使用功能，不建议用户使用。
- `ts_rewrite`可基于目标tsquery或SELECT结果重写查询。
- `ts_parse`和`ts_token_type`均支持解析器名称或OID。

## Open questions

| ID | 内容 |
|---|---|
| `textsearch_wave7_6_oq_operator_config_matrix` | 操作符和构造函数在不同config、词典、标点、词距和NULL输入下的输出矩阵 |
| `textsearch_wave7_6_oq_rank_debug_evidence` | 高亮、排名、重写和调试函数在真实文档、权重、normalization和并发检索下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_textsearch_wave7_6_v1.yaml
generated/core_textsearch_wave7_6_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_textsearch_wave7_6.py
python scripts/build_core_textsearch_wave7_6.py --check
python -m pytest -q tests/test_core_textsearch_wave7_6.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不构造tsvector/tsquery、不执行排名或查询重写。
- 不宣称目标环境行为验证通过。
