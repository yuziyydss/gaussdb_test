# Core System Information Functions Wave 5-2 Extraction V1

## 目标

继续细抽 `1.6.26 系统信息函数`，本轮覆盖第二批：

```text
访问权限查询函数
对象权限、角色权限和ANY权限
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 571–578，共8页 |
| 结构化 facts | 22 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 22 / 22 |

## 覆盖内容

### 列与表权限

- `has_any_column_privilege`
- `has_column_privilege`
- `has_table_privilege`

关键边界：

- `has_any_column_privilege`权限类型必须为`SELECT`、`INSERT`、`UPDATE`、`COMMENT`或`REFERENCES`。
- `has_column_privilege`支持列名或属性号。
- `has_table_privilege`支持`SELECT`、`INSERT`、`UPDATE`、`DELETE`、`TRUNCATE`、`REFERENCES`、`TRIGGER`、`ALTER`、`DROP`、`COMMENT`、`INDEX`、`VACUUM`。
- 多权限用逗号分隔时，拥有任一权限即返回`true`。
- 拥有表级权限隐含拥有每列列级权限。

### 密钥、数据库与目录

- `has_cek_privilege`
- `has_cmk_privilege`
- `has_database_privilege`
- `has_directory_privilege`

关键边界：

- CEK和CMK权限均支持`USAGE`和`DROP`。
- 数据库权限支持`CREATE`、`CONNECT`、`TEMPORARY`、`ALTER`、`DROP`、`COMMENT`和`TEMP`。

### FDW、函数、语言与外部服务

- `has_foreign_data_wrapper_privilege`
- `has_function_privilege`
- `has_language_privilege`
- `has_server_privilege`

关键边界：

- FDW和语言权限类型为`USAGE`。
- 函数权限类型为`EXECUTE`、`ALTER`、`DROP`或`COMMENT`。
- 外部服务器权限类型为`USAGE`、`ALTER`、`DROP`或`COMMENT`。

### Schema、节点组与表空间

- `has_nodegroup_privilege`
- `has_schema_privilege`
- `has_tablespace_privilege`

关键边界：

- nodegroup权限类型为`USAGE`、`CREATE`、`COMPUTE`、`ALTER`或`DROP`。
- Schema权限类型为`CREATE`、`USAGE`、`ALTER`、`DROP`或`COMMENT`。
- 检查同名Schema的`CREATE`时，还需拥有Schema `OWNER`权限。
- 表空间权限类型为`CREATE`、`ALTER`、`DROP`或`COMMENT`。

### 角色与ANY权限

- `pg_has_role`
- `has_any_privilege`

关键边界：

- 角色权限类型为`MEMBER`或`USAGE`。
- `MEMBER`表示直接或间接成员关系；`USAGE`表示无需`SET ROLE`即可使用角色。
- `public`不能作为`pg_has_role`的用户名。
- `has_any_privilege`支持15类ANY权限，均可带`WITH ADMIN OPTION`。
- 多个ANY权限组合时，拥有任一权限即返回`true`。

## Open questions

| ID | 内容 |
|---|---|
| `sysinfo_wave5_2_oq_privilege_matrix` | 各`has_*`函数在对象所有者、显式授权、授权选项、同名Schema和组合权限下的返回矩阵 |
| `sysinfo_wave5_2_oq_any_privilege_evidence` | `has_any_privilege`在每类ANY权限、多权限组合、非法权限和不同用户角色下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_system_info_wave5_2_v1.yaml
generated/core_system_info_wave5_2_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_info_wave5_2.py
python scripts/build_core_system_info_wave5_2.py --check
python -m pytest -q tests/test_core_system_info_wave5_2.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不执行GRANT/REVOKE、不验证任何权限查询结果。
- 不宣称目标环境行为验证通过。
