# SQL Reference Wave 8-57 Extraction V1

## 目标

合并抽取 `CREATE/ALTER/DROP FOREIGN DATA WRAPPER`，完成外部数据封装器的handler/validator、OPTIONS、GUC边界和依赖删除闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.21` | 2 | CREATE FOREIGN DATA WRAPPER |
| `1.13.7.12` | 3 | ALTER FOREIGN DATA WRAPPER |
| `1.13.10.15` | 2 | DROP FOREIGN DATA WRAPPER |

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

- CREATE权限、唯一名称与HANDLER/VALIDATOR语法
- handler签名、NO HANDLER外部表不可访问
- validator作用、签名和NO VALIDATOR行为
- OPTIONS唯一约束与验证
- 初始示例：dummy、file handler、debug option
- ALTER权限、`support_extended_features=on`
- 更换handler/validator和已有选项失效风险
- OPTIONS ADD/SET/DROP语义
- DROP的`IF EXISTS`、CASCADE/RESTRICT

## Open questions

| ID | 内容 |
|---|---|
| `fdw_wave8_57_oq_runtime` | CREATE/ALTER/DROP FOREIGN DATA WRAPPER在真实handler/validator、OPTIONS、依赖服务器和GUC开关组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_57_v1.yaml
generated/core_sql_reference_wave8_57_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_57.py
python scripts/build_core_sql_reference_wave8_57.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_57.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行外部数据封装器DDL。
