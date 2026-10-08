# SQL Reference Wave 8-123 Extraction V1

## 目标

抽取 M 兼容 `字符串函数`（2.5.7，27 页大节单节成批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 26 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 字符串函数通用规则（位置从1计数、长度参数四舍五入、SQL_ASCII下八函数未预期风险）
- ASCII/BIN/BIT_LENGTH/CHAR_LENGTH/LENGTH字节与字符计数差异（你好=2字符6字节）
- CONCAT/CONCAT_WS NULL语义、ELT/FIELD/FIND_IN_SET、EXPORT_SET/FORMAT
- INSERT/INSTR/LOCATE位置与搜索、LEFT/RIGHT/LOWER/UPPER/LCASE/UCASE
- LPAD/RPAD/LTRIM/RTRIM/TRIM、MAKE_SET/MID/OCT/ORD/POSITION
- QUOTE/RANDOM_BYTES([1,1024])/REPEAT(max_allowed_packet上限)/REPLACE/REVERSE
- SHA/SHA1/SHA2/MD5安全警告（日志记录明文）
- SOUNDEX/SPACE/STRCMP/SUBSTR五形式规则/SUBSTRING_INDEX正负count
- TO_BASE64/UNHEX/HEX/COMPRESS/UNCOMPRESS/UNCOMPRESSED_LENGTH

## Open questions

| ID | 内容 |
|---|---|
| `m_str_wave8_123_oq_runtime` | SQL_ASCII下多字节字符串函数的未预期结果具体边界、EXPORT_SET与MAKE_SET在大参数值下的行为、RANDOM_BYTES随机性质量需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_123_v1.yaml
generated/core_sql_reference_wave8_123_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_123.py
python scripts/build_core_sql_reference_wave8_123.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_123.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容字符串函数。
