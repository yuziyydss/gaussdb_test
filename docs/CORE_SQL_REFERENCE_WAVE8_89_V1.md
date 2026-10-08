# SQL Reference Wave 8-89 Extraction V1

## 目标

抽取 C 族第七批：`CREATE MASKING POLICY`、`CREATE MATERIALIZED VIEW`、`CREATE MODEL`、`CREATE OPERATOR` 与 `CREATE OPERATOR CLASS`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.30` | 4 | CREATE MASKING POLICY |
| `1.13.9.31` | 2 | CREATE MATERIALIZED VIEW |
| `1.13.9.32` | 5 | CREATE MODEL |
| `1.13.9.33` | 2 | CREATE OPERATOR |
| `1.13.9.34` | 2 | CREATE OPERATOR CLASS |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- CREATE MASKING POLICY语法（policy_name + masking_clause + policy_filter_clause + ENABLE/DISABLE）
- 八类预置脱敏方式及maskall非预置、schema.function自定义脱敏函数
- POLADMIN/SYSADMIN/初始用户权限与enable_security_policy=on前提
- FILTER ON三类型（APP/ROLES/IP）、空过滤对所有用户生效、默认ENABLE
- policy_name 63字节/大小写/字符集命名规则
- 八类脱敏函数输出行为基线（maskall/randommasking/creditcardmasking/basicemailmasking/fullemailmasking/shufflemasking/alldigitsmasking/regexpmasking）
- CREATE MATERIALIZED VIEW全量物化视图语法与持久化初始化查询
- 临时表/全局临时表限制、基表DDL限制、IUD限制、REFRESH同步、USTORE与段页式不支持
- mv_name/column_name/WITH存储参数/TABLESPACE/AS query参数基线
- CREATE MODEL语法（USING算法 + FEATURES + TARGET + FROM表或子查询 + WITH超参）
- 四类算法（logistic_regression/linear_regression/svm_classification/kmeans）
- statement_timeout=0训练时长建议
- 表1-377超参默认值与取值范围、MAX_MEMORY_LIMIT/GS_MAX_COLS边界
- CREATE OPERATOR语法（PROCEDURE/LEFTARG/RIGHTARG/COMMUTATOR/NEGATOR/RESTRICT/JOIN/HASHES/MERGES）
- 操作符所有者、!=映射<>、双目/左目/右目参数要求、USAGE/EXECUTE权限
- 操作符命名规范（允许字符、--与/*禁止、+/-结尾限制、=>弃用、同模式重名需不同类型）
- box类型===操作符定义与pg_temp跨Schema调用行为基线
- CREATE OPERATOR CLASS语法（DEFAULT/FOR TYPE/USING/FAMILY/AS OPERATOR|FUNCTION|STORAGE）
- 内部使用定位、同模式重名需不同索引方法、系统管理员权限、完整性不检查
- 默认操作符类唯一性、FAMILY自动建族、FOR SEARCH默认、STORAGE限制

## Open questions

| ID | 内容 |
|---|---|
| `create_masking_model_operator_wave8_89_oq_runtime` | 脱敏策略八类脱敏函数的真实输出、全量物化视图刷新行为、DB4AI四类算法训练收敛、自定义操作符与操作符类在真实索引场景下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_89_v1.yaml
generated/core_sql_reference_wave8_89_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_89.py
python scripts/build_core_sql_reference_wave8_89.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_89.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行脱敏策略/物化视图/模型训练/操作符类语句。
