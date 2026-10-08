# SQL Reference Wave 8-104 Extraction V1

## 目标

抽取 M 兼容 ALTER 族第二批：`ALTER INDEX`、`ALTER RESOURCE LABEL`、`ALTER ROLE`、`ALTER SCHEMA`、`ALTER SEQUENCE` 与 `ALTER SESSION`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `2.4.2.6.6` | 3 | ALTER INDEX |
| `2.4.2.6.7` | 3 | ALTER RESOURCE LABEL |
| `2.4.2.6.8` | 3 | ALTER ROLE |
| `2.4.2.6.9` | 2 | ALTER SCHEMA |
| `2.4.2.6.10` | 3 | ALTER SEQUENCE |
| `2.4.2.6.11` | 3 | ALTER SESSION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 12 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- ALTER INDEX五形式（RENAME/UNUSABLE/RENAME PARTITION/SET/RESET）、FILLFACTOR与REINDEX重建提示、大量不可见索引DML性能风险
- 资源标签五类资源ADD/REMOVE基线
- ALTER ROLE M兼容option全集（无REPLICATION/RESOURCE POOL/空间参数等，与A模式差异入账）、RESET ALL、PGUSER不可改、密码/EXPIRED规则
- ALTER SCHEMA权限需当前数据库CREATE权限、系统模式限制
- ALTER SEQUENCE仅支持owner/归属列/最大值/cache、MAXVALUE禁事务函数存储过程、清空cache、阻塞nextval、LARGE取值2^127、OWNED BY关联规则
- ALTER SESSION四种隔离级别（REPEATABLE READ/SERIALIZABLE为M兼容扩展）、NAMES COLLATE组合、示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_alter2_wave8_104_oq_runtime` | UNUSABLE索引对M兼容查询计划的实际影响、序列cache清空在多会话下的可见性时序、REPEATABLE READ与SERIALIZABLE在M兼容下的隔离行为差异需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_104_v1.yaml
generated/core_sql_reference_wave8_104_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_104.py
python scripts/build_core_sql_reference_wave8_104.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_104.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容ALTER语句。
