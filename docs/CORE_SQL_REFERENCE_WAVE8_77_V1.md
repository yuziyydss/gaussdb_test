# SQL Reference Wave 8-77 Extraction V1

## 目标

抽取 `BEGIN` 匿名块/事务与 D 族第一批：`DROP AGGREGATE`、`DROP AUDIT POLICY`、`DROP CAST`、`DROP CLIENT MASTER KEY`、`DROP COLUMN ENCRYPTION KEY`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.8.1` | 2 | BEGIN |
| `1.13.10.5` | 3 | DROP AGGREGATE |
| `1.13.10.6` | 1 | DROP AUDIT POLICY |
| `1.13.10.7` | 1 | DROP CAST |
| `1.13.10.8` | 2 | DROP CLIENT MASTER KEY |
| `1.13.10.9` | 2 | DROP COLUMN ENCRYPTION KEY |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- BEGIN匿名块与事务双用途、匿名块语法与语句范围
- 事务语法、WORK/TRANSACTION、隔离级别与设置时机
- 事务/匿名块行为基线（REPEATABLE READ、dbe_output.print_line）
- DROP AGGREGATE所有者权限、IF EXISTS、零参数*、CASCADE/RESTRICT、SQL标准缺失
- DROP AUDIT POLICY POLADMIN/SYSADMIN/初始用户、唯一约束、不存在报错基线
- DROP CAST源/目标类型权限、CASCADE/RESTRICT等效
- DROP CLIENT MASTER KEY元数据删除边界（不删密钥实体）
- DROP COLUMN ENCRYPTION KEY加密列级联危险操作实际不可删

## Open questions

| ID | 内容 |
|---|---|
| `begin_wave8_77_oq_runtime` | BEGIN匿名块执行与事务特性、各DROP语句（聚集函数/审计策略/类型转换/密钥对象）在真实权限、依赖对象和密态特性组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_77_v1.yaml
generated/core_sql_reference_wave8_77_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_77.py
python scripts/build_core_sql_reference_wave8_77.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_77.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行BEGIN/DROP语句。
