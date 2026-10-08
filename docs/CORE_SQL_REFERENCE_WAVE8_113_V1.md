# SQL Reference Wave 8-113 Extraction V1

## 目标

抽取 M 兼容 `CREATE TABLE SUBPARTITION` 与 `CREATE TABLE SELECT`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 24 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- 二级分区表四级结构（顶层/一级逻辑表+二级叶子存数据）、四种组合方案（Range-Hash/Range-Key/List-Hash/List-Key）
- 双分区键各1列、LOCAL/GLOBAL规则、自动创建同范围二级分区、1048575上限
- SUBPARTITIONS自动生成命名（一级分区名+sp+数字）、PARTITIONS自动生成分区名（p+数字）
- partition/subpartition关键字写错静默变表别名陷阱、密态/账本数据库不支持
- CREATE TABLE SELECT列融合规则（自定义列置前/大小写识别/SELECT COMMENT优先/直接表列属性保留）
- FOR UPDATE选项、分区表/REPLACE/IGNORE不支持、精度开关前提
- SHOW CREATE TABLE查看建表语句基线（test2/test3/test4三例）
- 外键MATCH规则与foreign_key_checks、生成列/存储参数/字符序一致性条款

## Open questions

| ID | 内容 |
|---|---|
| `m_cts_sub_wave8_113_oq_runtime` | 二级分区表SUBPARTITIONS自动生成命名在分区维护后的稳定性、指定分区DML与并发事务的隔离行为、CREATE TABLE SELECT跨字符集数据转换的正确性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_113_v1.yaml
generated/core_sql_reference_wave8_113_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_113.py
python scripts/build_core_sql_reference_wave8_113.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_113.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容建表语句。
