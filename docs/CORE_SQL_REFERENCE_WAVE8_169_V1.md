# SQL Reference Wave 8-169 Extraction V1

## 目标

抽取 高级包第二十二批切片：`3.12.2.22 DBE_UTILITY`（21个工具函数接口，页 2981–2995）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2981–2995） |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 21接口总账与全原型：FORMAT_ERROR_BACKTRACE/STACK/CALL_STACK三函数、GET_TIME（做差用途）、CANONICALIZE（1024字节截断）、COMMA_TO_TABLE/TABLE_TO_COMMA往返、DB_VERSION、EXEC_DDL_STATEMENT、EXPAND_SQL_TEXT_PROC（视图递归展开+schema前缀要求）、GET_CPU_TIME、GET_ENDIANNESS、GET_HASH_VALUE、GET_SQL_HASH/GET_SQL_HASH_FUNC（proc_outparam_override配对）、IS_BIT_SET、IS_CLUSTER_DATABASE、NAME_RESOLVE（OID隐式转换限制）、NAME_TOKENIZE（双引号/大写规则）、OLD_CURRENT_SCHEMA/USER
- 21组示例基线（含具体输出：SEG1、version:gaussdb、cpu 9851、endian 2、hash 15、D41D8CD9...、位图00100...、name_resolve解析、expand_sql展开结果等）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_169_oq_runtime` | GET_TIME返回值的时钟粒度与溢出行为、CANONICALIZE对多字节字符的字节截断边界、NAME_RESOLVE对同义词和授权检查失败的错误码需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_169_v1.yaml
generated/core_sql_reference_wave8_169_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_169.py
python scripts/build_core_sql_reference_wave8_169.py --check
python -m unittest tests.test_core_sql_reference_wave8_169 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DDL。
