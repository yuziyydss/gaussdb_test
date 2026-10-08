# SQL Reference Wave 8-127 Extraction V1

## 目标

抽取 M 兼容 `窗口函数`、`加解密函数`、`流程控制函数` 与 `自治事务特性函数`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 15 |
| 结构化 facts | 21 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- 窗口函数over_clause/window_spec/frame_clause语法、NULLS FIRST/LAST默认规则
- DELTA（M特有，over中rows不影响结果、仅数值类型、固定rows 1 preceding）
- DENSE_RANK/ROW_NUMBER的s2+enable_conflict_funcs M行为差异开关
- FIRST_VALUE/LAST_VALUE/LAG/LEAD/NTILE/PERCENT_RANK/RANK语义
- AES_DECRYPT/AES_ENCRYPT参数体系（KDF PBKDF2/HKDF、IV规则）、gsql不记录执行历史、SQL_ASCII风险、往返解密基线
- IF/IFNULL/NULLIF流程控制三函数与示例
- M兼容不支持自治事务 + gs_autonomous_transaction_detail等函数说明

## Open questions

| ID | 内容 |
|---|---|
| `m_wf_aes_wave8_127_oq_runtime` | M兼容DENSE_RANK/ROW_NUMBER在enable_conflict_funcs开启前后的行为差异矩阵、DELTA固定rows 1 preceding的边界用例、AES加解密在SQL_ASCII字符集下的编码一致性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_127_v1.yaml
generated/core_sql_reference_wave8_127_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_127.py
python scripts/build_core_sql_reference_wave8_127.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_127.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容窗口/加解密语句。
