# SQL Reference Wave 8-26 Extraction V1

## 目标

抽取 `1.13.14.7 INSERT`，补齐多行插入、CTE、分区插入、视图/子查询插入、冲突更新、IGNORE降级和批量索引优化能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.14.7` | 16 | INSERT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- INSERT主语法、VALUES/query/DEFAULT VALUES和RETURNING
- INSERT、UPDATE、SELECT相关权限边界
- 生成列写入限制与C兼容字符串截断
- WITH/RECURSIVE CTE、物化行为和DML RETURNING回显
- plan_hint、INSERT IGNORE降级与B模式边界
- 表、子查询、视图、别名和分区插入
- 目标列绑定、缺省值、表达式类型转换
- ON DUPLICATE KEY UPDATE冲突行为、触发器与限制
- ON CONFLICT target/action、PG兼容模式限制
- 批量VALUES与RCR UBTree批量索引优化

## Open questions

| ID | 内容 |
|---|---|
| `ins_wave8_26_oq_runtime` | INSERT在真实数据规模、分区路由、冲突更新、IGNORE降级、视图/子查询和批量索引优化组合下的结果、错误与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_26_v1.yaml
generated/core_sql_reference_wave8_26_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_26.py
python scripts/build_core_sql_reference_wave8_26.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_26.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行INSERT或DML。
