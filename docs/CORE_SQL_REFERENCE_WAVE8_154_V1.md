# SQL Reference Wave 8-154 Extraction V1

## 目标

抽取 高级包第十三批切片：`3.12.2.10 DBE_LOB` 第二切片——临时/拼接/BFILE装载/转换族与示例（页 2781–2791），DBE_LOB 收官。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2781–2791） |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CREATE_TEMPORARY/FREETEMPORARY（语法兼容对）、APPEND/LOB_APPEND
- BFILE类型定义（directory/filename/fd）、FILEOPEN（会话10个上限、仅r模式）/FILECLOSE/BFILEOPEN('R')/BFILECLOSE、BFILENAME构造
- LOAD六函数：LOADFROMFILE（amount 1~32767）、LOADFROMBFILE（BIGINT双原型）、LOADBLOBFROMFILE(BFILE)、LOADCLOBFROMFILE(BFILE)、共同偏移规则（amount+src_offset > len+1报错）
- CONVERTTOBLOB/CLOB 四函数：INTEGER版不支持>1GB、LOB_版BIGINT支持>1GB
- GETCHUNKSIZE（TOAST_MAX_CHUNK_SIZE）、LOB_WRITE（覆盖语义）
- 示例基线：GET_LENGTH=8、READ输出0123、BFILE substr res:41、多接口WRITE/WRITE_APPEND/ERASE/COPY流程

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_154_oq_runtime` | 会话级10个BFILE上限的计数与回收时机、LOADCLOBFROMFILE以RAW返回与CLOB目标的实际语义一致性、CONVERTTO族在多字节CLOB上的字节/字符换算边界需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_154_v1.yaml
generated/core_sql_reference_wave8_154_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_154.py
python scripts/build_core_sql_reference_wave8_154.py --check
python -m unittest tests.test_core_sql_reference_wave8_154 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不操作LOB/BFILE。
