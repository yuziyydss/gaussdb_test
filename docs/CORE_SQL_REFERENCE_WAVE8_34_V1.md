# SQL Reference Wave 8-34 Extraction V1

## 目标

抽取 `1.13.9.60 CREATE VIEW`，补齐视图创建、临时视图、FORCE、CHECK OPTION、READ ONLY和可更新视图边界。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.60` | 7 | CREATE VIEW |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 视图虚拟表语义、封装、安全和权限价值
- CREATE ANY TABLE权限与系统视图替换限制
- OR REPLACE、TEMP、FORCE、视图名/列名和视图选项
- `security_barrier`、`check_option`
- 分区OID依赖与嵌套视图失效
- CHECK OPTION、CASCADED/LOCAL和READ ONLY
- 保留键表、可更新列、可更新视图和metadata查询
- INSTEAD OF触发器/规则、CASCADED覆盖、连接列限制
- 视图DML与嵌套CHECK OPTION示例行为

## Open questions

| ID | 内容 |
|---|---|
| `view_wave8_34_oq_runtime` | CREATE VIEW在真实依赖变更、分区OID失效、CHECK OPTION、INSTEAD触发器/规则和保留键表组合下的重编译与DML矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_34_v1.yaml
generated/core_sql_reference_wave8_34_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_34.py
python scripts/build_core_sql_reference_wave8_34.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_34.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE VIEW或DDL。
