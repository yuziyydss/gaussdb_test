# 内网语料投放目录

此目录只保存公司内网中的 source catalog 和产品文档章节文本，实际产物已被 `.gitignore` 排除，禁止提交到代码仓库。对于带书签 PDF，不要手工复制正文；使用 `scripts/extract_pdf_sections.py` 生成可重算的目录和章节边界。

目录必须使用稳定英文 ID，并至少包含三层：

```text
intranet_corpus/
  catalog.json
  general/
    ddl/
      create_view.txt
      create_index.txt
    dml/
      select.txt
      insert.txt
  m_compat/
    ddl/
      create_view.txt
    dml/
      select.txt
```

- 第一层 `variant`：`general` 表示通用语法；`m_compat`、`b_compat` 等兼容模式必须隔离。
- 第二层 `category`：例如 `ddl`、`dml`、`dcl`。
- 第三层及以后：一个文件对应一个可独立抽取、可独立验收的章节。
- `catalog.json` 绑定父 PDF SHA-256、文档版本、完整书签路径、精确起止坐标、章节路径和章节 SHA-256；没有 catalog 证据的 PDF 章节不能宣称属于整本 PDF 覆盖。
- 支持 UTF-8 的 `.txt`、`.md`、`.html`、`.htm`。
- 保留稳定换行，source ledger 依赖行号和 SHA-256 对账。
- 不要把 5800 页合并成一个文件，也不要只投放目录页。
- 默认拆章命令仅产生五章校准集；全量通用 SQL 使用 `--all-general-statements --replace-catalog`，通用与 M-Compatibility 一次冻结使用 `--all-sql-statements --replace-catalog`。
