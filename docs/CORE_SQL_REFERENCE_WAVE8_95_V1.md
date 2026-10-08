# SQL Reference Wave 8-95 Extraction V1

## 目标

抽取 A/B 族第二批：`ALTER DEFAULT PRIVILEGES`、`ALTER DIRECTORY`、`ALTER EVENT`、`ALTER EXTENSION` 与 `ALTER FUNCTION`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.8` | 4 | ALTER DEFAULT PRIVILEGES |
| `1.13.7.9` | 1 | ALTER DIRECTORY |
| `1.13.7.10` | 3 | ALTER EVENT |
| `1.13.7.11` | 4 | ALTER EXTENSION |
| `1.13.7.14` | 5 | ALTER FUNCTION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 15 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- ALTER DEFAULT PRIVILEGES六类对象grant/revoke子句全集（表11权限/序列6/函数4/类型4/密钥2）
- FOR ROLE/USER默认当前用户、target_role需schema CREATE权限、DROP OWNED BY脱离缺省权限
- tpcds PUBLIC/jack/jake授权回收行为基线
- ALTER DIRECTORY仅改所有者、enable_access_server_directory双态权限、PDB不支持
- ALTER EVENT仅B兼容、所有者切换规则、DEFINER sysadmin限定、ON COMPLETION PRESERVE、DISABLE ON SLAVE
- interval下划线写法需b_format_version='5.7'+s1
- event_e1/e2 ENABLE、DO改语句、RENAME行为基线
- ALTER EXTENSION内部功能定位与support_extended_features开关
- UPDATE/SET SCHEMA/ADD DROP三形式、relocatable约束、22类成员对象、权限要求
- OUT参数与参数名不参与一致性、零参数*写法、plpgsql三种操作示例
- ALTER FUNCTION五种形式与action子句全集
- 临时表禁改、PUBLIC Schema仅系统管理员/初始用户、三权分立所有者规则
- STRICT/IMMUTABLE/STABLE/VOLATILE/LEAKPROOF语义、AUTHID与SECURITY等价关系
- SET/FROM CURRENT会话参数、模式CREATE权限要求、test_func_tk重编译基线

## Open questions

| ID | 内容 |
|---|---|
| `alter_adp_event_ext_func_wave8_95_oq_runtime` | 默认权限六类对象GRANT/REVOKE的实际生效范围、定时任务DEFINER权限切换与DISABLE ON SLAVE行为、扩展版本更新脚本链、函数重编译与SECURITY DEFINER权限组合在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_95_v1.yaml
generated/core_sql_reference_wave8_95_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_95.py
python scripts/build_core_sql_reference_wave8_95.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_95.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行默认权限/目录/定时任务/扩展/函数语句。
