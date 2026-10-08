# SQL Reference Wave 8-139 Extraction V1

## 目标

抽取 存储过程复合类型大节：`3.4 数组、集合和record`（36 页最大节单批覆盖）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 36 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 数组：VARRAY定义语法、自动增长/越界NULL（varray_compat转报错）、pg_type size记录、data_type限制、构造器A兼容限制、tableof_elem_constraints/varray_compat/enable_recordtype_check_strict、CLOB>1GB限制、DML中括号访问建议
- 数组函数：varray_compat前后差异总则（未初始化/Subscript outside of limit/beyond count）、extend族、count/trim/delete、first/last/prior/next/exists 全语义与示例基线
- 集合：TABLE OF定义语法、无索引集合存储/下标[1,upper]/no data found、A兼容/作用域/赋值互斥/比较限制/IS NULL/multiset支持/不入表列/构造器下标限制、匿名块ROLLBACK失效
- 带索引集合：HASH键值存储、INTEGER/VARCHAR下标、3种初始化、成员/整体赋值、bulk collect INTEGER限制、package级函数传参、构造器常量下标
- 集合函数：=/<>/^=/IS [NOT] NULL/[NOT] IN、MULTISET UNION/EXCEPT/INTERSECT [ALL|DISTINCT]、exists/extend/delete/trim/count/first/last/prior/next/limit、unnest_table/unnest（含indexbytable与record NULL元素语义）
- record：IS_RECORD定义、赋值四途径、构造器=>连续赋值约束（A兼容/package/位置参数报错）、INSERT/UPDATE/构造器默认值/复合成员默认值/静态DDL限制、enable_recordtype_check_strict、proc_outparam_override三规则、示例基线
- 示例基线（array_proc/nested_table_proc/regress_record/package=>赋值）

## Open questions

| ID | 内容 |
|---|---|
| `sp_coll_wave8_139_oq_runtime` | 数组varray_compat与tableof_elem_constraints组合开启时越界与元素约束校验的叠加边界、带索引集合VARCHAR下标长度校验与bulk collect into的INTEGER下标限制交互、record构造器=>连续赋值在多层嵌套复合类型场景需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_139_v1.yaml
generated/core_sql_reference_wave8_139_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_139.py
python scripts/build_core_sql_reference_wave8_139.py --check
python -m unittest tests.test_core_sql_reference_wave8_139 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行数组/集合/record相关存储过程。
