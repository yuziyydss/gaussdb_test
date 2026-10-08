# SQL Reference Wave 8-103 Extraction V1

## 目标

抽取 M 兼容 ALTER 族第一批：`ALTER AUDIT POLICY`、`ALTER DATABASE`、`ALTER DEFAULT PRIVILEGES`、`ALTER EXTENSION` 与 `ALTER GROUP`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `2.4.2.6.1` | 3 | ALTER AUDIT POLICY |
| `2.4.2.6.2` | 3 | ALTER DATABASE |
| `2.4.2.6.3` | 2 | ALTER DEFAULT PRIVILEGES |
| `2.4.2.6.4` | 3 | ALTER EXTENSION |
| `2.4.2.6.5` | 3 | ALTER GROUP |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- M兼容审计策略五种修改形式、DDL/DML操作类型全集、IP/ROLES/APP过滤
- M兼容DATABASE=SCHEMA同义词、CHARSET/COLLATE四写法、系统模式改名限制（allow_system_table_mods）
- 运维管理员所有者修改限制
- M兼容默认权限仅表/序列四子句、DROP OWNED BY清理须知
- M兼容ALTER EXTENSION不支持用户使用、七类成员对象、OUT参数不参与一致性
- ALTER GROUP与GRANT/REVOKE等价、pg_group/pg_roles查询基线（区别于A模式gs_roles）

## Open questions

| ID | 内容 |
|---|---|
| `m_alter_wave8_103_oq_runtime` | M兼容审计策略过滤与脱敏策略联动、ALTER DATABASE字符集切换后存量表对象行为、系统模式名称修改在allow_system_table_mods下的风险边界需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_103_v1.yaml
generated/core_sql_reference_wave8_103_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_103.py
python scripts/build_core_sql_reference_wave8_103.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_103.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容ALTER语句。
