# SQL Reference Wave 8-143 Extraction V1

## 目标

抽取 高级包第二批切片：`3.12.1.2 PKG_UTIL` 接口总账与 LOB 全族（页 2651–2668；3.12 按切片分批覆盖）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2651–2668） |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- PKG_UTIL 接口总账（LOB/IO/RAW/RANDOM/FILE/EXCEPTION/APP 七族约50个接口）
- LOB 基础版全原型：GET_LENGTH(INTEGER版与BIGINT版)/READ(mode 0/1/2)/WRITE/APPEND/COMPARE(len默认1073741771、-1/0/1语义)/MATCH(match_nth)/RESET(value默认'0')
- LOB HUGE 版全原型：READ_HUGE(含fd形式)/WRITEAPPEND_HUGE(len NULL全写)/APPEND_HUGE/COPY_HUGE(dest/src_offset默认1)/BLOB_RESET/CLOB_RESET/LOADBLOBFROMFILE/LOADCLOBFROMFILE/CONVERTTOBLOB_HUGE/CONVERTTOCLOB_HUGE/WRITE_HUGE(覆盖语义)
- BFILE 三函数（OPEN 仅'r'、CLOSE）与生命周期闭环（OPEN→READ/LOAD→CLOSE）
- 长度单位约定（BLOB字节/CLOB字符）与基础版/HUGE版签名差异（INT vs BIGINT、RECORD+INOUT位置出参）

## Open questions

| ID | 内容 |
|---|---|
| `pkgutil_wave8_143_oq_runtime` | LOADBLOBFROMFILE/LOADCLOBFROMFILE的INOUT实际读写位置在amount超过剩余内容时的返回语义、LOB_CONVERTTO*_HUGE字符/字节混合换算边界、BFILE_OPEN在safe_data_path白名单外的路径行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_143_v1.yaml
generated/core_sql_reference_wave8_143_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_143.py
python scripts/build_core_sql_reference_wave8_143.py --check
python -m unittest tests.test_core_sql_reference_wave8_143 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作LOB/BFILE文件。
