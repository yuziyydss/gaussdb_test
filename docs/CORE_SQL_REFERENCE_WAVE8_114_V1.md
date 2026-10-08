# SQL Reference Wave 8-114 Extraction V1

## 目标

抽取 M 兼容 `CREATE USER`、`CREATE VIEW`（CREATE 族收官）与 `DEALLOCATE`、`DELETE`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- CREATE USER：默认LOGIN权限、自动创建同名SCHEMA、lower_case_table_names转小写、密码规则、ALTER USER全生命周期示例
- CREATE VIEW：虚拟表定位与三大作用、精度传递开关26类类型query禁算清单、可更新视图五要素、enable_view_invalidation失效规则、security_barrier、分区OID固化、CHECK OPTION CASCADED/LOCAL与连接列限制
- DEALLOCATE：{DEALLOCATE|DROP} PREPARE语法（无ALL，区别A模式）
- DELETE：单表/多表双语法、IGNORE错误降级、CTE RECURSIVE类型一致约束、视图删除九条约束、索引提示USE/IGNORE/FORCE、s2多表匹配三规则

## Open questions

| ID | 内容 |
|---|---|
| `m_cv_del_wave8_114_oq_runtime` | M兼容IGNORE错误降级覆盖的具体错误场景清单、CHECK OPTION在多表连接视图的行为矩阵、DELETE多表匹配规则在s2开关下的边界用例需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_114_v1.yaml
generated/core_sql_reference_wave8_114_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_114.py
python scripts/build_core_sql_reference_wave8_114.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_114.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容DELETE/视图语句。
