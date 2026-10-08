# SQL Reference Wave 8-150 Extraction V1

## 目标

抽取 高级包第九批切片：`3.12.2.5 DBE_FILE` 第二切片——GET_POS、NCHAR 族与综合示例（页 2749–2763），DBE_FILE 收官。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2749–2763） |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- GET_POS（字节偏移，与SEEK配合基线 position is: 1）
- NCHAR族五接口全原型：FOPEN_NCHAR（国家字符集模式、50个上限）/WRITE_NCHAR（UTF8写入）/WRITE_LINE_NCHAR/FORMAT_WRITE_NCHAR（arg1..arg5，比CHAR版少一个）/READ_LINE_NCHAR
- NCHAR族设计约束（仅FILE_TYPE句柄、必须FOPEN_NCHAR打开）与限制（max_line_size/elf/INVALID_OPERATION）
- 综合示例基线：CREATE DIRECTORY前置、打开关闭、五行写读（A/BC/ABC/格式化/RAW 414243）、COPY+CLOSE_ALL、GET_RAW 4142430A、GET_ATTR file length: 4、RENAME+SEEK/GET_POS、FLUSH立即可读、NCHAR读写（ABCDEABCDE/hello, world）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_150_oq_runtime` | FOPEN_NCHAR在非UTF8数据库字符集下的实际编码转换行为、FORMAT_WRITE_NCHAR与FORMAT_WRITE参数个数差异（5对6）是否有意限制、FLUSH后被另一句柄立即读取的可见性时序需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_150_v1.yaml
generated/core_sql_reference_wave8_150_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_150.py
python scripts/build_core_sql_reference_wave8_150.py --check
python -m unittest tests.test_core_sql_reference_wave8_150 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不读写文件。
