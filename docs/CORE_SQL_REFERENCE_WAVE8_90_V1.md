# SQL Reference Wave 8-90 Extraction V1

## 目标

抽取 C 族第八批：`CREATE PACKAGE`、`CREATE PLUGGABLE DATABASE` 与 `CREATE RESOURCE LABEL`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.35` | 4 | CREATE PACKAGE |
| `1.13.9.36` | 3 | CREATE PLUGGABLE DATABASE |
| `1.13.9.38` | 3 | CREATE RESOURCE LABEL |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CREATE PACKAGE包头/包体语法、AUTHID DEFINER/CURRENT_USER调用者权限、SECURITY INVOKER默认与plsql_security_definer切换
- 包头声明与包体定义绑定、写锁/读锁规则、实例化中COMMIT/ROLLBACK限制
- 触发器/外部SQL/私有成员/同名Schema/Oracle兼容/同名变量/session级全局变量限制
- REF CURSOR与自治事务游标限制、带参数游标跨包%RowType与allow_procedure_compile_check行为
- 特殊字符命名、enable_force_create_obj依赖、CREATE ANY PACKAGE、初始用户REPLACE
- 函数默认值/复合类型调用/schema.func前缀/伪类型变长参数限制
- 变量初始化与实例化仅首次调用执行一次的语义
- pkg_test完整定义与CALL/SELECT/匿名块三种调用行为基线
- CREATE PLUGGABLE DATABASE语法（ENCODING/LC_COLLATE/LC_CTYPE/DBCOMPATIBILITY/DBTIMEZONE）
- 事务块/enable_mtd/非PDB/M兼容/角色权限/128个上限/A兼容默认限制
- M兼容PDB的sql_mode='ansi_quotes'前置操作
- 编码默认值与templatea/template0选择规则、DBCOMPATIBILITY四类型、DBTIMEZONE生效条件
- 多租示例与CLOSE IMMEDIATE后删除流程
- CREATE RESOURCE LABEL五类资源语法与IF NOT EXISTS语义
- POLADMIN/SYSADMIN/初始用户权限与63字节命名规则
- 五类资源标记与NOTICE/ERROR重复创建行为基线

## Open questions

| ID | 内容 |
|---|---|
| `create_package_pdb_label_wave8_90_oq_runtime` | PACKAGE实例化/游标跨包引用/AUTHID权限组合、PDB多租创建与删除在enable_mtd及资源计划下的完整行为、资源标签五类资源标记与脱敏策略联动的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_90_v1.yaml
generated/core_sql_reference_wave8_90_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_90.py
python scripts/build_core_sql_reference_wave8_90.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_90.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行PACKAGE/PDB/资源标签语句。
