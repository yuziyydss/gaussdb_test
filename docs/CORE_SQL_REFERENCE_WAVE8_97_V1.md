# SQL Reference Wave 8-97 Extraction V1

## 目标

抽取 A/B 族第四批：`ALTER OPERATOR`、`ALTER PACKAGE`、`ALTER PLUGGABLE DATABASE` 与 `ALTER PROCEDURE`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.21` | 2 | ALTER OPERATOR |
| `1.13.7.22` | 3 | ALTER PACKAGE |
| `1.13.7.23` | 2 | ALTER PLUGGABLE DATABASE |
| `1.13.7.24` | 6 | ALTER PROCEDURE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- ALTER OPERATOR两种形式、NONE缺省操作数写法、所有权变更与DROP+CREATE重建权限等价性设计、SYSADMIN豁免
- @@@操作符OWNER/SET SCHEMA行为基线、SQL标准不兼容说明
- ALTER PACKAGE仅支持OWNER与COMPILE [PACKAGE|BODY|SPECIFICATION]
- 三权分立与DEFINER类型PACKAGE的所有者修改限制矩阵
- gs_package/gs_roles所有者查询与COMPILE重编译基线
- ALTER PLUGGABLE DATABASE OPEN/CLOSE/CLOSE IMMEDIATE状态机
- enable_mtd前提、PDB属主/sysadmin权限、模板PDB初始用户专属与表空间软链接丢失风险
- OPEN需资源计划指令、CLOSE最多等待5秒业务连接
- ALTER PROCEDURE五种形式与action子句全集（与ALTER FUNCTION同构）
- 临时表禁改、PUBLIC Schema限制、三权分立owner规则
- SHIPPABLE/FENCED预留接口、RESTRICT语法兼容、COST/ROWS默认值
- test_proc COMPILE两种签名、IMMUTABLE、OWNER、SET SCHEMA行为基线

## Open questions

| ID | 内容 |
|---|---|
| `alter_op_pkg_pdb_proc_wave8_97_oq_runtime` | 操作符所有权变更与重建权限等价性、DEFINER类型PACKAGE与三权分立组合的所有者修改限制、PDB在资源计划指令下的OPEN行为与CLOSE 5秒等待边界、存储过程重编译后依赖对象失效与恢复在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_97_v1.yaml
generated/core_sql_reference_wave8_97_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_97.py
python scripts/build_core_sql_reference_wave8_97.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_97.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行操作符/包/PDB/存储过程语句。
