# SQL Reference Wave 8-153 Extraction V1

## 目标

抽取 高级包第十二批切片：`3.12.2.10 DBE_LOB` 第一切片——接口总账与长度/读写/比较族（页 2768–2780）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2768–2780） |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 容量口径：CLOB/BLOB/BFILE最大32TB、LOBMAXSIZE 1073741771字节、A库空格00 vs GaussDB ASCII 32
- 41个接口总账
- 长度对：GET_LENGTH（INTEGER、2GB）/LOB_GET_LENGTH（BIGINT、32TB、支持BFILE）
- OPEN（兼容占位）、READ/LOB_READ（amount 1~32767、BFILE三原型、INOUT实际长度）
- WRITE/WRITE_APPEND/LOB_WRITE_APPEND（32767上限、off_set边界）
- COPY/LOB_COPY（字节/字符单位）、ERASE/LOB_ERASE（填0/填空格差异）
- MATCH（nth边界：0/null语义）、COMPARE（-1/0/1、默认len 1073741312、双超长返回0）、SUBSTR/LOB_SUBSTR、STRIP/LOB_STRIP（newlen边界）
- BFILE前置（BFILEOPEN）、基础版vs LOB_版差异总则、amount统一边界与偏移单位约定

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_153_oq_runtime` | LOB_READ的INOUT amount在BFILE跨页读取时的实际返回长度语义、CLOB字符偏移与多字节字符的边界、MATCH在32TB大对象上的性能与并发读写行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_153_v1.yaml
generated/core_sql_reference_wave8_153_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_153.py
python scripts/build_core_sql_reference_wave8_153.py --check
python -m unittest tests.test_core_sql_reference_wave8_153 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作LOB/BFILE。
