# Core System Information Functions Wave 5-3 Extraction V1

## 目标

继续细抽 `1.6.26 系统信息函数`，本轮覆盖第三批：

```text
模式可见性查询
系统表信息与对象描述
约束 / 表达式 / 函数 / 索引 / 视图 / 表定义
关键字、用户检查、表空间
类型、排序、扩展路径、序列
列注释、对象注释、共享对象注释
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 579–586，共8页 |
| 结构化 facts | 32 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 32 / 32 |

## 覆盖内容

### 模式可见性

覆盖12个 `pg_*_is_visible` 函数，对象类型包括：

- 排序
- 转换
- 函数
- 操作符类 / 操作符 / 操作符族
- 表
- 文本检索配置、词典、解析器、模板
- 类型或域

关键边界：

- 对象在前面的搜索路径中没有同名同参数类型对象时可见。
- 操作符类还需考虑相关索引访问方法。
- 可通过 `regclass`、`regtype`、`regprocedure` 等OID别名类型测试名称。
- `pg_table_is_visible(oid)=true`等价于表可不带模式修饰引用。

### 对象描述与定义

- `pg_describe_object`
- `pg_get_constraintdef`
- `pg_get_expr`
- `pg_get_functiondef`
- `pg_get_function_arguments`
- `pg_get_function_identity_arguments`
- `pg_get_function_result`
- `pg_get_indexdef`
- `pg_get_viewdef`
- `pg_get_tabledef`

关键边界：

- `pg_get_indexdef`有三个重载；`dump_schema_only`仅用于dump场景。
- `pg_get_viewdef`的`pretty_bool=true`适合打印；转储时应尽量避免。
- `pg_get_tabledef`包含表定义、索引、comments和ILM策略。
- 表定义不包含依赖的group、schema、tablespace、server创建语句。
- 继承自父对象的ILM策略不会在子对象表定义中返回。

### 用户、关键字与表空间

- `pg_get_userbyid`
- `pg_check_authid`
- `pg_get_keywords`
- `pg_options_to_table`
- `pg_tablespace_databases`
- `pg_tablespace_location`

关键边界：

- `pg_get_keywords`的`catcode`包括`U/C/T/R`。
- 兼容模式会影响关键字范围和类型。
- 返回记录不包含`disable_keyword_options`配置的选项。
- 表空间查询有数据库OID时非空且不能删除。
- 表空间路径在PDB / Non-PDB下分别返回对应路径。

### 类型、排序与序列

- `format_type`
- `getdistributekey`
- `pg_typeof`
- `collation for`
- `pg_extension_update_paths`
- `pg_get_serial_sequence`
- `pg_sequence_parameters`

关键边界：

- `format_type`的长度值是实际存储长度减4字节。
- 单机环境不支持分布列，`getdistributekey`返回空。
- `collation for`无排序返回NULL，参数不可排序时报错。
- `pg_extension_update_paths`仅系统管理员可调用。

### 注释

- `col_description`
- `obj_description`
- `shobj_description`

关键边界：

- `col_description`通过表OID和字段号获取注释。
- `obj_description`不能用于表字段。
- `shobj_description`用于共享数据库对象。

## Open questions

| ID | 内容 |
|---|---|
| `sysinfo_wave5_3_oq_visibility_matrix` | 12个可见性函数在不同搜索路径、同名对象、系统模式和OID别名输入下的行为矩阵 |
| `sysinfo_wave5_3_oq_definition_boundary_evidence` | 定义、序列和注释函数在不同对象类型、分区、ILM、PDB/Non-PDB和兼容模式下的输出矩阵 |

## 产物

```text
docs/compat_facts/core_system_info_wave5_3_v1.yaml
generated/core_system_info_wave5_3_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_info_wave5_3.py
python scripts/build_core_system_info_wave5_3.py --check
python -m pytest -q tests/test_core_system_info_wave5_3.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不执行对象定义反查、不修改注释、不检查表空间删除。
- 不宣称目标环境行为验证通过。
