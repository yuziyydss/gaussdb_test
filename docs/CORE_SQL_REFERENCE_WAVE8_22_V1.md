# SQL Reference Wave 8-22 Extraction V1

## 目标

抽取 `1.13.9.27 CREATE INDEX`，补齐索引创建语法、LOCAL/GLOBAL索引、在线创建、索引方法、表达式/前缀键、INCLUDE、分区索引、存储参数和部分索引能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.27` | 20 | CREATE INDEX |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 20 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 索引适用场景、权限、IMMUTABLE函数与执行计划影响
- LOCAL/GLOBAL索引判定与分区索引语法
- CONCURRENTLY在线创建、Astore/Ustore构建、失败残留和性能边界
- UNIQUE索引支持的索引方法
- XML/rowid/rowno限制与B-Tree/UB-Tree长度上限
- btree、ubtree、ugin、gin、gist方法及存储引擎映射
- UGIN单列和扫描计划限制
- GIN/GiST支持类型、操作符与扫描计划
- 多字段上限、前缀键和表达式索引
- INCLUDE非键列、分区/分类索引、WITH存储参数、ILM压缩
- WHERE部分索引、COMMENT与VISIBLE/INVISIBLE

## Open questions

| ID | 内容 |
|---|---|
| `idx_wave8_22_oq_runtime` | CREATE INDEX在真实存储引擎、分区、并发DML、TDE、ILM压缩和执行计划组合下的创建结果、残留索引与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_22_v1.yaml
generated/core_sql_reference_wave8_22_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_22.py
python scripts/build_core_sql_reference_wave8_22.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_22.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE INDEX或DDL。
