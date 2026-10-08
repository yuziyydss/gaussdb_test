# SQL Reference Wave 8-157 Extraction V1

## 目标

抽取 高级包第十六批切片：`3.12.2.15 DBE_RANDOM`（伪随机数）与 `3.12.2.16 DBE_RAW`（RAW操作26接口全量）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2813–2827，两个完整小节） |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_RANDOM：SET_SEED/GET_VALUE（≥min、<max、15位有效数字）、伪随机与安全场景不建议、TRUNC整数用法基线
- DBE_RAW：RAW十六进制/二进制双形态说明、系统目录权限（仅使用权限）、26接口全原型
- CAST族六对（INTEGER/BINARY_DOUBLE/BINARY_FLOAT/NUMBER/NVARCHAR2/VARCHAR2与RAW互转，endianess 1/2/3、最短长度约束）
- 位运算（BIT_OR历史TEXT说明、BIT_AND/BIT_COMPLEMENT/BIT_XOR）、SUBSTR（历史BLOB说明）
- COMPARE（pad扩展）、CONCAT（12参数、32767上限）、CONVERT（PG_CONVERSION规则、不存在则原样返回）、COPIES/OVERLAY/REVERSE/TRANSLATE（舍弃）/TRANSLITERATE（pad填充）/XRANGE（回绕拼接）
- 示例基线：20余组十六进制输入输出对（170↔000000AA等）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_157_oq_runtime` | CONVERT在PG_CONVERSION规则外的编码对行为、OVERLAY/TRANSLITERATE的pad多字节取首字节边界、DBE_RANDOM伪随机序列在不同会话间的一致性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_157_v1.yaml
generated/core_sql_reference_wave8_157_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_157.py
python scripts/build_core_sql_reference_wave8_157.py --check
python -m unittest tests.test_core_sql_reference_wave8_157 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行RAW操作。
