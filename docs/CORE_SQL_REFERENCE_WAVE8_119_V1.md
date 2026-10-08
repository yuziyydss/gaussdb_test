# SQL Reference Wave 8-119 Extraction V1

## 目标

抽取 M 兼容 `START TRANSACTION`、`TABLE`、`TIMECAPSULE TABLE` 与 `TRUNCATE`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 12 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- START TRANSACTION两格式（WITH CONSISTENT SNAPSHOT仅格式一）、四种隔离级别、快照建立时机
- WITH CONSISTENT SNAPSHOT非RR级别告警基线
- TABLE语法简化SELECT、单列子查询限制、LIMIT分页三种形式（LIMIT 20,4 / LIMIT 96,ALL）、复合查询规则
- TIMECAPSULE闪回体系：TO CSN/TIMESTAMP（3秒偏差）/TO BEFORE DROP/TRUNCATE、Ustore/Astore引擎支持、九类禁闪对象、DROP检索规则与子对象名、TRUNCATE闪回统计信息为0、RENAME TO仅限DROP闪回
- TRUNCATE与DELETE/DROP三者差异、ONLY保留语法、PURGE绕回收站、分区清空与UPDATE GLOBAL INDEX
- 示例基线（临时表/分页/回收站/分区清空）

## Open questions

| ID | 内容 |
|---|---|
| `m_stt_wave8_119_oq_runtime` | TIMECAPSULE闪回3秒时间偏差在实际负载下的影响、回收站对象禁止DQL的替代查询方式、TRUNCATE PARTITION与GLOBAL索引失效组合需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_119_v1.yaml
generated/core_sql_reference_wave8_119_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_119.py
python scripts/build_core_sql_reference_wave8_119.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_119.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容闪回/清空语句。
