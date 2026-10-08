# SQL Reference Wave 8-166 Extraction V1

## 目标

抽取 高级包第十九批切片：`3.12.2.20 DBE_STATS` 第四切片——SET_COLUMN/INDEX/TABLE_STATS 族（页 2944–2952）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2944–2952） |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- SET_COLUMN_STATS全原型：仅支持NDV（distcnt）/nullfrac（nullcnt）/width（avgclen）三类；表达式统计（tabname传索引名）；多列删除后不可重设；reltuples=0时nullfrac置0
- SET_INDEX_STATS全原型（numrows/numblks/relallvisible三类，其余暂不支持）
- SET_TABLE_STATS全原型（同三类）
- force锁定强行设置语义、partname null全局级语义、density/no_invalidate等暂不支持清单
- 四组示例基线：单列（a→nullfrac 1/stawidth 42/distinct 6）、多列（extname别名）、表达式（PG_ATTRIBUTE查expr名、expr→13/22）、索引（1/3/6）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_166_oq_runtime` | SET族force=TRUE在锁定统计信息上设置值后的ANALYZE恢复行为、表达式统计信息colname（expr/expr1/expr2）与索引表达式的稳定对应关系、reltuples=0时nullfrac强制置0对优化器的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_166_v1.yaml
generated/core_sql_reference_wave8_166_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_166.py
python scripts/build_core_sql_reference_wave8_166.py --check
python -m unittest tests.test_core_sql_reference_wave8_166 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不设置统计信息。
