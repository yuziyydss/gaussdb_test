# SQL Reference Wave 8-163 Extraction V1

## 目标

抽取 高级包第十六批切片：`3.12.2.20 DBE_STATS` 第一切片——接口总账与 LOCK/UNLOCK 族（页 2907–2917；DBE_STATS 共64页28函数，拆4批覆盖）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2907–2917） |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 28接口总账（LOCK/UNLOCK/RESTORE/PURGE/历史查询/统计表/EXPORT/IMPORT/SET/DELETE/SQLID族）与不支持临时表
- 权限模型（ANALYZE同权限、SCHEMA级跳过无权限表+USAGE、PURGE仅初始用户、统计表建删权限）
- EXPORT/IMPORT与\COPY TO/FROM四步流程
- LOCK四接口全原型（表/分区/列/schema、级联锁定、stat_state查看、staextname多列别名、DEBUG2日志）
- UNLOCK四接口全原型（partname空的级联解锁语义）
- ownname空值bind_procedure_searchpath规则、stastate l/u语义
- 三组示例基线（exist_lock=t+ANALYZE报错、PG_STATISTIC l/u）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_163_oq_runtime` | 锁定表后分区/列级联锁定的reloptions回显差异、列级锁定DEBUG2日志的logging_module配置、SCHEMA级锁定对并发ANALYZE任务的阻断范围需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_163_v1.yaml
generated/core_sql_reference_wave8_163_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_163.py
python scripts/build_core_sql_reference_wave8_163.py --check
python -m unittest tests.test_core_sql_reference_wave8_163 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不修改统计信息。
