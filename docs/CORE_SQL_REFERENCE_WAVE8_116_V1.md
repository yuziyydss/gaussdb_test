# SQL Reference Wave 8-116 Extraction V1

## 目标

抽取 M 兼容 DROP 族收官（10 节）：`DROP PREPARE/RESOURCE LABEL/ROLE/SCHEMA/SEQUENCE/TABLE/USER/VIEW` 与 `EXECUTE`、`EXPLAIN`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 10 |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 10 / 10 |
| chapter has facts | 10 / 10 |

## 覆盖能力

- DROP PREPARE与DEALLOCATE同义、会话结束自动删除
- DROP RESOURCE LABEL支持多标签、DROP ROLE/DROP SCHEMA/IF EXISTS语义
- DROP SEQUENCE LARGE标识配套规则（AUTO_INCREMENT自动生成场景）
- DROP TABLE CASCADE/RESTRICT s1仅语法、PURGE物理删除绕回收站
- DROP USER同名schema级联、enable_kill_query on/off行为、不支持跨库级联
- DROP VIEW CASCADE s1仅语法
- EXECUTE预备语句执行（M兼容无参数列表写法）
- EXPLAIN选项全集（PLAN存plan_table、BLOCKNAME/OUTLINE/ADAPTCOST为M扩展）、分布式选项禁用、ANALYZE回滚法

## Open questions

| ID | 内容 |
|---|---|
| `m_drop_exec_wave8_116_oq_runtime` | M兼容DROP TABLE PURGE与回收站开关的实际交互、EXPLAIN PLAN选项写入plan_table的读取方式、ADAPTCOST反馈方式对计划的影响需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_116_v1.yaml
generated/core_sql_reference_wave8_116_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_116.py
python scripts/build_core_sql_reference_wave8_116.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_116.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容DROP/EXECUTE/EXPLAIN语句。
