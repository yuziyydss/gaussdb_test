# SQL Reference Wave 8-118 Extraction V1

## 目标

抽取 M 兼容事务与 SET 系列：`RELEASE SAVEPOINT`、`ROLLBACK`、`ROLLBACK TO SAVEPOINT`、`SAVEPOINT`、`SET`、`SET ROLE`、`SET SESSION AUTHORIZATION`、`SET TRANSACTION`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 8 |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 8 / 8 |
| chapter has facts | 8 / 8 |

## 覆盖能力

- RELEASE SAVEPOINT级联释放与资源回收语义、回滚状态禁释放、同名保存点仅最近被释放
- SAVEPOINT同名保留差异（M保留旧保存点、释放新后旧可再访问）、节点故障/COPY表结构不一致整事务回滚限制
- ROLLBACK/ROLLBACK TO SAVEPOINT语法与NOTICE行为
- SET（M重点）：五种形式含@var_name用户变量（MySQL风格）、@@SESSION/@@LOCAL前缀与运算空格规则、@@global禁用、NAMES COLLATE组合、SESSION/LOCAL事务语义特例
- 变量存储类型映射（int8/float8/longblob/longtext）、连续赋值等号首位规则、敏感函数警告
- SET ROLE/SET SESSION AUTHORIZATION INHERITS权限语义、SET TRANSACTION GLOBAL重连接生效与s2下一事务特性
- 示例基线全套（m_db）

## Open questions

| ID | 内容 |
|---|---|
| `m_tcl_set_wave8_118_oq_runtime` | M兼容自定义用户变量在存储过程和预编译语句中的行为边界、@@运算解析空格规则、SET TRANSACTION GLOBAL重连接生效时序需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_118_v1.yaml
generated/core_sql_reference_wave8_118_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_118.py
python scripts/build_core_sql_reference_wave8_118.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_118.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容事务/SET语句。
