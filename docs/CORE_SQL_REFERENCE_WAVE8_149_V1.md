# SQL Reference Wave 8-149 Extraction V1

## 目标

抽取 高级包第八批切片：`3.12.2.5 DBE_FILE` 第一切片——接口总账与文本/二进制模式族（页 2734–2748，OPEN/FOPEN 到 SEEK）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2734–2748） |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 编码注意事项：FOPEN数据库字符集/FOPEN_NCHAR UTF8、READ_LINE编码校验、客户端与数据库字符集一致、ASCII库写中文风险
- FILE_TYPE（id/datatype 1,2/byte_mode，私有字段禁改）
- 25个接口总账与双句柄设计（OPEN返回INTEGER vs FOPEN返回FILE_TYPE）
- OPEN/FOPEN（50个上限、六种open_mode、max_line_size 1~32767默认1024、elf检测、PG_DIRECTORY/safe_data_path）
- IS_CLOSE/IS_OPEN（空入参语义差异）、READ_LINE（INVALID_OPERATION、len默认max_line_size）
- WRITE（累计长度≥max_line_size刷新时报错）、NEW_LINE、WRITE_LINE（flush参数）、FORMAT_WRITE（%s与arg1..arg6）、GET_RAW/PUT_RAW
- FLUSH/CLOSE/CLOSE_ALL、REMOVE（权限）、RENAME（overwrite语义）、COPY（start/end_line）、GET_ATTR（不存在返回NULL）、SEEK（absolute/relative优先级）
- 全接口目录与safe_data_path安全约束

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_149_oq_runtime` | 同会话50个文件上限的计数与回收时机、max_line_size边界（32767）下WRITE刷新报错的具体错误码、safe_data_path白名单对COPY跨目录的判定需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_149_v1.yaml
generated/core_sql_reference_wave8_149_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_149.py
python scripts/build_core_sql_reference_wave8_149.py --check
python -m unittest tests.test_core_sql_reference_wave8_149 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不读写文件。
