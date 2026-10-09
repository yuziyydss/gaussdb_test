# SQL Reference Wave 8-182 Extraction V1

## 目标

抽取 Oracle兼容性说明第三切片：`4.3.8 常见SQL DDL子句` + `4.3.9 SQL查询和子查询` + `4.3.10 PL/SQL语言`（页 3178–3195）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 3178–3195） |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DDL子句兼容：ALLOCATE EXTENT/DEALLOCATE UNUSED/文件规范不支持，约束支持，LOGGING/FILESYSTEM_LIKE_LOGGING不支持，并行/物理属性/存储子句差异
- PL/SQL操作符兼容（**不支持）、逻辑/比较/条件表达式支持
- 变量声明：%TYPE/%ROWTYPE多层嵌套限制
- 数据类型：CHARACTER/VARCHAR长度差异、STRING不支持、PLS_INTEGER不支持、SUBTYPE range约束差异
- 控制语句：条件/LOOP/FOR（REVERSE）/WHILE/GOTO/NULL全支持
- 集合和Record：Associative array/VARRAY/Nested table/record四类型语法差异（NOT NULL、varray_compat、size_limit）、集合操作符（顺序敏感）、MULTISET函数、集合类型函数（extend/trim/limit仅nesttable）
- record赋值差异（GaussDB允许不同record类型隐式转换赋值）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_182_oq_runtime` | LOGGING/NOLOGGING子句缺失对迁移性能的影响、ORDER SIBLINGS BY+ORDER BY同时使用的排序结果确定性、集合操作符成员顺序差异对业务逻辑的影响、VARRAY类型相互赋值的隐式转换规则需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_182_v1.yaml
generated/core_sql_reference_wave8_182_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_182.py
python scripts/build_core_sql_reference_wave8_182.py --check
python -m unittest tests.test_core_sql_reference_wave8_182 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库。
