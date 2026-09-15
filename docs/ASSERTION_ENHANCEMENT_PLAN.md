# Facts to Assertion Enhancement Plan

Total behavior_oracle facts: 276

## High-Impact Enhancements

### b_dt_int_truncation_silent
- Source: mysql_b_data_types
- Statement: 整数类型输入非法字符串部分被截断时（如'12@3'）直接截断无提示插表成功；全部截断或空串返回0。MySQL截断或返回0并报WARNING，严格模式插表失败。
- Enhancement Type: Boundary

### b_dt_int_no_type_promotion
- Source: mysql_b_data_types
- Statement: INT/INTEGER/SMALLINT/BIGINT运算时不向上提升类型，超范围报错；MySQL提升到BIGINT计算。
- Enhancement Type: Boundary

### b_dt_negative_cast
- Source: mysql_b_data_types
- Statement: 负数显式类型转换：宽松模式结果为0，严格模式报错；MySQL按二进制最高位替换计算。
- Enhancement Type: Error Precision

### b_dt_int_display_width
- Source: mysql_b_data_types
- Statement: INT[(M)]精度MySQL控制格式化输出，GaussDB仅语法支持不支持功能。不指定ZEROFILL时宽度信息不显示。
- Enhancement Type: Boundary

### b_int_input_truncation
- Source: mysql_b_mode_complete
- Statement: 整数输入差异：MySQL对'asbd'/'12dd'/'12 12'等截断或返回0并WARNING（严格模式插表失败）。GaussDB直接截断无提示插表成功（'12@3'→12）。全部截断（'@123'）或空串返回0插表成功。
- Enhancement Type: Boundary

### b_int_operator_no_promotion
- Source: mysql_b_mode_complete
- Statement: +-*/操作符差异：GaussDB INT/INTEGER/SMALLINT/BIGINT运算返回类型本身，不向上提升，超范围报错。MySQL提升到BIGINT计算。SELECT 2147483647+1在GaussDB报int4 overflow，MySQL返回2147483648。
- Enhancement Type: Boundary

### b_int_negative_cast
- Source: mysql_b_mode_complete
- Statement: 负数显式转换差异：GaussDB宽松模式结果为0，严格模式报错。MySQL按二进制最高位替换计算，如(-1)::uint4=4294967295。
- Enhancement Type: Error Precision

### b_int_display_width
- Source: mysql_b_mode_complete
- Statement: INT(M)精度差异：MySQL控制格式化输出，GaussDB仅语法支持不支持功能。不指定ZEROFILL时宽度信息在DESC中不显示。INSERT字符字段GaussDB统一补齐0。JOIN USING有符号类型宽度信息失效。greatest/least/ifnull/case when在类型宽度一致时GaussDB补0，MySQL不补。
- Enhancement Type: Boundary

### b_func_if_bool_only
- Source: mysql_b_mode_complete
- Statement: IF()差异：B模式中expr1仅支持bool类型，非bool不能转换则报错。expr2/expr3类型不同且无隐式转换函数则报错。NUMERIC/STRING/TIME类型GaussDB输出TEXT，MySQL输出VARCHAR。
- Enhancement Type: Error Precision

### b_func_ifnull_type
- Source: mysql_b_mode_complete
- Statement: IFNULL()差异：两入参类型不同且无隐式转换则报错。NUMERIC/STRING/TREE范畴GaussDB输出TEXT，MySQL输出VARCHAR。float4+bigint返回double，MySQL返回float。
- Enhancement Type: Error Precision

### b_driver_pbe_zero_char
- Source: mysql_b_mode_complete
- Statement: 驱动差异：PBE文本模式传参时，不含disable_zero_chars_conversion则\0替换为空格（与MySQL有差异），包含则禁止转换（一致）。setAutoCommit(false)后语句失败需rollback才能继续（MySQL只回滚失败语句）。setBigDecimal/setObject的NUMERIC与整型/时间运算精度为NUMERIC最大精度（与MySQL8.0一致）。s
- Enhancement Type: Boundary

### b_auto_increment_max_error
- Source: mysql_b_sql
- Statement: 自增值达字段类型最大值时继续自增产生错误；MySQL部分场景仍自增为最大值。
- Enhancement Type: Boundary

### m_charset_utf8_mb4_equivalence
- Source: mysql_m_charset_collation_transaction
- Statement: GaussDB将utf8和utf8mb4视为同一字符集。utf8字符集可指定utf8mb4字符序（MySQL报错GaussDB不报错），反之亦然。
- Enhancement Type: Error Precision

### m_charset_illegal_chars
- Source: mysql_m_charset_collation_transaction
- Statement: 严格模式下非法字符可能通过部分字符函数成功输入（MySQL会校验报错）。宽松模式下截断后插入（与MySQL一致）。由sql_mode的strict_trans_tables控制。
- Enhancement Type: Boundary

### m_collation_default
- Source: mysql_m_charset_collation_transaction
- Statement: utf8mb4字符集下默认字符序为utf8mb4_general_ci（与MySQL 5.7一致）。使用latin1字符序需设置m_format_dev_version='s2'。
- Enhancement Type: GUC Toggle

### m_transaction_nested
- Source: mysql_m_charset_collation_transaction
- Statement: 正常事务块中开启新事务会警告并忽略开启命令。异常事务块中开启新事务报错，必须先ROLLBACK/COMMIT。
- Enhancement Type: Error Precision

### m_dt_int_union_length
- Source: mysql_m_data_types
- Statement: 精度开关开启时UNION的CREATE TABLE AS场景中，GaussDB取整型最大长度（INT=11,BIGINT=20）计算列长；MySQL按实际长度。
- Enhancement Type: Boundary

### m_dt_precision_truncate
- Source: mysql_m_data_types
- Statement: DATETIME/TIME/TIMESTAMP精度超过最大支持精度时，GaussDB截断为最大精度，MySQL报错。
- Enhancement Type: Boundary

### m_dt_binary_fill_char
- Source: mysql_m_data_types
- Statement: BINARY插入长度小于目标时GaussDB填充0x20，MySQL填充0x00；导致比较/函数/索引/导入导出差异。
- Enhancement Type: Boundary

### m_dt_int_union_length
- Source: mysql_m_datatypes_complete
- Statement: 整数UNION CTAS差异：开启enable_precision_decimal时GaussDB取最大长度（INT=11，BIGINT=20）计算列长度；MySQL按实际长度。示例：SELECT 1234567 UNION ALL SELECT '456789'，GaussDB列类型varchar(11)，MySQL为varchar(7)。
- Enhancement Type: Boundary

### m_dt_timestamp_explicit_defaults
- Source: mysql_m_datatypes_complete
- Statement: TIMESTAMP差异：GaussDB不支持设置explicit_defaults_for_timestamp，行为与MySQL设为on时相同（NULL不替换为当前时间戳，不自动添加DEFAULT CURRENT_TIMESTAMP和ON UPDATE）。MySQL 5.7默认off，8.0默认on。
- Enhancement Type: GUC Toggle

### m_dt_precision_truncate
- Source: mysql_m_datatypes_complete
- Statement: DATETIME/TIME/TIMESTAMP精度超过最大时GaussDB截断为最大精度，MySQL报错。
- Enhancement Type: Boundary

### m_dcl_set_names_collate
- Source: mysql_m_dcl_user_privileges
- Statement: SET NAMES差异：SQL_ASCII库下GaussDB不支持指定与数据库字符集不同的charset_name。不指定字符集时MySQL报错但GaussDB不报错。
- Enhancement Type: Error Precision

### m_dcl_start_transaction_snapshot
- Source: mysql_m_dcl_user_privileges
- Statement: START TRANSACTION快照差异：MySQL可重复读下仅第一个SELECT建立快照。GaussDB事务开启后第一个DDL/DML/DCL也建立一致性读快照。支持多次设置隔离级别/访问模式/快照。
- Enhancement Type: GUC Toggle

### m_dcl_set_boolean_param
- Source: mysql_m_dcl_user_privileges
- Statement: SET BOOLEAN参数差异：GaussDB支持'1'/'0'/'true'/'false'字符串设置成功，MySQL失败。子查询结果为'true'/'false'/非整数1/0时GaussDB成功MySQL失败。NULL时GaussDB失败MySQL成功。
- Enhancement Type: Error Precision

### m_dcl_set_sql_mode_numeric
- Source: mysql_m_dcl_user_privileges
- Statement: SET sql_mode数字差异：MySQL校验表达式数据类型必须为整数（SET sql_mode='1'报错），GaussDB不做限制（SET sql_mode='4'成功、SET sql_mode=2+2e0成功）。
- Enhancement Type: Boundary

### m_op_null_order_default
- Source: mysql_m_operators
- Statement: MySQL排序时NULL排在前；GaussDB默认NULL排在最后。可用NULLS FIRST/LAST设置。
- Enhancement Type: GUC Toggle

### m_op_double_dash_comment
- Source: mysql_m_operators
- Statement: m_format_behavior_compat_options不含forbid_none_space_comment时，--表示注释而非两次取反。
- Enhancement Type: GUC Toggle

### m_op_string_to_double_error
- Source: mysql_m_operators
- Statement: 字符串转double遇非法字符串：MySQL常量报错字段不报错；GaussDB常量和字段都报错。
- Enhancement Type: Error Precision

### m_op_string_to_double_error
- Source: mysql_m_operators_complete
- Statement: 字符串转double非法：MySQL常量报错字段不报错，GaussDB常量和字段都报错。
- Enhancement Type: Error Precision

### m_op_double_dash
- Source: mysql_m_operators_complete
- Statement: --注释差异：m_format_behavior_compat_options不含forbid_none_space_comment时GaussDB表示注释（MySQL为两次取反），设置后一致。
- Enhancement Type: GUC Toggle

### m_op_regexp_diff
- Source: mysql_m_operators_complete
- Statement: REGEXP差异：GaussDB支持\d/\w/\s元字符（MySQL不支持视为普通字符）。GaussDB用\转义（MySQL用\\）。GaussDB支持非贪婪模式（??/*?/+?/{n}?），MySQL 5.7不支持报错。BINARY字符集下TEXT/BLOB转BYTEA后REGEXP无法匹配。
- Enhancement Type: Error Precision

### m_op_between_associativity
- Source: mysql_m_operators_complete
- Statement: BETWEEN AND嵌套：MySQL从右到左结合，GaussDB从左到右。设置between_and_independent_compare时GaussDB独立比较。MySQL的BETWEEN可能与(>=AND<=)不等价，GaussDB优先保证等价。
- Enhancement Type: GUC Toggle

### m_op_in_float_precision
- Source: mysql_m_operators_complete
- Statement: IN操作符float精度：开启精度传递时GaussDB按精度和标度比较（返回t），MySQL读内存失真值（返回0）。
- Enhancement Type: Boundary

### m_op_logic_execution
- Source: mysql_m_operators_complete
- Statement: AND/OR/XOR/|/&/</>/<=/>=/!=执行机制：MySQL先执行左操作数判断是否为空再决定执行右操作数。GaussDB执行左右操作数后再判断。左操作数为空且右操作数报错时MySQL不报错，GaussDB报错。
- Enhancement Type: Error Precision

### m_op_negative_type
- Source: mysql_m_operators_complete
- Statement: 取负(-)结果类型：CREATE TABLE t AS SELECT - -1时MySQL返回decimal(2,0)，GaussDB返回integer(1)。精度传递时负号精度差异。
- Enhancement Type: Boundary

### m_op_xor_overflow
- Source: mysql_m_operators_complete
- Statement: XOR差异：GaussDB有常数优化，SELECT 1 xor null xor pow(200,2000000)报溢出错误。MySQL返回NULL。
- Enhancement Type: Boundary

### m_fn_coalesce_union_precision
- Source: mysql_m_remaining_funcs
- Statement: COALESCE差异：UNION DISTINCT场景返回值精度与MySQL不完全一致。第一个非NULL参数后存在隐式类型转换错误时MySQL忽略，GaussDB报错。参数为MIN/MAX时返回类型不一致。
- Enhancement Type: Boundary

### m_fn_cast_json_precision
- Source: mysql_m_remaining_funcs
- Statement: CAST JSON精度差异：JSON类型显式转换后精度计算与MySQL 5.7不一致，与MySQL 8.0一致。CAST('98.7654321' AS JSON)后取负，GaussDB/MySQL8.0返回-98.7654321，MySQL5.7可能有精度差异。
- Enhancement Type: Boundary

### m_ddl_auto_increment_max_error
- Source: mysql_m_sql
- Statement: 自增值达字段类型最大值时继续自增产生错误；MySQL部分场景仍自增为最大值。
- Enhancement Type: Boundary

### m_dml_replace_time_zero_lenient
- Source: mysql_m_sql
- Statement: REPLACE插入时间0值：MySQL不受严格/宽松模式影响可插入；GaussDB宽松模式下成功，严格模式下报错。
- Enhancement Type: Error Precision

### m_sql_index_algorithm_lock_noop
- Source: mysql_m_sql_detailed
- Statement: CREATE/DROP INDEX的algorithm_option和lock_option在GaussDB仅语法支持，创建时不报错但实际不起作用。
- Enhancement Type: Error Precision

### m_sql_auto_increment_index_first
- Source: mysql_m_sql_detailed
- Statement: 自增列索引：GaussDB建议自增列为索引第一个字段（否则警告），MySQL必须为第一个字段（否则报错）。含自增列的表ALTER TABLE EXCHANGE PARTITION等操作会报错。
- Enhancement Type: Error Precision

### m_sql_auto_increment_null_behavior
- Source: mysql_m_sql_detailed
- Statement: 自增列NULL行为：表定义自增列为非NOT NULL时，插入不指定值——GaussDB插入NULL不触发自增，MySQL插入NULL触发自增。MySQL 5.7 check字段不生效（check+auto_increment同时只有auto_increment生效），GaussDB报错。
- Enhancement Type: Error Precision

### m_sql_multi_delete_concurrent
- Source: mysql_m_sql_detailed
- Statement: 多表DELETE并发差异：元组被并发修改时GaussDB仅对涉及并发更新的目标表重新匹配（可能数据不一致），MySQL对所有目标表一致。设置m_format_dev_version='s2'后多表校验规则保持一致。
- Enhancement Type: GUC Toggle

### m_sql_replace_time_zero
- Source: mysql_m_sql_detailed
- Statement: REPLACE时间零值差异：MySQL不受严格/宽松模式影响可插入0000-00-00 00:00:00。GaussDB宽松模式可插入，严格模式报错。REPLACE INTO test VALUES(f1,f2,f3)——MySQL成功插入零值，GaussDB严格模式报错。
- Enhancement Type: Error Precision

### m_sql_load_data_strict_mode
- Source: mysql_m_sql_detailed
- Statement: LOAD DATA差异：GaussDB执行结果与MySQL严格模式一致（宽松模式未适配）。导入含非法字符时GaussDB报错invalid byte sequence，MySQL宽松模式截断后导入。SET sql_mode=''后LOAD DATA仍报错。
- Enhancement Type: Boundary

### m_sql_insert_auto_increment_mixed
- Source: mysql_m_sql_detailed
- Statement: INSERT自增混合差异：导入数据或Batch Insert中混合0/NULL/确定值时，若产生错误后续插入自增值不一定与MySQL完全一致。可用auto_increment_cache控制行为。
- Enhancement Type: Error Precision

### m_fn_limit_offset_row_execution
- Source: mysql_m_sysfunc_detailed
- Statement: LIMIT+OFFSET场景：GaussDB逐行调用函数，存在报错时直接报错且中断执行。MySQL不逐行执行，不报错中断。导致带函数的LIMIT查询在存在错误数据时行为不一致。
- Enhancement Type: Error Precision

### m_fn_if_implicit_conversion
- Source: mysql_m_sysfunc_detailed
- Statement: IF()差异：第一个参数为TRUE且第三个参数有隐式类型转换错误（或FALSE且第二个参数有错误）时，MySQL忽略该错误返回另一个分支，GaussDB提示类型转换错误。
- Enhancement Type: Error Precision

### m_fn_datetime_subquery_truncate
- Source: mysql_m_sysfunc_detailed
- Statement: 子查询算术截断：SELECT 1*(SELECT DATE_ADD('2020-10-20',interval int_var microsecond)) FROM t1返回截断值2020（仅年份），而SELECT (SELECT 1*DATE_ADD(...))返回完整值20201020000000。子查询在外层算术内时截断。
- Enhancement Type: Boundary

### m_fn_current_time_precision_wrap
- Source: mysql_m_sysfunc_detailed
- Statement: CURRENT_TIME/CURRENT_TIMESTAMP精度：MySQL入参>255按255回绕（如257→1），GaussDB只支持[0,6]，其他值报错。SELECT CURRENT_TIME(257) MySQL等效CURRENT_TIME(1)，GaussDB报错。
- Enhancement Type: Boundary

### m_fn_period_add_overflow
- Source: mysql_m_sysfunc_detailed
- Statement: PERIOD_ADD差异：MySQL 5.7入参/结果超uint32(4294967296)时整数回绕，GaussDB无此问题。负数period：MySQL 5.7解析为异常值，GaussDB报错。月份越界（如200013）：MySQL 5.7顺延到下年，GaussDB报错。与MySQL 8.0一致。
- Enhancement Type: Error Precision

### m_fn_to_seconds_precision
- Source: mysql_m_sysfunc_detailed
- Statement: TO_SECONDS差异：MySQL 5.7精度信息有误。开启精度传递(enable_precision_decimal)时GaussDB精度正常，与MySQL 8.0一致。
- Enhancement Type: Boundary

### m_fn_lpad_max_length
- Source: mysql_m_sysfunc_detailed
- Statement: LPAD/RPAD最大填充长度：MySQL默认1398101，GaussDB默认1048576。GBK字符集GaussDB为2097152。超过最大值时截断。
- Enhancement Type: Boundary

### m_fn_replace_null_third
- Source: mysql_m_sysfunc_detailed
- Statement: REPLACE差异：第三入参为NULL且第二参数长度非0时，GaussDB返回NULL，MySQL返回第一参数。SELECT replace('1.23', binary(1.1), null) → GaussDB返回NULL，MySQL返回'1.23'。
- Enhancement Type: Boundary

### m_fn_md5_binary_padding
- Source: mysql_m_sysfunc_detailed
- Statement: MD5差异：BINARY类型插入字符串长度小于目标长度时，GaussDB填充0x20MySQL填充0x00，导致MD5(BINARY)结果不一致。
- Enhancement Type: Boundary

### m_fn_char_charset_error
- Source: mysql_m_sysfunc_detailed
- Statement: CHAR差异：指定字符集转码失败时GaussDB报错，MySQL返回NULL+WARNING。参数0-31/127时MySQL返回不可见字符，GaussDB返回\x01等十六进制。入参最多8192个（MySQL无限制）。
- Enhancement Type: Boundary

### m_fn_substring_binary_charset
- Source: mysql_m_sysfunc_detailed
- Statement: SUBSTR/SUBSTRING差异：第一入参字符序为BINARY时，MySQL可能按内层函数的字符序处理，GaussDB始终按BINARY字符序处理，导致截取字节长度不同。
- Enhancement Type: Boundary

### m_fn_avg_int_overflow
- Source: mysql_m_sysfunc_detailed
- Statement: AVG差异：BIT/BOOL/整数类型求和超BIGINT范围时GaussDB溢出整数翻转（MySQL不翻转）。TEXT/BLOB入参返回DOUBLE（与MySQL 8.0一致，MySQL 5.7返回MEDIUMTEXT）。
- Enhancement Type: Boundary

### m_fn_group_concat_return_type
- Source: mysql_m_sysfunc_detailed
- Statement: GROUP_CONCAT返回类型差异：GaussDB二进制返回BLOB，其他返回TEXT。MySQL按返回长度细分为longtext/tinytext/longblob/tinyblob。CTAS中列类型定义不同。
- Enhancement Type: Boundary

### m_fn_group_concat_nullif
- Source: mysql_m_sysfunc_detailed
- Statement: GROUP_CONCAT嵌套NULLIF差异：SELECT nullif(group_concat(1/7), 1/7) → GaussDB/MySQL8.0返回0.1429（精度不等），MySQL5.7返回NULL（精度相等）。
- Enhancement Type: Boundary

### m_fn_max_distinct_over
- Source: mysql_m_sysfunc_detailed
- Statement: MAX() OVER窗口中DISTINCT差异：SELECT MAX(DISTINCT salary) OVER(...) GaussDB报错不支持，MySQL 5.7返回结果。建议直接用MAX(salary) OVER(...)（DISTINCT不影响MAX结果）。
- Enhancement Type: Error Precision

### m_func_public_diff
- Source: mysql_m_system_functions_complete
- Statement: 系统函数公共差异：1)返回值类型仅Var/Const入参时与MySQL一致，运算/函数表达式入参可能不同。2)LIMIT+OFFSET场景GaussDB逐行调用函数（报错中断），MySQL不逐行。3)不推荐pg_catalog.func_name()调用。4)NULL入参时GaussDB直接返回NULL，MySQL校验非NULL入参。
- Enhancement Type: Error Precision

### m_func_if_error
- Source: mysql_m_system_functions_complete
- Statement: IF()差异：第一个参数为TRUE且第三个参数有隐式转换错误（或反之），MySQL忽略错误，GaussDB提示类型转换错误。
- Enhancement Type: Error Precision

### m_func_datetime_arith_truncate
- Source: mysql_m_system_functions_complete
- Statement: 日期函数算术截断：子查询包含时间函数且入参含表列时，外层算术运算会截断返回值。如SELECT 1*(SELECT DATE_ADD(...interval int_var...))返回截断值2020，而内层运算返回完整值20201020000000。
- Enhancement Type: Boundary

### m_func_replace_null
- Source: mysql_m_system_functions_complete
- Statement: REPLACE差异：第三个入参为NULL且第二个参数长度非0时，GaussDB返回NULL，MySQL返回第一个参数。SELECT replace('1.23', binary(1.1), null)。
- Enhancement Type: Boundary

### m_func_char_diff
- Source: mysql_m_system_functions_complete
- Statement: CHAR差异：指定字符集转码失败GaussDB报错，MySQL返回NULL+WARNING。参数0-31/127时MySQL不可见，GaussDB返回\x01等十六进制。入参最多8192个（MySQL无限制）。
- Enhancement Type: Boundary

### m_func_avg_overflow
- Source: mysql_m_system_functions_complete
- Statement: AVG差异：BIT/BOOL/整数类型求和超BIGINT范围时GaussDB溢出整数翻转。TEXT/BLOB入参GaussDB返回DOUBLE（与MySQL 8.0一致，MySQL 5.7返回MEDIUMTEXT）。
- Enhancement Type: Boundary

### m_func_group_concat_diff
- Source: mysql_m_system_functions_complete
- Statement: GROUP_CONCAT差异：1)DISTINCT+ORDER BY时ORDER BY表达式不在DISTINCT中则结果不稳定。2)ORDER BY数字只是常量不排序。3)二进制返回BLOB，其他返回TEXT（MySQL按长度细分为longtext/tinytext等）。4)group_concat_max_len最大1073741823（MySQL更大）。5)UTF8字符集最大字节数不同导致CT
- Enhancement Type: Boundary

### o_jdbc_struct_length_validation
- Source: oracle_jdbc_ddl_clauses
- Statement: JDBC Struct长度校验差异：字符类型attribute长度超限时Oracle在绑定入参时报错，GaussDB在构造/绑定时不对类型修饰符校验（由数据库执行时决定）。数组元素数量小于列数量时Oracle创建成功但执行时报错，GaussDB创建时就报错。
- Enhancement Type: Boundary

### o_query_prior_group_by
- Source: oracle_query_subquery
- Statement: 层次查询GROUP BY差异：GaussDB支持在GROUP BY中使用带PRIOR列的表达式（返回结果），Oracle报错not a GROUP BY expression。SELECT PRIOR c1+1 FROM test CONNECT BY PRIOR c2=c1 GROUP BY PRIOR c1+1在GaussDB返回2行，Oracle报错。
- Enhancement Type: Error Precision

### o_query_drop_primary_key
- Source: oracle_query_subquery
- Statement: DROP PRIMARY KEY差异：GaussDB仅支持DROP PRIMARY KEY语法，不支持CASCADE/KEEP INDEX/DROP INDEX/ONLINE选项。删除主键后GaussDB保留NOT NULL约束（插入NULL报错），Oracle同时删除NOT NULL约束。
- Enhancement Type: Error Precision

### o_fn_mod_return_type
- Source: oracle_sysfunc_detailed
- Statement: MOD差异：Oracle返回BINARY_DOUBLE/BINARY_FLOAT/NUMBER，GaussDB返回int2/int4/int8/numeric。第一入参为数值时第二参数须int/numeric或可转换类型。a_format_version=10c且dev_version=s6时text入参第二参数须int4范围。
- Enhancement Type: Boundary

### o_fn_round_float_precision
- Source: oracle_sysfunc_detailed
- Statement: ROUND差异：float类型GaussDB精度低于Oracle。round(n,integer) Oracle返回NUMBER，GaussDB返回numeric。round(n) GaussDB只能返回float8/numeric，缺少float4。SELECT round(NULL,'q') Oracle返回null，GaussDB报错。
- Enhancement Type: Boundary

### o_fn_chr_invalid_input
- Source: oracle_sysfunc_detailed
- Statement: CHR差异：数字不符合字符集时JDBC下GaussDB报错，Oracle返回乱码。输入0/256时Oracle返回ASCII 0字符，GaussDB在\0处截断。
- Enhancement Type: Boundary

### o_fn_nchr_byte_length
- Source: oracle_sysfunc_detailed
- Statement: NCHR差异：返回值字节长度与Oracle不一致。字节[0x80-0xFF]范围Oracle返回?或不输出或报错，GaussDB返回?。字符集限制导致结果不一致。
- Enhancement Type: Boundary

### o_fn_current_date_format
- Source: oracle_sysfunc_detailed
- Statement: CURRENT_DATE差异：GaussDB不支持nls_date_format参数设置显示格式。mapping_date_to_datea开启时返回datea，关闭时返回date。
- Enhancement Type: GUC Toggle

### ora_func_round_diff
- Source: oracle_system_functions_complete
- Statement: ROUND差异：float类型GaussDB精度低于Oracle。round(n,integer)返回numeric vs Oracle NUMBER。round(n)缺少float4返回类型。SELECT round(NULL,'q') Oracle返回null，GaussDB报错。
- Enhancement Type: Boundary

### ora_func_chr_diff
- Source: oracle_system_functions_complete
- Statement: CHR差异：数字不符合字符集时JDBC下GaussDB报错Oracle返回乱码。输入0/256时Oracle返回ASCII 0字符，GaussDB在\0处截断。
- Enhancement Type: Boundary

### ora_func_current_date_diff
- Source: oracle_system_functions_complete
- Statement: CURRENT_DATE差异：GaussDB不支持nls_date_format参数设置显示格式。mapping_date_to_datea开启时返回datea类型，关闭时返回date类型。
- Enhancement Type: GUC Toggle

### guc_bc_display_leading_zero
- Source: runtime_params_behavior_compat_detailed
- Statement: display_leading_zero：控制-1~0和0~1之间小数的小数点前0显示。不设置时0.123显示为.123；设置时显示为0.123。影响length()计算。
- Enhancement Type: GUC Toggle

### guc_bc_truncate_numeric_tail_zero
- Source: runtime_params_behavior_compat_detailed
- Statement: truncate_numeric_tail_zero：控制数值类型末尾零的截断行为。
- Enhancement Type: Boundary

### guc_bc_end_month_calculate
- Source: runtime_params_behavior_compat_detailed
- Statement: end_month_calculate：add_months函数月末计算逻辑。不设置时2月28日+3月=5月28日；设置时=5月31日（取月末）。M模式不生效。
- Enhancement Type: GUC Toggle

### guc_bc_proc_outparam_override
- Source: runtime_params_behavior_compat_detailed
- Statement: proc_outparam_override：控制存储过程出参覆盖行为（需配合behavior_compat_options设置）。
- Enhancement Type: GUC Toggle

### guc_bc_proc_outparam_transfer_length
- Source: runtime_params_behavior_compat_detailed
- Statement: proc_outparam_transfer_length：控制出参传值长度。
- Enhancement Type: Boundary

### guc_bc_bind_schema_tablespace
- Source: runtime_params_behavior_compat_detailed
- Statement: bind_schema_tablespace：设置search_path为schema_name时default_tablespace也同步切换。
- Enhancement Type: GUC Toggle

### guc_bc_select_into_return_one
- Source: runtime_params_behavior_compat_detailed
- Statement: select_into_return_one：控制SELECT INTO在无匹配行时是否返回一行NULL而非报错。
- Enhancement Type: Error Precision

### guc_bc_show_full_error_line
- Source: runtime_params_behavior_compat_detailed
- Statement: show_full_error_line：控制是否显示完整错误行号。
- Enhancement Type: Error Precision

### guc_bc_correct_to_number
- Source: runtime_params_behavior_compat_detailed
- Statement: correct_to_number：不设置时to_number()结果与A数据库一致；设置时与pg11一致。
- Enhancement Type: GUC Toggle

### guc_bc_unbind_divide_bound
- Source: runtime_params_behavior_compat_detailed
- Statement: unbind_divide_bound：控制除法边界行为。
- Enhancement Type: Boundary

### bc_example_display_leading_zero
- Source: runtime_params_behavior_compat_examples
- Statement: display_leading_zero SQL示例：SELECT 0.1231243 → 不设置显示.1231243（长度8），设置显示0.1231243（长度9）。影响numeric/integer转换和length()。
- Enhancement Type: Boundary

### bc_example_end_month_calculate
- Source: runtime_params_behavior_compat_examples
- Statement: end_month_calculate SQL示例：SELECT add_months('2018-02-28',3) → 不设置返回2018-05-28（保持日期），设置返回2018-05-31（取月末）。
- Enhancement Type: GUC Toggle

### bc_example_correct_to_number
- Source: runtime_params_behavior_compat_examples
- Statement: correct_to_number SQL示例：SELECT to_number('34,50','999,99') → 不设置报错invalid data，设置返回3450（与pg11一致）。
- Enhancement Type: Error Precision

### bc_example_unbind_divide_bound
- Source: runtime_params_behavior_compat_examples
- Statement: unbind_divide_bound SQL示例：SELECT (-2147483648)::int4 / (-1)::int4 → 不设置报错integer out of range，设置返回2147483648。
- Enhancement Type: Error Precision

### bc_example_convert_string_digit
- Source: runtime_params_behavior_compat_examples
- Statement: convert_string_digit_to_numeric SQL示例：varchar列存'1.1'与int列join时 → 不设置报错invalid input syntax，设置自动转换匹配。
- Enhancement Type: Error Precision

### bc_example_return_null_string
- Source: runtime_params_behavior_compat_examples
- Statement: return_null_string SQL示例：SELECT length(lpad('123',0,'*')) → 不设置返回NULL（长度为空），设置返回0（空字符串长度0）。
- Enhancement Type: Boundary

### bc_example_concat_variadic
- Source: runtime_params_behavior_compat_examples
- Statement: compat_concat_variadic SQL示例：SELECT concat(variadic NULL::int[]) → 不设置返回空，设置返回NULL。控制concat对variadic NULL的处理。
- Enhancement Type: GUC Toggle

### bc_example_hide_tailing_zero
- Source: runtime_params_behavior_compat_examples
- Statement: hide_tailing_zero SQL示例：SELECT cast(123.123 as numeric(15,10)) → 不设置显示123.1230000000，设置显示123.123（隐藏尾零）。to_char结果同样受影响。
- Enhancement Type: GUC Toggle

### bc_example_truncate_numeric
- Source: runtime_params_behavior_compat_examples
- Statement: truncate_numeric_tail_zero SQL示例：SELECT cast(123.123 as numeric(15,10)) → 不设置保留尾零，设置截断尾零。与hide_tailing_zero的区别是truncate实际修改数值而非仅显示。
- Enhancement Type: Boundary

### bc_example_char_coerce
- Source: runtime_params_behavior_compat_examples
- Statement: char_coerce_compat SQL示例：varchar(3)列与char(3)列比较 → 不设置时隐式转换可能丢失尾部空格导致结果不一致，设置时保留空格比较。
- Enhancement Type: GUC Toggle

### bc_example_aformat_null_test
- Source: runtime_params_behavior_compat_examples
- Statement: aformat_null_test SQL示例：SELECT r, r is null FROM (values (NULL::text)) t(r) → 不设置r is null返回t，设置后可能返回不同结果。控制A模式NULL测试行为。
- Enhancement Type: GUC Toggle

### bc_example_current_sysdate
- Source: runtime_params_behavior_compat_examples
- Statement: current_sysdate SQL示例：SELECT sysdate → 不设置返回语句级时间（同事务内不变），设置返回当前系统时间。
- Enhancement Type: GUC Toggle

### bc_example_funcname_argsname
- Source: runtime_params_behavior_compat_examples
- Statement: enable_funcname_with_argsname SQL示例：SELECT power(2,3) → 不设置投影别名显示?column?，设置显示power(2,3)完整函数名。
- Enhancement Type: GUC Toggle

### bc_example_outparam_transfer
- Source: runtime_params_behavior_compat_examples
- Statement: proc_outparam_transfer_length SQL示例：存储过程出参传值 → 不设置可能截断长度，设置后完整传递。
- Enhancement Type: Boundary

### bc_example_case_when_alias
- Source: runtime_params_behavior_compat_examples
- Statement: enable_case_when_alias SQL示例：SELECT CASE WHEN...END → 不设置投影别名显示?column?或case，设置显示CASE WHEN表达式的别名。
- Enhancement Type: GUC Toggle

### bc_example_bpcharlike_compare
- Source: runtime_params_behavior_compat_examples
- Statement: enable_bpcharlikebpchar_compare SQL示例：SELECT bpcharlikebpchar('455'::BPCHAR(10), '455 '::BPCHAR) → 不设置不考虑尾部空格差异，设置后严格比较。
- Enhancement Type: GUC Toggle

### bc_example_show_error_lineno
- Source: runtime_params_behavior_compat_examples
- Statement: show_full_error_lineno SQL示例：编译错误 → 不设置显示部分行号，设置显示完整行号信息。需配合plsql_compile_check_options使用。
- Enhancement Type: Error Precision

### bc_example_crosstype_int
- Source: runtime_params_behavior_compat_examples
- Statement: enable_crosstype_integer_operator SQL示例：int1类型列的索引 → 不设置跨类型整数操作不走索引，设置后支持。
- Enhancement Type: GUC Toggle

### bc_example_ora_timestamptz
- Source: runtime_params_behavior_compat_examples
- Statement: enable_use_ora_timestamptz SQL示例：SELECT timestamp '2024-03-20 01:30:00' at time zone 'Europe/...' → 不设置和设置返回不同的时区处理结果。
- Enhancement Type: GUC Toggle

### bc_example_sys_func_no_brackets
- Source: runtime_params_behavior_compat_examples
- Statement: sys_function_without_brackets SQL示例：SELECT systimestamp → 不设置需括号systimestamp()，设置后支持无括号调用。
- Enhancement Type: GUC Toggle

### bc_example_plsql_rollback_user
- Source: runtime_params_behavior_compat_examples
- Statement: plsql_rollback_keep_user SQL示例：存储过程rollback → 不设置回滚后用户上下文可能丢失，设置后保留。需创建两个用户并grant测试。
- Enhancement Type: GUC Toggle

### bc_example_func_proc_replace
- Source: runtime_params_behavior_compat_examples
- Statement: allow_function_procedure_replace SQL示例：create or replace procedure → 不设置可能不允许函数和过程互相替换，设置后允许。
- Enhancement Type: GUC Toggle

### bc_example_uncheck_default
- Source: runtime_params_behavior_compat_examples
- Statement: proc_uncheck_default_param SQL示例：function test(f1 int, f2 int default 20, f3 int, f4 int default 40) → 不设置报错默认参数后有非默认参数，设置后允许。
- Enhancement Type: Error Precision

### bc_example_time_constexpr
- Source: runtime_params_behavior_compat_examples
- Statement: time_constexpr_compact SQL示例：SELECT timestamp '1999-03-15 8:00:00 -8:00:00' → 不设置和设置返回不同的时区解析结果。
- Enhancement Type: GUC Toggle

### guc_b_enable_set_variables
- Source: runtime_params_compatibility
- Statement: enable_set_variables不设置时不支持set自定义变量和set[global|session]语法；设置后支持如set @v1=1。
- Enhancement Type: GUC Toggle

### guc_b_enable_modify_column
- Source: runtime_params_compatibility
- Statement: enable_modify_column不设置时ALTER TABLE MODIFY仅修改列类型；设置时修改整列定义。
- Enhancement Type: GUC Toggle

### guc_m_enable_escape_string
- Source: runtime_params_compatibility
- Statement: enable_escape_string设置后默认支持除\0外所有MySQL转义符，gsql回显行为与MySQL客户端一致。
- Enhancement Type: GUC Toggle

### guc_m_enable_conflict_funcs
- Source: runtime_params_compatibility
- Statement: enable_conflict_funcs设置且m_format_dev_version>=s2时ceil/format/instr/position/row_number/rank/dense_rank为M实现；regexp_*函数报错。
- Enhancement Type: Error Precision

### guc_m_select_column_name
- Source: runtime_params_compatibility
- Statement: select_column_name设置后SELECT列名回显为函数/表达式输入而非系统函数名或?column?。列名超63字符截断。
- Enhancement Type: Boundary

### guc_m_disable_zero_chars
- Source: runtime_params_compatibility
- Statement: disable_zero_chars_conversion设置时服务端禁止\0字符转空格，与MySQL一致；不设置时\0替换为空格。
- Enhancement Type: GUC Toggle

### guc_m_grant_database_nomapping
- Source: runtime_params_compatibility
- Statement: grant_database_nomapping设置时GRANT不将DATABASE映射为SCHEMA。
- Enhancement Type: GUC Toggle

### guc_m_enable_update_tuple_count
- Source: runtime_params_compatibility
- Statement: enable_update_tuple_count设置时UPDATE数量统计去重。
- Enhancement Type: GUC Toggle

### dbe_lob_usage_pattern
- Source: stored_proc_dbe_lob_complete
- Statement: DBE_LOB标准流程：1.CREATE_TEMPORARY创建临时LOB或使用表列LOB → 2.LOB_WRITE/LOB_WRITE_APPEND写入 → 3.LOB_READ/LOB_SUBSTR读取 → 4.LOB_GET_LENGTH获取长度 → 5.FREETEMPORARY释放临时LOB。BFILE流程：BFILENAME构造 → BFILEOPEN打开 → LOB_READ读取 
- Enhancement Type: Boundary

### dbe_match_null_behavior
- Source: stored_proc_dbe_match
- Statement: EDIT_DISTANCE_SIMILARITY任一参数为NULL时返回0，不报错。
- Enhancement Type: Error Precision

### dbe_sql_usage_pattern
- Source: stored_proc_dbe_sql_complete
- Statement: DBE_SQL标准使用流程：1.REGISTER_CONTEXT打开游标 → 2.SQL_SET_SQL设置SQL → 3.SQL_BIND_VARIABLE绑定变量(可选) → 4.SET_RESULT_TYPE定义列 → 5.SQL_RUN执行 → 6.NEXT_ROW逐行读取 → 7.GET_RESULT获取列值 → 8.SQL_UNREGISTER_CONTEXT关闭游标。
- Enhancement Type: GUC Toggle

### dbe_utility_usage_pattern
- Source: stored_proc_dbe_utility_complete
- Statement: DBE_UTILITY核心用途：1.异常调试——FORMAT_ERROR_BACKTRACE/STACK/CALL_STACK获取异常信息 2.性能测量——GET_TIME/GET_CPU_TIME做差计算耗时 3.名称规范化——CANONICALIZE/COMMA_TO_TABLE 4.动态DDL——EXEC_DDL_STATEMENT 5.哈希计算——GET_HASH_VALUE/GET_SQ
- Enhancement Type: Error Precision

### sp_where_current_of_missing_row_mode_diff
- Source: stored_procedure_cursor
- Statement: cursor指向行已不存在时：A兼容模式UPDATE报错（DELETE不报错）；其他兼容模式不报错。
- Enhancement Type: Error Precision

### tool_gs_guc_reload
- Source: tool_reference_admin
- Statement: gs_guc reload重新加载配置文件使参数生效，无需重启数据库。
- Enhancement Type: GUC Toggle