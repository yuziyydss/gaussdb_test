# SQL Reference Wave 8-82 Extraction V1

## 目标

抽取 D 族第六批：`DROP ROLE`、`DROP ROW LEVEL SECURITY POLICY`、`DROP RULE`、`DROP SECURITY LABEL` 与 `DROP TABLE`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.33` | 1 | DROP ROLE |
| `1.13.10.34` | 1 | DROP ROW LEVEL SECURITY POLICY |
| `1.13.10.35` | 2 | DROP RULE |
| `1.13.10.37` | 1 | DROP SECURITY LABEL |
| `1.13.10.41` | 2 | DROP TABLE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- DROP ROLE语法与IF EXISTS行为基线（skipping NOTICE）
- DROP RLS POLICY所有者/管理员权限、CASCADE/RESTRICT等效、rls创建删除基线
- DROP RULE重写规则、INSTEAD规则基线、CASCADE/RESTRICT
- DROP SECURITY LABEL权限（gs_role_seclabel）、不存在报错基线
- DROP TABLE删除影响（索引删除、函数存储过程失效、分区级联）、四类权限、外键八级锁
- CASCADE（视图/触发器/索引，关联表不可级联）/RESTRICT/PURGE物理删除
- 依赖视图报错与CASCADE级联行为基线

## Open questions

| ID | 内容 |
|---|---|
| `drop_table_wave8_82_oq_runtime` | DROP ROLE/RLS POLICY/RULE/SECURITY LABEL/TABLE在真实权限、依赖对象（视图、外键触发器、回收站）和兼容模式组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_82_v1.yaml
generated/core_sql_reference_wave8_82_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_82.py
python scripts/build_core_sql_reference_wave8_82.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_82.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DROP语句。
