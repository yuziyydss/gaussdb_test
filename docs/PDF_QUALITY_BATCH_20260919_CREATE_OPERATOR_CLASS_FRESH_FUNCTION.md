# PDF 质量抽取增量：CREATE OPERATOR CLASS FRESH FUNCTION（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_operator_class.txt`
- 章节：1.13.9.34 CREATE OPERATOR CLASS
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_operator_class_fresh_function
```

新增事务内非默认 `btree` 操作符类静态代表：

```sql
BEGIN;
CREATE SCHEMA g_create_opclass_ns;
CREATE FUNCTION g_create_opclass_ns.compare_integer(INTEGER, INTEGER)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';

CREATE OPERATOR CLASS g_create_opclass_ns.g_create_opclass
FOR TYPE INTEGER
USING btree
AS FUNCTION 1 g_create_opclass_ns.compare_integer(INTEGER, INTEGER);

ROLLBACK;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_operator_class manifest | 0 | 1 |
| create_operator_class candidate | 0 | 1 |
| FUNCTION 项 feature | needs_profile | covered / representative |
| 全库 manifest | 863 | 864 |
| 全库 candidate | 5,389 | 5,390 |
| 全库 distinct SQL | 5,302 | 5,303 |
| 有 manifest 的因子包 | 265 | 266 |
| 无 manifest 的因子包 | 52 | 51 |
| generation model complete | 257 / 265 | 257 / 266 |

## 保留边界

本轮只证明一个事务内非默认 `btree` 操作符类的 `FUNCTION 1`
语法候选存在，不证明：

- btree 索引比较契约
- 操作符类完整性
- 索引行为或执行计划
- `OPERATOR` 项
- `STORAGE` 项
- 显式 `FAMILY`
- `DEFAULT` 操作符类
- 目录身份查询结果
- 系统管理员权限运行时回执

## 验证

- `tests.test_create_operator_class_fresh_function`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
