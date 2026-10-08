# SQL Reference Wave 8-60 Extraction V1

## 目标

抽取 `1.13.14.8 INSERT ALL`，完成多表插入的语法、ALL/FIRST分支语义、VALUES与子查询约束和异常矩阵闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.14.8` | 8 | INSERT ALL |

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

- INSERT ALL/FIRST多表插入语法与subquery结构
- INSERT权限、INSERT ANY TABLE、QUERY子句SELECT权限边界
- 生成列不可直接写入（仅DEFAULT）、仅A兼容模式
- plan_hint仅适配语法未实现
- ALL与FIRST分支语义；无WHEN时只能ALL、有WHEN默认ALL
- WHEN条件可引用子查询列
- 无AS语法表别名的三条限制
- 分区插入与VALUE/分区不一致异常
- column_name对位规则：子字段/数组下标、默认值填充、前N字段关联
- VALUES不可多行；单引号转义、类型自动转换、不支持聚集函数/子查询
- DEFAULT缺省值语义；subquery不可省略与SELECT * FROM DUAL
- 子查询表别名不可在CONDITION/INTO子句引用
- 不带条件、INSERT FIRST、INSERT ALL条件插入三个behavior oracle
- PL/SQL中使用INSERT ALL与变量引用
- 异常矩阵：聚集函数、VALUES多行、条件列缺失、子查询别名、视图、缺子查询

## Open questions

| ID | 内容 |
|---|---|
| `insert_all_wave8_60_oq_runtime` | INSERT ALL/FIRST在真实A兼容模式、多表与分区目标、权限组合和错误路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_60_v1.yaml
generated/core_sql_reference_wave8_60_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_60.py
python scripts/build_core_sql_reference_wave8_60.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_60.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行INSERT语句。
