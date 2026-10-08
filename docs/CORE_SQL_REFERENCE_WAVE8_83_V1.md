# SQL Reference Wave 8-83 Extraction V1

## 目标

D 族收官（`DROP TYPE`、`DROP WEAK PASSWORD DICTIONARY`）并开篇 C 族（`CALL`、`CHECKPOINT`、`CLEAN CONNECTION`）。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.46` | 2 | DROP TYPE |
| `1.13.10.50` | 1 | DROP WEAK PASSWORD DICTIONARY |
| `1.13.9.1` | 2 | CALL |
| `1.13.9.2` | 1 | CHECKPOINT |
| `1.13.9.3` | 2 | CLEAN CONNECTION |

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

- DROP TYPE权限（DROP ANY TYPE）、IF EXISTS、CASCADE（字段/函数/操作符）/RESTRICT
- DROP WEAK PASSWORD DICTIONARY三角色权限、gs_global_config清空行为基线
- CALL权限（EXECUTE ANY FUNCTION）、schema/package限定、DATABASE LINK远端调用、系统函数重名Schema指定
- 命名标记法(:=/=>)与直接传值顺序要求、IN/OUT出参规则与重载package函数出参忽略
- CALL按值/命名/出参常量行为基线
- CHECKPOINT语义与gs_guc参数、管理员/运维管理员、立即检查、PDB排除
- CLEAN CONNECTION仅TO ALL、force模式、CHECK前置检查、FORCE SIGTERM、库/用户过滤
- 三种清理行为基线

## Open questions

| ID | 内容 |
|---|---|
| `call_wave8_83_oq_runtime` | CALL参数绑定（IN/OUT与重载）、CHECKPOINT、CLEAN CONNECTION清理以及DROP TYPE/弱口令字典清空在真实权限、并发会话和依赖对象组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_83_v1.yaml
generated/core_sql_reference_wave8_83_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_83.py
python scripts/build_core_sql_reference_wave8_83.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_83.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CALL/CHECKPOINT/CLEAN CONNECTION/DROP语句。
