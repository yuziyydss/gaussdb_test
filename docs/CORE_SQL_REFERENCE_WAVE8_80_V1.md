# SQL Reference Wave 8-80 Extraction V1

## 目标

抽取 D 族第四批：`DROP MASKING POLICY`、`DROP MATERIALIZED VIEW`、`DROP MODEL` 与 `DROP OPERATOR`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.23` | 2 | DROP MASKING POLICY |
| `1.13.10.24` | 2 | DROP MATERIALIZED VIEW |
| `1.13.10.25` | 2 | DROP MODEL |
| `1.13.10.26` | 2 | DROP OPERATOR |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- DROP MASKING POLICY语法与POLADMIN/SYSADMIN/初始用户权限
- 资源标签+脱敏策略创建、单个/一组删除行为基线
- DROP MATERIALIZED VIEW四类权限（含DROP ANY TABLE）、IF EXISTS、CASCADE/RESTRICT
- ASTORE物化视图删除行为基线
- DROP MODEL gs_model_warehouse查看、命名规范
- 训练+删除模型行为基线
- DROP OPERATOR语法、NONE操作数写法
- 示例参见CREATE OPERATOR

## Open questions

| ID | 内容 |
|---|---|
| `drop_d4_wave8_80_oq_runtime` | 脱敏策略删除、物化视图删除依赖处理、模型对象删除和操作符删除在真实权限、资源标签与依赖对象组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_80_v1.yaml
generated/core_sql_reference_wave8_80_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_80.py
python scripts/build_core_sql_reference_wave8_80.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_80.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DROP语句。
