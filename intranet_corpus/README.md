# 内网语料投放目录

此目录只保存公司内网中的产品文档章节文本，实际语料已被 `.gitignore` 排除，禁止提交到代码仓库。

目录必须使用稳定英文 ID，并至少包含三层：

```text
intranet_corpus/
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
- 支持 UTF-8 的 `.txt`、`.md`、`.html`、`.htm`。
- 保留稳定换行，source ledger 依赖行号和 SHA-256 对账。
- 不要把 5800 页合并成一个文件，也不要只投放目录页。
