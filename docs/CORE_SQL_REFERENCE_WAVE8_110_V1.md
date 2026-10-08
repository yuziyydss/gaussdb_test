# SQL Reference Wave 8-110 Extraction V1

## 目标

抽取 M 兼容 CREATE 族第二批：`CREATE RESOURCE LABEL`、`CREATE ROLE`、`CREATE SCHEMA` 与 `CREATE SEQUENCE`。

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

- CREATE RESOURCE LABEL五类资源、IF NOT EXISTS NOTICE/ERROR对比、反引号命名（区别A模式双引号）
- CREATE ROLE新角色无登录权限、63字节命名反引号规则、密码四类三类+密文密码说明、EXPIRED/DISABLE行为
- 管理员属性缺省矩阵与三权分立开/关创建权限差异、INHERIT/PGUSER等废弃项、CONNECTION LIMIT多主节点乘积
- 成员关系四变体（IN ROLE/IN GROUP/ROLE/ADMIN/USER过时拼法）
- CREATE SCHEMA命名限制（pg_/gs_role_前缀）、系统管理员建对象归Schema同名用户
- CREATE SEQUENCE等差数列特殊表定位、generate_series N+1次调用报错、name字符集限制、MIN/MAX/CACHE/CYCLE缺省与空洞风险、OWNED BY关联语义

## Open questions

| ID | 内容 |
|---|---|
| `m_create2_wave8_110_oq_runtime` | M兼容EXPIRED密码失效用户的查询阻断范围、CONNECTION LIMIT与多主节点乘积在连接池场景的实际效果、OWNED BY序列在删除表事务回滚后的关联关系需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_110_v1.yaml
generated/core_sql_reference_wave8_110_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_110.py
python scripts/build_core_sql_reference_wave8_110.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_110.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容CREATE语句。
