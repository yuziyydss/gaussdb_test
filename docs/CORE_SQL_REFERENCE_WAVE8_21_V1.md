# SQL Reference Wave 8-21 Extraction V1

## 目标

抽取 `1.13.9.9 COPY`，补齐服务端导入导出语法、权限与安全路径、文本/CSV/FIXED/BINARY格式、错误容错和批量导入辅助能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.9` | 24 | COPY |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 24 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- COPY FROM/TO主语法、STDIN/STDOUT与query导出
- 服务端文件权限、`safe_data_path`白名单和敏感文件保护
- 表/视图对象边界、SELECT/INSERT权限、字段列表与缺省值
- 服务端`COPY`与客户端`\COPY`执行环境差异
- 列表达式、生成列、触发器、规模限制与保护系统表
- TEXT/CSV/FIXED/BINARY格式与互斥参数
- 分隔符、FORMATTER定长位置、NULL、HEADER、FILEHEADER、FREEZE
- FORCE NOT NULL、FORCE QUOTE与ENCODING
- LOG ERRORS、LOG ERRORS DATA和REJECT LIMIT容错

## Open questions

| ID | 内容 |
|---|---|
| `copy_wave8_21_oq_runtime` | COPY在真实文件编码、大文件、并行、容错、触发器、生成列和权限白名单组合下的导入导出结果与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_21_v1.yaml
generated/core_sql_reference_wave8_21_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_21.py
python scripts/build_core_sql_reference_wave8_21.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_21.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行COPY或文件导入导出。
