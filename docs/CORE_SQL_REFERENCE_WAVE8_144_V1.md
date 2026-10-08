# SQL Reference Wave 8-144 Extraction V1

## 目标

抽取 高级包第三批切片：`3.12.1.2 PKG_UTIL` 的 IO/RAW/RANDOM/FILE 族（页 2669–2681）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2669–2681） |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- IO_PRINT（format/is_one_line）、RAW四函数（GET_LENGTH、FROM_VARCHAR2、FROM/TO_BINARY_INTEGER含1/2/3字典序）
- RANDOM双函数（0~1随机数、15位有效数字）与安全场景不建议使用提示
- FILE全生命周期：SET_DIRNAME（PG_DIRECTORY注册与路径匹配）、OPEN（50个上限、r/w/a、elf检测）、SET_MAX_LINE_SIZE（1~32767默认1024）、IS_CLOSE、READ（INVALID_OPERATION）、READLINE（默认max_line_size）、WRITE（BUFFER 32767上限与PUT总和）、NEWLINE/WRITELINE、READ_RAW（默认全部最大1G）/WRITE_RAW、FLUSH（行终结符前提）、CLOSE、REMOVE（权限）、RENAME（overwrite默认false）、SIZE/BLOCK_SIZE/EXISTS、GETPOS/SEEK/CLOSE_ALL
- 安全与路径约束：PG_DIRECTORY注册、safe_data_path开启后仅可操作白名单路径、RANDOM安全提示

## Open questions

| ID | 内容 |
|---|---|
| `pkgutil_wave8_144_oq_runtime` | FILE_OPEN同时打开50个文件上限的会话级判定、FILE_READ_RAW默认1G上限在接近边界时的行为、safe_data_path开启后FILE_REMOVE/FILE_RENAME的权限校验顺序需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_144_v1.yaml
generated/core_sql_reference_wave8_144_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_144.py
python scripts/build_core_sql_reference_wave8_144.py --check
python -m unittest tests.test_core_sql_reference_wave8_144 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作文件系统。
