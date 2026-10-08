# SQL Reference Wave 8-165 Extraction V1

## 目标

抽取 高级包第十八批切片：`3.12.2.20 DBE_STATS` 第三切片——EXPORT/IMPORT 族（页 2928–2944）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2928–2944） |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- EXPORT五接口全原型：INDEX（partname null导出全局+分区、reltuples/relpages/relallvisible三类）/TABLE（cascade默认TRUE）/COLUMN（多列/表达式、索引时colname为表达式名）/SCHEMA/DATABASE（无权限表跳过不报错）
- IMPORT五接口全原型：与EXPORT一一对应、force忽略锁状态、cascade语义、no_invalidate/stat_category暂不支持
- statid可选标识符、statown/ownname空值bind_procedure_searchpath规则
- 四组示例基线：分区索引导出（idx_t2_local_a+6分区）、列导出（stavalues1 {100,150,250}+多列别名）、索引导入恢复（relpages 6/reltuples 6）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_165_oq_runtime` | IMPORT force=TRUE忽略锁定导入后的ANALYZE恢复行为、CASCADE导出导入在多列/表达式统计上的完整往返一致性、stat_category暂不支持时传入非NULL值的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_165_v1.yaml
generated/core_sql_reference_wave8_165_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_165.py
python scripts/build_core_sql_reference_wave8_165.py --check
python -m unittest tests.test_core_sql_reference_wave8_165 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不导出导入统计信息。
