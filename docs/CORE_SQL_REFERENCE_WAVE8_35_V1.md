# SQL Reference Wave 8-35 Extraction V1

## 目标

抽取 `1.13.7.46 ALTER VIEW`，补齐视图辅助属性修改、视图选项和手动重编译能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.46` | 6 | ALTER VIEW |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- ALTER VIEW辅助属性语义与CREATE OR REPLACE边界
- 视图ALTER权限、模式/属主修改权限约束
- SET/DROP DEFAULT、OWNER TO、RENAME、SET SCHEMA
- SET/RESET视图选项
- `security_barrier`和`check_option`
- COMPILE手动重编译
- IF EXISTS、视图/列/新名称参数
- 视图选项展示、失效视图重编译示例
- CREATE VIEW / ALTER VIEW / DROP VIEW生命周期

## Open questions

| ID | 内容 |
|---|---|
| `alvw_wave8_35_oq_runtime` | ALTER VIEW在真实依赖失效、权限切换、选项重置和手动重编译组合下的状态与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_35_v1.yaml
generated/core_sql_reference_wave8_35_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_35.py
python scripts/build_core_sql_reference_wave8_35.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_35.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER VIEW或DDL。
