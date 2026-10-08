# SQL Reference Wave 8-85 Extraction V1

## 目标

抽取 C 族第三批：`COMMIT | END` 提交事务、`COMMIT PREPARED` 两阶段提交与 `CREATE AGGREGATE` 聚集函数创建。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.7` | 2 | COMMIT \| END |
| `1.13.9.8` | 2 | COMMIT PREPARED |
| `1.13.9.10` | 4 | CREATE AGGREGATE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- COMMIT/END提交语义与可见性、WORK|TRANSACTION仅语法兼容、跨会话创建者/管理员权限
- 提交事务行为基线
- COMMIT PREPARED两阶段提交、transaction_id唯一性、commit_sequence_number（64位递增无符号数）、权限与数据库自动维护提示
- 预备事务不可见与提交后可访问行为基线
- CREATE AGGREGATE新/旧双语法、name/input_data_type（*零参数）、BASETYPE=ANY规则
- sfunc状态转换函数（N+1参数、STRICT属性自行定义）、stype/ffunc输出类型、initcond
- SORTOP、CFUNC/INITCOLLECT/SHIPPABLE当前不生效、IFUNC优先级
- sum_add聚集函数行为基线

## Open questions

| ID | 内容 |
|---|---|
| `commit_wave8_85_oq_runtime` | COMMIT跨会话提交、COMMIT PREPARED两阶段提交与CREATE AGGREGATE各参数（SHIPPABLE/CFUNC不生效）在真实并发与故障恢复路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_85_v1.yaml
generated/core_sql_reference_wave8_85_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_85.py
python scripts/build_core_sql_reference_wave8_85.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_85.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行事务/聚集函数语句。
