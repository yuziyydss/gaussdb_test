# SQL Reference Wave 8-1 Extraction V1

## 目标

继续抽取 SQL 参考中的高价值非函数章节，覆盖 `1.11 事务控制` 与 `1.12 全文检索`。本阶段关注命令语义、全文检索数据流、索引/配置约束、排序/高亮/改写/统计能力与硬限制。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.11` | 1 | 事务控制 |
| `1.12` | 24 | 全文检索 |
| 合计 | **24** | **2章** |

> 页1147由 `1.11` 收尾和 `1.12` 起始共享；manifest 按各章节切片记录，页级统计去重后为 24 页。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 24 |
| 结构化 facts | 15 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- 事务的原子性表述
- `START TRANSACTION` / `BEGIN`
- `SET TRANSACTION` / `SET LOCAL TRANSACTION`
- `COMMIT` / `END`
- `ROLLBACK` 及单次多语句请求失败回滚语义
- 全文检索 token → 词典 → 词素 → `tsvector` 的处理管线
- `tsvector` / `tsquery` / `@@`
- 数据库内/外文档的建模方式
- GIN 索引与两参数 `to_tsvector` 的索引一致性要求
- 文本搜索配置与 `default_text_search_config`
- `ts_rank` / `ts_rank_cd` 排序语义
- `ts_headline`、`ts_rewrite`、`ts_stat`、`ts_lexize`
- `tsvector` / `tsquery` 的硬限制

## Open questions

| ID | 内容 |
|---|---|
| `sqlref_wave8_1_oq_fts_runtime_matrix` | `ngram/pound`、`english/simple` 配置在真实语料下的排序、GIN索引、高亮、改写和限制边界需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_1_v1.yaml
generated/core_sql_reference_wave8_1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_1.py
python scripts/build_core_sql_reference_wave8_1.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行事务或全文检索函数。
