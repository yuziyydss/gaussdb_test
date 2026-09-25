# Full-Document Catalog V1

## 目标

`generated/full_document_catalog/catalog.json` 是当前本地工作区的权威全书目录。它把 83 个抽取批次 catalog 中的唯一章节合并为一个可审计产物，同时保留每个章节的来源 catalog 引用和哈希。

它解决的是“PDF 是否已经被目录化/抽取到”的进度问题，不等于全书语义建模或数据库行为验证。

## 构建结果

| 指标 | 当前值 |
|---|---:|
| PDF 物理页 | 5,686 |
| front matter | 1–49，共 49 页 |
| 正文页 | 50–5,686，共 5,637 页 |
| 正文页覆盖 | 5,637 / 5,637 |
| 正文缺口 | 0 页 |
| PDF outline 条目 | 1,964 |
| 唯一抽取章节 | 515 |
| 来源 catalog | 83 |
| 来源正文哈希验证 | 515 / 515 |

## 合并规则

1. 所有来源 catalog 必须有一致的：
   - `document_id`
   - `document_version`
   - `parent_pdf_sha256`
   - `product_version`
   - `release_date`
   - PDF outline
   - extraction rules
   - parent PDF metadata

2. 章节按以下主键去重：

```text
variant + outline_path
```

3. 同一主键在任何字段上冲突时，构建直接失败。

4. 每个合并章节保留：

```text
source_catalog_refs
```

用于追踪它来自哪些批次 catalog。

5. 页面 1–49 被显式登记为 front matter：

- 封面
- 版权
- 目录
- 前言

这些页面不进入正文抽取分母。

## 顶级章节覆盖

| 顶级章节 | 唯一章节 | 覆盖页数 |
|---|---:|---:|
| 1 SQL参考 | 343 | 1,912 |
| 2 SQL参考-M-Compatibility兼容模式 | 124 | 577 |
| 3 存储过程 | 18 | 594 |
| 4 兼容性说明 | 6 | 441 |
| 5 工具参考 | 11 | 535 |
| 6 日志参考 | 1 | 26 |
| 7 数据库运行参数说明 | 4 | 752 |
| 8 系统表和系统视图 | 3 | 536 |
| 9 系统表和系统视图-M-Compatibility兼容模式 | 1 | 8 |
| 10 Schema | 1 | 187 |
| 11 Schema-M-Compatibility兼容模式 | 1 | 46 |
| 12 WDR报告 | 1 | 15 |
| 13 ASP报告 | 1 | 8 |

## 命令

构建权威 catalog：

```bash
python scripts/build_full_document_catalog.py
```

执行结构覆盖审计：

```bash
python scripts/audit_full_document_catalog.py
```

执行本地来源哈希验证：

```bash
python scripts/audit_full_document_catalog.py --verify-sources
```

输出文件：

- `generated/full_document_catalog/catalog.json`
- `generated/full_document_catalog/coverage.json`

## 边界

- catalog 覆盖不等于语义 schema 完成。
- 章节正文哈希验证不等于数据库行为验证。
- `source_catalog_refs` 中的许多来源仍在本地 `work/` 目录，未全部纳入 Git。
- 非 SQL 主题已有 facts，但多数尚未建立专用 Schema。
- front matter 被显式排除，不计入正文抽取缺口。
