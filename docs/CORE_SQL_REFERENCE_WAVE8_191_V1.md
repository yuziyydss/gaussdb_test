# SQL Reference Wave 8-191 Extraction V1

## 目标

抽取 MySQL兼容M模式字符集/排序规则/事务：`4.4.2.4 字符集` + `4.4.2.5 排序规则` + `4.4.2.6 事务`（表4-158/4-159/4-160/4-161，页 3397–3404）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3（完整节合并） |
| 物理页 | 7 |
| 结构化 facts | 18 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 字符集（4.4.2.4）：utf8mb4/utf8/gbk/gb18030/binary/latin1支持；utf8=utf8mb4同字符集差异；多字节字符字节流解析/转义符差异；非法字符严格/宽松模式校验差异（strict_trans_tables）；binary字符集转码差异（client_encoding/server_encoding/character_set_connection一致性建议）
- 排序规则（4.4.2.5）：binary/gb18030/gbk/latin1/utf8/utf8mb4系列排序规则支持；仅字符串/部分二进制类型支持排序规则（typcollation判断）；对应字符集与库级字符集一致限制；utf8mb4默认字符序utf8mb4_general_ci；latin1需m_format_dev_version='s2'；PBE传参排序规则差异；binary vs 非binary比较差异
- 事务（4.4.2.6）：默认隔离级别差异（READ COMMITTED vs REPEATABLE-READ）；子事务SAVEPOINT vs MySQL不支持；嵌套事务差异；隐式提交差异（DDL/DCL不自动提交 vs MySQL自动提交）；SET TRANSACTION多次设置/分隔符/会话级vs下一事务差异；SET GLOBAL TRANSACTION差异；START TRANSACTION隔离级别/多次设置差异；事务GUC参数差异（transaction_isolation/tx_isolation/default_transaction_isolation/transaction_read_only/tx_read_only/default_transaction_read_only）；m_format_dev_version='s2'事务特性设置差异

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_191_oq_runtime` | 多字节字符解析/非法字符校验/字符集转换/binary排序规则比较等差异的完整影响范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_191_v1.yaml
generated/core_sql_reference_wave8_191_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_191.py
python scripts/build_core_sql_reference_wave8_191.py --check
python -m unittest tests.test_core_sql_reference_wave8_191 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
