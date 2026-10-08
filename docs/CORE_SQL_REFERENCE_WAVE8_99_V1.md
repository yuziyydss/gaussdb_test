# SQL Reference Wave 8-99 Extraction V1

## 目标

抽取 A/B 族收官批：`ALTER TYPE`、`ANALYZE | ANALYSE`、`AUTOHINT`、`AUTOHINT DROP MODEL` 与 `AUTOHINT PURGE`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.43` | 6 | ALTER TYPE |
| `1.13.7.47` | 7 | ANALYZE \| ANALYSE |
| `1.13.7.48` | 3 | AUTOHINT |
| `1.13.7.49` | 2 | AUTOHINT DROP MODEL |
| `1.13.7.50` | 1 | AUTOHINT PURGE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- ALTER TYPE九种action（属性增删改组合列表、OWNER/RENAME/SCHEMA、枚举ADD VALUE/RENAME VALUE）
- ALTER ANY TYPE权限、所有者变更需模式CREATE权限、USAGE权限要求
- CASCADE/RESTRICT级联语义、枚举值63字节、COLLATE排序规则
- typ_stu增删属性/owner查询/属性改名行为基线
- ANALYZE统计信息存储（PG_STATISTIC/PG_STATISTIC_EXT/PG_STATS/PG_EXT_STATS）
- 历史表三表与stats_history_record_limit/stats_history_retention_time控制
- 空表不记录统计信息、CURSOR类型列不收集、跳过无权限表
- VERIFY校验矩阵（7类页面物理/3类逻辑/UHEAP HEAP元组）
- 回滚限制（PG_CLASS/PG_PARTITION字段及相关函数视图）
- 四种语法形式与PARTITION/SUBPARTITION一级二级区分
- 多列统计32/4列限制与auto_statistic_ext_columns自动索引前缀
- VERIFY FAST/COMPLETE、CASCADE、toast内部表、备机执行、checkpoint建议
- PARTITION_MODE七选项（ALL/GLOBAL/PARTITION/GLOBAL AND PARTITION/SUBPARTITION/ALL COMPLETE/AUTO）
- AUTOHINT五选项缺省TRUE、无视已有Hint、WORKERS/MEMSIZE/IOLIMITS资源限制
- DROP MODEL/PURGE的N MODEL REMOVED输出基线

## Open questions

| ID | 内容 |
|---|---|
| `alter_type_analyze_autohint_wave8_99_oq_runtime` | 复合类型属性级联更新对继承子表的实际影响、VERIFY在并发DML下误报边界、PARTITION_MODE各模式采样率与统计质量差异、AUTOHINT在大查询上的探索耗时与推荐质量在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_99_v1.yaml
generated/core_sql_reference_wave8_99_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_99.py
python scripts/build_core_sql_reference_wave8_99.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_99.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行类型/统计收集/Hint推荐语句。
