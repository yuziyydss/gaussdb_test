# SQL Reference Wave 8-160 Extraction V1

## 目标

抽取 高级包第十六批切片：`3.12.2.18 DBE_SESSION`（会话级context）与 `3.12.2.19 DBE_SQL` 第一切片——数据类型/游标管理/动态定义列族（页 2861–2874）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2861–2874） |
| 物理页 | 14 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DBE_SESSION：SET/CLEAR/SEARCH_CONTEXT（namespace 128/attribute与value 1024字节截断、'null'字符串前向兼容）、MODIFY_PACKAGE_STATE（flags=1释放会话缓存）；示例基线
- DBE_SQL：DESC_REC/DESC_TAB/DATE_TABLE（mapping_date_to_datea映射规则）/NUMBER_TABLE/VARCHAR2_TABLE/BLOB_TABLE六类型
- 约70接口总账；work_mem临时磁盘512MB上限说明
- 游标生命周期闭环（REGISTER→SET_SQL→RUN→NEXT_ROW→定义列→取值→UNREGISTER）、会话级游标不可跨会话
- SQL_SET_SQL（text≤1G、language_flag 1/2）/SQL_RUN/NEXT_ROW
- SET_RESULT_TYPE（ANYELEMENT、pos起始1）与CHAR/INT/LONG（1G）/RAW/BYTEA/TEXT/UNKNOWN七变体

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_160_oq_runtime` | 结果集临时磁盘存储512MB阈值在超限时的报错行为、SET_RESULT_TYPE_LONG长列1G限制与GET_RESULT_LONG配合的截断语义、context值1024字节截断对多字节字符的边界需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_160_v1.yaml
generated/core_sql_reference_wave8_160_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_160.py
python scripts/build_core_sql_reference_wave8_160.py --check
python -m unittest tests.test_core_sql_reference_wave8_160 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行动态SQL。
