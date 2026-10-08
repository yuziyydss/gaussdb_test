# SQL Reference Wave 8-115 Extraction V1

## 目标

抽取 M 兼容 DROP 族第一批：`DESCRIBE`、`DO`、`DROP AUDIT POLICY`、`DROP DATABASE`、`DROP EXTENSION`、`DROP FUNCTION`、`DROP GROUP`、`DROP INDEX`、`DROP OWNED`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 9 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 9 / 9 |
| chapter has facts | 9 / 9 |

## 覆盖能力

- DESCRIBE六列输出（Field/Type/Null/Key PRI-UNI-MUL/Default/Extra四种）与%_通配符、t01全特性14列基线
- DO（M）仅内部工具、仅plpgsql、动态GRANT示例
- DROP AUDIT POLICY/DATABASE/EXTENSION/FUNCTION/GROUP五节权限与IF EXISTS语义
- DROP DATABASE无法撤销、pg_temp禁删
- DROP EXTENSION CASCADE/RESTRICT、组件级联删除
- DROP FUNCTION省略参数列表/重载需签名、临时表函数禁删
- DROP INDEX CONCURRENTLY全机制（四级锁/事务禁用/临时表阻塞式/锁超时死锁/残留清理/耗时模型）
- DROP OWNED多数据库执行要求与CASCADE递归风险

## Open questions

| ID | 内容 |
|---|---|
| `m_drop_wave8_115_oq_runtime` | DROP INDEX CONCURRENTLY锁超时与死锁的触发概率、残留非法索引的清理行为、DESCRIBE通配符匹配大小写规则需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_115_v1.yaml
generated/core_sql_reference_wave8_115_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_115.py
python scripts/build_core_sql_reference_wave8_115.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_115.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容DROP语句。
