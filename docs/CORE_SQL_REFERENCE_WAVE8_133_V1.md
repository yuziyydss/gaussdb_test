# SQL Reference Wave 8-133 Extraction V1

## 目标

抽取 M 兼容 `INSERT`（2.4.2.12.1，8 页单节成批）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- INSERT六种语法形式（VALUES/SET/query/视图三形式）与PARTITION子句
- ON DUPLICATE KEY UPDATE完整规则（VALUES(column_name)复合表达式、多唯一约束冲突顺序、s2多列引用与同字段多次修改、子查询列引用五限制）
- IGNORE六场景错误降级与五组示例基线（NOT NULL调0/唯一键/分区不匹配×2/子查询多行）
- 权限（INSERT/insert any table/ON DUPLICATE额外UPDATE与SELECT权限）
- 生成列禁写、列省略默认值填充规则、VALUES(column_name)复合表达式
- AS row_alias别名、视图插入三形式示例基线

## Open questions

| ID | 内容 |
|---|---|
| `m_insert_wave8_133_oq_runtime` | M兼容IGNORE将无效值调整为最接近值的完整映射表（NOT NULL/唯一键/分区不匹配场景）、ON DUPLICATE KEY UPDATE多唯一约束的冲突检查顺序、s2下同字段多次修改的最终值语义需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_133_v1.yaml
generated/core_sql_reference_wave8_133_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_133.py
python scripts/build_core_sql_reference_wave8_133.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_133.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容INSERT语句。
