# SQL Reference Wave 8-187 Extraction V1

## 目标

抽取 附录章：`1.14 附录`（扩展函数/扩展语法/美元引用/行表达式函数白名单，页 1894–1961）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 68 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 1.14.1 扩展函数：访问权限查询函数（has_sequence_privilege两种签名）、触发器函数（pg_get_triggerdef两种签名）
- 1.14.2 扩展语法：CREATE TABLE外键REFERENCES（MATCH FULL/PARTIAL/SIMPLE）、CREATE/DROP EXTENSION（内部使用）、CREATE/ALTER/DROP AGGREGATE
- 1.14.3 美元引用字符串常量：语法结构（tag界定）、单引号转义替代方案、示例基线
- 1.14.4 行表达式函数白名单：ILM策略支持的函数OID白名单（数百个内部函数按类别——数值/文本/布尔/日期时间/位串/正则/比较/哈希等）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_187_oq_runtime` | 行表达式函数白名单的完整覆盖度、扩展函数的权限要求和调用限制、美元引用嵌套场景的支持程度需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_187_v1.yaml
generated/core_sql_reference_wave8_187_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_187.py
python scripts/build_core_sql_reference_wave8_187.py --check
python -m unittest tests.test_core_sql_reference_wave8_187 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
