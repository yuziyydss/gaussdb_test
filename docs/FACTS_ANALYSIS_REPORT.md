# GaussDB 集中式版参考 事实分析报告

## 概览

| 指标 | 值 |
|---|---:|
| SQL Reference facts | 3937 |
| Functional domains | 16 |
| Fact types | syntax/behavior_oracle/constraint/environment |
| Waves | 19-225 (207 waves) |

## Fact 类型分布

| 类型 | 数量 | 占比 | 说明 |
|---|---:|---:|---|
| syntax | 1684 | 42% | 语法结构（SQL语法/参数定义/系统表字段） |
| constraint | 1828 | 46% | 约束（行为限制/规格差异/条件限制） |
| behavior_oracle | 402 | 10% | 行为预言（可执行的验证用例） |
| environment | 23 | 0% | 环境（工具/系统配置/运行时参数） |

## 功能域分布

| 功能域 | facts | 占比 | 主要来源波次 |
|---|---:|---:|---|
| DML | 740 | 18% | wave 0 |
| Compatibility | 603 | 15% | wave 0 |
| DDL | 527 | 13% | wave 0 |
| Other | 444 | 11% | wave 0 |
| GUC/Config | 443 | 11% | wave 0 |
| Functions | 246 | 6% | wave 0 |
| Transaction | 186 | 4% | wave 0 |
| DataTypes | 172 | 4% | wave 0 |
| Index | 159 | 4% | wave 0 |
| Security | 145 | 3% | wave 0 |
| SystemCatalog | 68 | 1% | wave 0 |
| View | 52 | 1% | wave 0 |
| BackupRecovery | 51 | 1% | wave 0 |
| PLSQL | 44 | 1% | wave 0 |
| Identifier | 36 | 0% | wave 0 |
| Operators | 21 | 0% | wave 0 |

## 各功能域详细分析

### DML (740 facts)

**说明**: INSERT/DELETE/UPDATE/SELECT/MERGE/COPY/LOAD DATA等数据操作

**类型分布**: syntax=277, constraint=317, behavior_oracle=141, environment=5

**代表性 facts**:

- `deallocate_wave8_100_syntax` (1.13.10.1 功能描述/注意事项/语法格式/参数说明 页1646): DEALLOCATE从数据库中删除一条预备语句，可手动释放通过PREPARE创建的预处理语句，未显式释放时预处理语句会在会话结束时自动清除；语法为DEALLOCATE [ PREPARE ] { name | ALL }，PREPARE可选仅用于语法兼容性实际执行时被忽略，ALL删除所有预备语句。...
- `deallocate_wave8_100_example` (1.13.10.1 示例 页1646-1647): 示例：PREPARE q1..q4四个预备语句后SELECT name, statement, parameter_types FROM pg_prepared_statements显示4行；DEALLOCATE q4后剩3行；DEALLOCATE ALL返回DEALLOCATE ALL且查询结果为...
- `declare_wave8_100_params` (1.13.10.2 参数说明 页1648-1649): 参数：cursor_name为将要创建的游标名（符合标识符命名规范的字符串）；BINARY指定游标以二进制格式返回而不是文本格式返回数据；NO SCROLL声明该游标不能用于以倒序的方式检索数据行，未指定时根据执行计划的不同自动判断该游标是否可以用于以倒序的方式检索数据行；query使用SELECT...
- `declare_wave8_100_cursor_example` (1.13.10.2 示例 页1649-1650): 示例：START TRANSACTION后DECLARE cursor1 CURSOR FOR SELECT * FROM test ORDER BY 1；FETCH FORWARD 3 FROM cursor1返回1|1、2|2、3|3三行；CLOSE cursor1后END提交事务。...
- `do_wave8_100_example` (1.13.10.4 示例 页1657): 示例：DO $$DECLARE r record; BEGIN FOR r IN SELECT c.relname table_name,n.nspname table_schema FROM pg_class c,pg_namespace n WHERE c.relnamespace = n.oi...

### Compatibility (603 facts)

**说明**: MySQL/Oracle/PostgreSQL兼容性差异、字符集字符序

**类型分布**: syntax=226, constraint=356, behavior_oracle=18, environment=3

**代表性 facts**:

- `mcompat_sql_intro_wave8_102_overview` (2.1 什么是SQL 页1962): SQL是用于访问和处理数据库的标准计算机语言，提供各种任务的语句包括：查询数据；在表中插入、更新和删除行；创建、替换、更改和删除对象；控制对数据库及其对象的访问；保证数据库的一致性和完整性；SQL语言由处理数据库和数据库对象的命令和函数组成，并强制实施有关数据类型、表达式和文本使用的规则，因此SQL...
- `mcompat_charset_wave8_102_overview` (2.3 字符集与字符序 页1992): 字符集（Character Set）是字符的编码规则，字符序（Collation）是字符的排序规则，相关规则和语法仅在M-Compatibility下支持；要求：每一个字符集都有一个或多个字符序且只有一个默认字符序；每一个字符序仅有一个相关联的字符集；相同数据使用不同字符序排序结果可能不同；utf8...
- `mcompat_charset_wave8_102_functions` (2.3 字符集与字符序 页1992-1993): M-Compatibility字符集和字符序支持功能：支持多种字符集存储字符串；支持使用字符序比较字符串；支持数据库级、模式级、表级、字段级字符集和字符序；除SQL_ASCII库外，其他字符集的数据库支持多字符集混用。...
- `mcompat_charset_wave8_102_charsets` (2.3 表2-2 字符集列表 页1993): M-Compatibility支持的字符集（表2-2）：utf8（针对Unicode的可变长度字符编码，1~4字节，默认字符序utf8mb4_general_ci）、utf8mb4（与utf8为同一字符集，utf8mb4_general_ci）、gbk（国标汉字编码扩展字符集，gbk_chinese...
- `mcompat_charset_wave8_102_notes` (2.3 表2-2 说明 页1993): 字符集注意事项：binary字符集实际通过已有字符集SQL_ASCII实现；GaussDB字符集间转换逻辑与mysql存在差异，可能存在特殊字符在M-Compatibility下可转换而mysql下转换失败，不建议使用生僻特殊字符；GaussDB对不属于当前字符集的非法字符未执行严格的编码逻辑校验，...

### DDL (527 facts)

**说明**: CREATE/ALTER/DROP TABLE/INDEX/SCHEMA等DDL语句

**类型分布**: syntax=186, constraint=265, behavior_oracle=76, environment=0

**代表性 facts**:

- `rollback_wave8_100_example` (1.13.18.11 示例 页1800-1801): 示例：START TRANSACTION后ALTER TABLE test ADD COLUMN score int，\d test显示score列；ROLLBACK后\d test显示表结构恢复初始状态（无score列）；相关链接COMMIT | END。...
- `ddl_overview_wave8_101_syntax` (1.13.3 DDL语法一览表 页1172): DDL（Data Definition Language，数据定义语言）用于定义和修改数据库对象，主要包括CREATE、ALTER和DROP等语句，用于创建、修改和删除数据库中的对象（例如表、索引、视图、约束、数据类型定义等）；删除一个数据库角色所拥有的数据库对象参见DROP OWNED；说明：Ga...
- `ddl_categories_wave8_101_part1` (1.13.3 表1-321~1-341 页1172-1183): DDL语法一览表对象分类（表1-321~1-341）：客户端加密主密钥（表1-321）、列加密密钥（表1-322）、数据库（表1-323）、模式（表1-324）、表空间（表1-325）、表（表1-326）、分区表（表1-327）、索引（表1-328）、存储过程（表1-329）、函数（表1-330）、...
- `ddl_categories_wave8_101_part2` (1.13.3 表1-342~1-363 页1183-1186): DDL语法一览表对象分类续（表1-342~1-363）：外部数据封装器（表1-342）、外表（表1-343）、gs_global_config系统表相关SQL（表1-344）、用户组（表1-345）、过程语言（表1-346）、脱敏策略（表1-347）、物化视图（表1-348）、资源标签（表1-349...
- `ddl_standalone_wave8_101_statements` (1.13.3 独立语句小节 页1185-1186): DDL一览表中的独立语句：清理回收站PURGE；根据一个索引对表进行聚簇排序CLUSTER；创建或修改一个对象的注释COMMENT；根据查询结果创建一个新表并将查询到的数据插入新表SELECT INTO；人为操作或应用程序错误时将表恢复到一个早期状态TIMECAPSULE TABLE；快速地从表中删...

### Other (444 facts)

**说明**: 未明确分类的杂项

**类型分布**: syntax=193, constraint=182, behavior_oracle=65, environment=4

**代表性 facts**:

- `rollback_savepoint_wave8_100_semantics` (1.13.18.13 功能描述/注意事项 页1802): 回滚所有指定保存点建立之后执行的命令；保存点仍然有效，并且需要时可以再次回滚到该点；不能回滚到一个未定义的保存点，语法上会报错。...
- `dcl_role_user_wave8_101_tables` (1.13.2 表1-318/表1-319 页1171-1172): 角色定义相关SQL（表1-318）：创建角色CREATE ROLE、修改角色属性ALTER ROLE、删除角色DROP ROLE；用户定义相关SQL（表1-319）：创建用户CREATE USER、修改用户属性ALTER USER、删除用户DROP USER。...
- `ddl_schema_wave8_101_category` (1.13.3 定义数据库/定义模式 页1173-1174): 定义数据库：数据库是组织、存储和管理数据的仓库，数据库定义主要包括创建数据库、修改数据库属性以及删除数据库（表1-323）；定义模式：模式是一组数据库对象的集合，主要用于控制对数据库对象的访问，涉及SQL语句如表1-324（CREATE SCHEMA等）。...
- `mcompat_sql_intro_wave8_102_history` (2.1 SQL发展简史/GaussDB支持的SQL标准 页1962-1963): SQL发展简史：1986年ANSI X3.135-1986/ISO 9075:1986（SQL-86）、1989年SQL-89、1992年SQL-92、1999年SQL:1999、2003年SQL:2003、2011年SQL:2011、2016年SQL:2016、2019年SQL:2019；Gaus...
- `m_alter_resource_label_wave8_104_example` (2.4.2.6.7 示例 页2024): 示例（m_db）：CREATE RESOURCE LABEL table_label ADD COLUMN(table_for_label.col1)后ALTER RESOURCE LABEL table_label ADD COLUMN(table_for_label.col2)将col2添加至标...

### GUC/Config (443 facts)

**说明**: GUC参数配置、内存管理、线程池、资源管理

**类型分布**: syntax=215, constraint=206, behavior_oracle=20, environment=2

**代表性 facts**:

- `sql_format_wave8_101_conventions` (1.13.1 表1-317 页1170-1171): SQL语法格式说明（表1-317）：[]表示用[]括起来的部分是可选的；...表示前面的元素可重复出现；[ x | y | ... ]表示从两个或多个选项中选取一个或者不选；{ x | y | ... }表示从两个或多个选项中选取一个；[ x | y | ... ] [ ... ]表示可选多个参数或...
- `m_alter_database_wave8_103_permission` (2.4.2.6.2 注意事项 页2014-2015): 只有模式的所有者或被授予了模式ALTER权限的用户可以执行ALTER DATABASE命令（三权分立开关关闭时系统管理员默认拥有此权限），修改模式所有者时当前用户必须是该模式所有者或系统管理员且是新所有者角色的成员；对于除public以外的系统模式（如pg_catalog、sys等）只允许初始用户修...
- `m_alter_group_wave8_103_params` (2.4.2.6.5 参数说明 页2020): user_name为现有角色名（角色名要求参见CREATE ROLE章节中的role_name）；group_name为现有用户组名（取值范围为已存在的角色名）；new_name为新角色名称（字符串符合标识符说明，角色名要求参见CREATE ROLE章节中的role_name）。...
- `m_alter_sequence_wave8_104_params` (2.4.2.6.10 参数说明 页2029): 参数：MAXVALUE新修改的最大值必须大于当前的last_value（取值范围(last_value, 2^63-1]，使用LARGE标识时为(last_value, 2^127-1]，未指定保持旧最大值）；CACHE为快速访问在内存中预先存储序列号的个数（取值[1, 2^63-1]，LARGE时...
- `m_alter_session_wave8_104_params` (2.4.2.6.11 参数说明 页2031): 参数：config_parameter可用SHOW ALL查看（DEFAULT/OFF/RESET为缺省值语义，用户指定值需满足取值限制，FROM CURRENT取当前会话值）；TIME ZONE对应运行时参数TimeZone（DEFAULT缺省PRC）；CURRENT_SCHEMA指定当前模式（模...

### Functions (246 facts)

**说明**: 系统函数/内置函数/聚合函数/字符串/日期/JSON等

**类型分布**: syntax=121, constraint=108, behavior_oracle=17, environment=0

**代表性 facts**:

- `do_wave8_100_syntax` (1.13.10.4 功能描述/注意事项/语法格式/参数说明 页1657): DO执行匿名代码块，代码块被看作是没有参数的一段函数体，返回值类型是VOID，其解析和执行同时进行；语法为DO [ LANGUAGE lang_name ] code，lang_name为解析代码的程序语言名称（未指定时默认为plpgsql），code必须指定为字符串；程序语言在使用之前必须通过CR...
- `mcompat_keywords_wave8_102_table` (2.2 表2-1 SQL关键字 页1963-1992): 表2-1 SQL关键字列出关键字及其类型分类（保留/非保留/保留（可以是函数或类型）/非保留（不能是函数或类型）），例如ABSOLUTE为非保留、ACCESSIBLE为保留、ACCOUNT/ACTION/ACTIVE/ADD/ADDDATE/ADMIN等为非保留。...
- `m_alter_table_wave8_105_addcolumn_default` (2.4.2.6.12 注意事项 页2032-2033): ADD COLUMN增加字段时所有现有行初始化为缺省值；新增列没有声明DEFAULT值时默认值为NULL且不会触发全表更新；新增列有DEFAULT值时必须符合以下所有要求否则会带来全表更新影响在线业务：数据类型必须为TINYINT、SMALLINT、BIGINT、INTEGER、NUMERIC、DE...
- `m_create_sequence_wave8_110_nextval_note` (2.4.2.8.15 注意事项 页2116): 创建序列后在表中使用序列的nextval()函数和generate_series(1,N)函数对表插入数据时，请保证nextval的可调用次数大于等于N+1次，否则会因为generate_series()函数会调用N+1次而导致报错；Sequence默认最大值为2^63-1。...
- `m_ctp_wave8_112_range_items` (2.4.2.8.17 语法格式 页2139): 分区项语法：partition_less_than_item为PARTITION partition_name VALUES LESS THAN {( { partition_value | MAXVALUE } [,...] ) | MAXVALUE } [TABLESPACE [=] table...

### Transaction (186 facts)

**说明**: 事务控制、隔离级别、SAVEPOINT、autocommit

**类型分布**: syntax=68, constraint=104, behavior_oracle=14, environment=0

**代表性 facts**:

- `declare_wave8_100_syntax` (1.13.10.2 功能描述/语法格式 页1647-1648): DECLARE既可以定义一个游标（在一个大的查询里面检索少数几行数据），也可以用于声明匿名块（需放置在匿名块的语句之前，用法参见BEGIN章节）；定义游标语法为DECLARE cursor_name [ BINARY ] [ NO SCROLL ] CURSOR [ { WITH | WITHOUT...
- `declare_wave8_100_binary` (1.13.10.2 注意事项 页1648): 游标命令只能在事务块里使用；谨慎使用二进制游标：文本格式一般比对应的二进制格式占用的存储空间大，二进制游标返回内部二进制形态的数据可能更易于操作（整数1在缺省游标里获得字符串1，在二进制游标里将得到一个4字节的包含该数值内部形式的数值（大端顺序））；以文本方式显示数据时文本检索会为用户节约很多客户端...
- `declare_wave8_100_hold` (1.13.10.2 参数说明 页1648-1649): WITH HOLD在创建游标的事务结束后该游标仍可继续使用；WITHOUT HOLD在事务之外不能再继续使用该游标，游标将在事务结束时被自动关闭；未指定WITH HOLD或WITHOUT HOLD时默认行为是WITHOUT HOLD；须知：声明为WITH HOLD的游标在事务结束时会缓存游标所有数据...
- `declare_wave8_100_anon_block` (1.13.10.2 语法格式/参数说明/示例 页1649-1650): 开启匿名块语法为[DECLARE [declare_statements]] BEGIN execution_statements END; /；declare_statements用于声明变量（包括变量名和变量类型，如"sales_cnt int"），execution_statements为匿名...
- `rollback_wave8_100_syntax` (1.13.18.11 功能描述/语法格式/参数说明 页1800): ROLLBACK回滚当前事务并取消当前事务中的所有更新：事务运行过程中发生故障不能继续执行时，系统将事务中对数据库的所有已完成操作全部撤销，数据库状态回到事务开始时；语法为ROLLBACK [ WORK | TRANSACTION ]，WORK/TRANSACTION为可选关键字除增加可读性外没有任...

### DataTypes (172 facts)

**说明**: 数据类型规格、类型转换、精度/标度

**类型分布**: syntax=132, constraint=30, behavior_oracle=10, environment=0

**代表性 facts**:

- `m_logic_wave8_121_type_rules` (2.5.2 表2-41 页2316): 逻辑运算类型归类（表2-41）：不同大类型之间的数据操作时先提升到大类型，再根据提升后的大类型的结果是否为0进行计算；XOR所有类型归类BIGINT；AND/OR/NOT对整型系列（TINYINT、SMALLINT、MEDIUMINT、INT/INTEGER、BIGINT及各UNSIGNED）、BI...
- `m_cast_wave8_125_examples` (2.5.9 CAST 示例 页2393): CAST示例基线（m_db）：CAST('abc' AS BINARY(2))带WARNING: Truncated incorrect binary(2) value: 'abc'返回ab；CAST('abc' AS CHAR(10))返回abc；CAST('2023/1/1' AS DATE)返...
- `m_dt2_wave8_130_bool_example` (2.6.2 布尔类型 示例 页2484): 布尔类型示例基线（m_db）：WHERE bt_col1 = 't'产生WARNING: The INTEGER value 't' is incorrect、WARNING: The DECIMAL value 't' is incorrect、WARNING: The double value ...
- `m_expr_case_when_wave8_131_example` (2.8.2 CASE 页2524-2525): 条件表达式CASE子句可以用于合法的表达式中（condition是返回BOOLEAN数据类型的表达式，结果为真时CASE表达式结果为符合该条件所对应的result；CASE表达式的语法图如图2-1 case::=）。...
- `sp_wave8_138_subtype_examples` (3.2.1 示例 页2541-2542): SUBTYPE示例基线：无约束子类型sint IS INT赋值2147483647回显；typmod约束sdec IS DECIMAL(3,2) NOT NULL赋值1.1回显1.10、变量级再约束b sdec(5,2)赋322.1回显322.10；仅支持基类型的类型构造器（a sarrint :=...

### Index (159 facts)

**说明**: 索引创建/管理/索引差异/GPI/前缀索引

**类型分布**: syntax=63, constraint=94, behavior_oracle=2, environment=0

**代表性 facts**:

- `mcompat_keywords_wave8_102_categories` (2.2 关键字 页1963): SQL关键字分保留关键字和非保留关键字：保留关键字绝不能用作其他标识符；非保留关键字只在特定环境有特殊含义，其他环境可作标识符；M-Compatibility在此基础上细化为四类：保留（一般的保留关键字，不可作为任何数据库对象（表、列、函数、类型、视图、索引以及变量等）的标识符）、非保留（一般的非保...
- `m_alter_index_wave8_104_fillfactor` (2.4.2.6.6 参数说明/说明 页2022-2023): SET当前支持修改的参数为FILLFACTOR（定义索引页面的填充率，高并发插入且键值分布密集时建议设置较低的填充因子以减少索引页竞争，取值范围10~100百分比）；使用该命令修改或重置索引存储参数时不会对索引的内容进行立即更新，根据参数类型可能需要通过REINDEX命令重建索引以实现预期效果。...
- `m_alter_table_wave8_105_change` (2.4.2.6.12 说明 页2036-2037): CHANGE修改字段名称和定义：字段新名称不能是已有字段名称，用新名称和定义替换原名称和定义，原字段索引、独立对象约束不会被删除；不支持修改分区键字段的数据类型和排序规则，不支持修改规则引用的字段的数据类型和排序规则；被生成列引用的字段数据重新生成；被依赖对象修改过程将重建（违反约束失败）；修改字符...
- `m_alter_table_wave8_105_drop_column` (2.4.2.6.12 说明 页2037): DROP [ COLUMN ]删除字段时和该字段相关的索引和表约束也会被自动删除；CASCADE选项在M-compatibility模式兼容版本控制开关s1及以上版本（如m_format_dev_version = 's1'）时仅语法支持但实际不生效；DROP COLUMN并非物理删除，只是标记为对...
- `m_alter_table_wave8_105_storage_params` (2.4.2.6.12 参数说明 页2039-2040): SET存储参数：FILLFACTOR数据页填充率（Ustore引擎默认92，Astore引擎默认100，取值10~100百分比，频繁更新的表选择较小填充因子更合适）；INIT_TD创建Ustore表时初始化TD数量（取值[2, 128]默认4，MAX_TUPLE_SIZE = BLCKSZ - IN...

### Security (145 facts)

**说明**: 安全认证/SSL/密码策略/审计/加密/RLS

**类型分布**: syntax=65, constraint=61, behavior_oracle=11, environment=8

**代表性 facts**:

- `ddl_pattern_wave8_101_mapping` (1.13.3 表1-322/1-323 页1172-1173): 一览表各对象分类通常按创建/修改/删除映射对应的CREATE/ALTER/DROP语句，例如：数据库定义（表1-323）为CREATE DATABASE、ALTER DATABASE、DROP DATABASE；列加密密钥定义（表1-322）为CREATE COLUMN ENCRYPTION KEY...
- `m_alter_audit_policy_wave8_103_all_semantics` (2.4.2.6.1 参数说明 页2013): { PRIVILEGES | ALL }的ALL指所有PRIVILEGES操作，{ ACCESS | ALL }的ALL指所有ACCESS操作；policy_comments用于记录策略相关的描述信息；ENABLE | DISABLE打开或关闭统一审计策略。...
- `m_alter_audit_policy_wave8_103_example` (2.4.2.6.1 示例 页2014): 示例（m_db）：CREATE AUDIT POLICY adt1 PRIVILEGES CREATE后ALTER AUDIT POLICY adt1 ADD PRIVILEGES (DROP)添加、REMOVE PRIVILEGES (DROP)删除；COMMENTS 'adt1_comments...
- `m_alter_role_wave8_104_password` (2.4.2.6.8 参数说明 页2026-2027): ACCOUNT LOCK锁定账户禁止登录数据库，ACCOUNT UNLOCK解锁允许登录；当前版本不允许修改角色的PGUSER属性；密码规则：除初始用户外其他管理员或普通用户修改自己的密码需输入正确的旧密码，只有初始用户、三权分立关闭时的系统管理员或拥有CREATEROLE权限的用户才可以重置普通用...
- `m_alter_user_wave8_106_related` (2.4.2.6.15 参数说明 页2062): user_name为已存在的用户名（用户名要求参见CREATE USER章节）；old_password为旧密码；其他参数请参见CREATE ROLE和ALTER ROLE的参数说明；相关链接CREATE ROLE、CREATE USER、DROP USER。...

### SystemCatalog (68 facts)

**说明**: 系统表/系统视图/系统Schema

**类型分布**: syntax=32, constraint=25, behavior_oracle=11, environment=0

**代表性 facts**:

- `mcompat_identifier_wave8_102_case_sensitive` (2.4.1 大小写敏感 页2003): 大小写敏感（lower_case_table_names=0时）：完全区分大小写的标识符有库名、Schema名、表名、用户视图名以及information_schema系统视图中以上对象对应字段的值，创建和使用过程严格区分大小写；lower_case_table_names=1时：库、Schema名...
- `mcompat_identifier_wave8_102_column_case` (2.4.1 大小写敏感 页2003): 列名存储区分大小写、比较时不区分大小写：列名在内部按照真实的大小写存储，正常使用则不区分大小写；其余标识符：在标识符内部为全小写不区分大小写，如果使用双引号（需设置sql_mode为ansi_quotes）或反引号修饰时则区分大小写；指定Schema或TABLE修饰时，lower_case_tabl...
- `dbefile_wave8_149_open_fopen` (3.12.2.5 OPEN/FOPEN 页2736-2737): OPEN/FOPEN原型：DBE_FILE.OPEN(dir IN TEXT, file_name IN TEXT, open_mode IN TEXT, max_line_size IN INTEGER DEFAULT 1024) RETURN INTEGER与DBE_FILE.FOPEN(......
- `dbefile_wave8_149_remove` (3.12.2.5 REMOVE 页2744-2745): REMOVE：DBE_FILE.REMOVE(dir IN TEXT, file_name IN TEXT)根据指定目录和文件名删除一个磁盘文件，操作需具备充分权限；目录需在PG_DIRECTORY注册、safe_data_path开启时仅能操作白名单路径。...
- `ilm_wave8_151_execute_proto` (3.12.2.7 EXECUTE_ILM 页2757-2758): EXECUTE_ILM原型：DBE_ILM.EXECUTE_ILM(OWNER IN VARCHAR2, OBJECT_NAME IN VARCHAR2, TASK_ID OUT NUMBER, SUBOBJECT_NAME IN VARCHAR2 DEFAULT NULL, POLICY_NAME...

### View (52 facts)

**说明**: 视图创建/修改/依赖关系

**类型分布**: syntax=31, constraint=18, behavior_oracle=3, environment=0

**代表性 facts**:

- `dcl_overview_wave8_101_syntax` (1.13.2 DCL语法一览表 页1171): DCL（Data Control Language，数据控制语言）用于定义和控制用户对数据库对象（如表、视图、存储过程等）以及数据库实例本身的访问权限：授权语句参见GRANT；收回权限参见REVOKE；设置应用于将来创建对象的默认权限参见ALTER DEFAULT PRIVILEGES；修改数据库对...
- `m_alter_view_wave8_106_permission` (2.4.2.6.16 注意事项 页2062-2063): 只有视图的所有者或被授予了视图ALTER权限的用户才可以执行ALTER VIEW（三权分立开关关闭时系统管理员默认拥有该权限）；修改视图的模式时当前用户必须是视图所有者或系统管理员且要有新模式的CREATE权限（三权分立打开时系统管理员不能修改视图模式）；修改视图所有者时当前用户必须是视图所有者或系...
- `m_drop_view_wave8_116_example` (2.4.2.9.19 示例 页2204): 示例参见示例（视图删除示例接CREATE VIEW章节的test_v1）；相关链接ALTER USER、CREATE VIEW。...
- `alert_wave8_147_view` (3.12.2.1 视图查询示例 页2719): DBE_ALERT.DBE_ALERT_INFO视图：以name、sid、changed、message列展示当前注册的警报信息；示例中remove与removeall后查询该视图返回0行。...
- `ilm_wave8_151_concurrency` (3.12.2.7 EXECUTE_ILM说明 页2759): EXECUTE_ILM与STOP_ILM并发限制：两者并发时有较低概率导致任务FAILED，gs_adm_ilmresults视图comments字段显示tuple concurrently updated。...

### BackupRecovery (51 facts)

**说明**: 备份恢复/checkpoint/WAL/DCF

**类型分布**: syntax=27, constraint=18, behavior_oracle=5, environment=1

**代表性 facts**:

- `dcl_params_wave8_101_table` (1.13.2 表1-320 页1172): 修改/显示/恢复运行参数相关SQL（表1-320）：修改运行时配置参数SET、修改会话ALTER SESSION、显示当前运行时参数的数值SHOW、将指定的运行时参数恢复为默认值RESET。...
- `m_alter_role_wave8_104_params` (2.4.2.6.8 参数说明 页2026): IN DATABASE database_name表示修改角色在指定数据库上的参数；SET修改的会话参数只针对指定的角色且在下一次该角色启动的会话中有效；DEFAULT表示清除参数值（继承本角色新产生SESSION的默认值）；FROM CURRENT取当前会话中的值设置为参数值；RESET ALL把...
- `dbestats_wave8_165_import_index_example` (3.12.2.20 IMPORT_INDEX_STATS示例 页2937-2938): IMPORT_INDEX_STATS示例基线：导入statid='idx_s1'的统计信息后，PG_CLASS中idx_t2_local_a恢复relpages 6/reltuples 6，PG_PARTITION中s1~s6_idx_a恢复relpages 1/reltuples 0。...
- `dbetask_wave8_168_node_failover` (3.12.2.21 约束说明 页2981): 主节点故障影响：用户创建的每个任务和数据库主节点绑定；任务运行过程中该数据库主节点发生故障则任务状态无法实时刷新仍为'r'状态，需等主节点启动正常后才能刷新为's'状态；任务未执行时主节点发生故障则该节点上的任务得不到正常调度和执行，需人为干预让主节点恢复正常或进行节点删除/替换后JOB才能正常调度...
- `dbetask_wave8_168_sync_overhead` (3.12.2.21 约束说明 页2981): JOB信息同步机制：JOB定时执行过程中需在所属主节点上实时更新运行状态、最近执行开始/结束时间、下次开始时间和失败次数等参数到PG_JOB系统表并同步到其他主节点；其他主节点故障时JOB所属主节点会同步超时重发导致JOB执行时间变长，但同步超时失败后原主节点上PG_JOB表中JOB信息仍能正常更新...

### PLSQL (44 facts)

**说明**: 存储过程/函数/触发器/匿名块/自治事务

**类型分布**: syntax=24, constraint=16, behavior_oracle=4, environment=0

**代表性 facts**:

- `dml_cursor_wave8_101_table` (1.13.4 表1-367 页1188): 游标定义相关SQL（表1-367）：创建游标CURSOR与DECLARE、移动游标MOVE、关闭游标CLOSE；借助游标，存储过程可以控制上下文区域的变化。...
- `sp_wave8_138_nested_calls_vars` (3.5.3.3 嵌套子程序调用规则/变量 页2583-2585): 嵌套子程序调用与变量规则：可调用自身实现递归调用；可调用上层作用域声明的子程序；可调用本地声明的下层子程序但不可访问下层子程序内部的嵌套子程序；可调用相同作用域中先于自身声明的子程序。嵌套子程序变量类型包括基础类型、record类型、table of类型、cursor类型和varray类型等其它PL...
- `sp_wave8_139_array_type_syntax` (3.4.1.1 数组类型的使用 语法 页2544-2545): 数组类型定义语法：TYPE array_type IS VARRAY(size) OF data_type;在存储过程中紧跟AS关键字后面定义；array_type为要定义的数组类型名，size取值为正整数表示可容纳成员的最大数量，data_type为数组成员类型；在存储过程中定义的数组类型其作用域...
- `sp_wave8_140_dynamic_call_proc_example` (3.7.3 动态调用存储过程示例 页2598-2599): 动态调用存储过程示例基线：proc_add(param1 in, param2 out, param3 in)计算param2=param1+param3，statement := 'call proc_add(:col_1, :col_2, :col_3)'后EXECUTE IMMEDIATE s...
- `sp_wave8_140_dynamic_anonymous_examples` (3.7.4 动态调用匿名块示例 页2600-2602): 动态匿名块示例基线：EXECUTE IMMEDIATE 'begin select first_name, salary into :first_name, :salary from hr.staffs where staff_id= :dno; end;' USING OUT first_name...

### Identifier (36 facts)

**说明**: 标识符/关键字/注释

**类型分布**: syntax=19, constraint=14, behavior_oracle=3, environment=0

**代表性 facts**:

- `other_overview_wave8_101_statements` (1.13.5 其他语法一览表 页1188-1190): 其他语法一览表包含：关闭当前节点、BUCKET扩容相关SQL、清理数据库连接、存储执行计划、预测、设置用户标识符、显示定时任务基本信息、对数据进行统一的版本控制、数据库升级相关SQL等。...
- `mcompat_identifier_wave8_102_quoted` (2.4.1 命名规范 页2002-2003): M-Compatibility标识符支持默认使用反引号（``）；当sql_mode设置为ANSI_QUOTES时标识符同时支持反引号（``）和双引号（""）；特殊情况下可以使用引号规避特殊字符报错；有引号标识符中允许的字符：ASCII为U+0001~U+007F，扩展为U+0080~U+FFFF。...
- `mcompat_identifier_wave8_102_unquoted` (2.4.1 命名规范 页2002-2003): 无引号标识符中允许的字符：ASCII为字母（a-zA-Z）、数字（0-9）、下划线（_）、美元符号（$）、井号（#）；扩展为U+0080~U+00FF；只允许字母、数字、下划线以及U+0080~U+00FF扩展字符作为开头。...
- `mcompat_identifier_wave8_102_char_limits` (2.4.1 命名规范 页2003): 标识符不支持使用U+0000或U+10000以上编码的字符；标识符支持以数字开头，但不能全部由数字组成，除非在引号标识符中。...
- `m_comment_wave8_107_permission` (2.4.2.8.3 注意事项 页2076): 对大多数对象，只有对象的所有者或被授予了对象COMMENT权限的用户可以设置注释（系统管理员默认拥有该权限）；角色没有所有者，COMMENT ON ROLE命令仅可以由系统管理员对系统管理员角色执行，有CREATE ROLE权限的角色也可以为非系统管理员角色设置注释；系统管理员可以对所有对象进行注释...

### Operators (21 facts)

**说明**: 操作符差异（REGEXP/LIKE/BETWEEN等）

**类型分布**: syntax=5, constraint=14, behavior_oracle=2, environment=0

**代表性 facts**:

- `m_logic_wave8_121_not_rules` (2.5.2 表2-39 页2315): NOT操作符运算规则（表2-39，操作数为布尔类型）：NOT TRUE结果为FALSE、NOT FALSE结果为TRUE、NOT NULL结果为空值。...
- `m_bit_wave8_121_semantics` (2.5.3 各操作符描述 页2317-2318): 位运算语义：&按位进行与操作；|按位进行或操作；^按位进行异或操作；<<左移操作；>>右移操作；~按位进行非操作。...
- `m_select_wave8_134_straight_join_example` (2.4.2.16.2 STRAIGHT_JOIN 页2252): STRAIGHT_JOIN示例基线：内联接场景下使用STRAIGHT_JOIN关键字可改变优化器联表查询的执行顺序（强制左表先于右表读取），用于优化器选择次优连接顺序时的调优。...
- `oracompat_wave8_182_plsql_not_supported` (4.3.10 页3186-3189): PL/SQL不支持项汇总：预定义的PL/SQL常量和类型/子类型不支持；**（幂运算）操作符不支持；STRING数据类型不支持；PLS_INTEGER不支持（可用int替代）。...
- `mcompat_wave8_192_identifier_quoted_numeric` (4.4.2.7.3 标识符 页3406-3407): 有引号标识符纯数字/科学计算法列名：GaussDB不支持直接使用需在引号中使用；点操作符（.）场景列名为纯数字或科学计算法也需要引号。...

## 与 Non-SQL Inventory 的关系

| 类别 | 数量 |
|---|---:|
| SQL Reference facts（本报告） | 3937 |
| Non-SQL Inventory facts（工具/存储过程/运行时参数等） | 2838 |
| **总计** | **6775** |
