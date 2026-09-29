# Core Vector Database Wave 7-2 Extraction V1

## 目标

细抽 `1.6.51 向量数据库函数与操作符`，覆盖向量距离/操作、类型与I/O、向量索引检查以及BM25相似检索诊断。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 1006–1029，共24页 |
| 结构化 facts | 30 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 30 / 30 |

## 覆盖内容

### 向量距离与操作

- `l2_distance`
- `vector_l2_squared_distance`
- `cosine_distance`
- `vector_spherical_distance`
- `inner_product`
- `vector_negative_inner_product`
- `vector_dims`
- `vector_norm`
- `vector_add`
- `vector_sub`
- `vector_lt/le/eq/ne/ge/gt/cmp`
- `vector_accum/combine/avg`
- `bool_vector_dims/cmp/eq`

### 向量类型与I/O

- `floatvector`
- `vector_to_array`
- `text_to_vector`
- `vector_in/out/send/recv/typmod_in`
- `boolvector`
- `boolvector_to_array`
- `text_to_boolvector`
- `bool_vector_in/out/send/recv/typmod_in`

关键边界：

- 向量成员仅支持单精度。
- 向量计算仅支持相同维度。
- 建表必须指定维度；插入或维度变更时维度不一致报错。
- 向量数据不支持Null、Nan、Inf元素。
- `boolvector`仅支持等于操作，不支持大小比较。
- 元素过大可能导致距离结果为NAN或INF。

### 向量索引与操作符

- `gs_vector_index_options`
- `gs_diskann_inspect`
- `gs_ivfflat_inspect`
- 距离、内积、加、减、比较和相等性操作符

### BM25相似检索

- `###`
- `gs_ts_dict_add_definition`
- `gs_bm25_tokenize`
- `gs_bm25_inspect`
- `gs_bm25_distance_text`
- `gs_bm25_distance_textarr`
- `gs_bm25_docid_info`
- `gs_bm25_document_info`
- `gs_bm25_index_hash_info`
- `gs_bm25_token_info`
- `gs_bm25_posting_info`

关键边界：

- BM25相似度和距离函数只在使用BM25索引检索时有效。
- `gs_ts_dict_add_definition`等同DDL，会清空词典缓存，不建议在线使用。
- `gs_bm25_token_info`和`gs_bm25_posting_info`不建议业务期间使用，可能降低索引增删效率。

## Open questions

| ID | 内容 |
|---|---|
| `vector_wave7_2_oq_distance_index_matrix` | 向量距离、操作符、类型转换和索引在不同维度、异常值、溢出、分区索引和负载下的输出矩阵 |
| `vector_wave7_2_oq_bm25_evidence` | BM25分词、词典增量、相似度、docid/token/posting诊断在真实语料、并发增删、分区索引和业务负载下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_vector_wave7_2_v1.yaml
generated/core_vector_wave7_2_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_vector_wave7_2.py
python scripts/build_core_vector_wave7_2.py --check
python -m pytest -q tests/test_core_vector_wave7_2.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不创建向量/BM25索引、不训练模型、不执行相似检索、不更新词典。
- 不宣称目标环境行为验证通过。
