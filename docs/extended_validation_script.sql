-- ============================================================
-- GaussDB 规格驱动SQL测试生成系统 — 扩展验证脚本（100条）
-- 
-- 覆盖: DDL/DML/DCL/数据类型/操作符/系统函数/GUC差异
-- 前提: M-Compatibility 模式数据库连接
-- 用法: gsql -d <dbname> -p <port> -f extended_validation_script.sql
-- ============================================================

DROP SCHEMA IF EXISTS test_extended CASCADE;
CREATE SCHEMA test_extended;
SET current_schema = test_extended;

-- ============================================================
-- 第一组: DDL基础（测试11-25）
-- ============================================================

-- 测试11: CREATE TABLE各数据类型
CREATE TABLE t_types (
    c_int INT, c_bigint BIGINT, c_small SMALLINT,
    c_dec DECIMAL(10,2), c_num NUMERIC(15,5),
    c_float FLOAT, c_double DOUBLE PRECISION,
    c_char CHAR(10), c_varchar VARCHAR(100), c_text TEXT,
    c_date DATE, c_ts TIMESTAMP, c_time TIME
);
INSERT INTO t_types VALUES (1, 9223372036854775807, 32767,
    12345.67, 123.45678, 1.23, 4.56,
    'hello', 'world', 'long text here',
    '2024-01-15', '2024-01-15 10:30:00', '14:30:00');

-- 测试12: CREATE TABLE IF NOT EXISTS
CREATE TABLE IF NOT EXISTS t_types (id INT); -- 应无错误

-- 测试13: AUTO_INCREMENT
CREATE TABLE t_auto (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
INSERT INTO t_auto (name) VALUES ('a'), ('b'), ('c');
SELECT id FROM t_auto ORDER BY id; -- 预期: 1,2,3

-- 测试14: UNIQUE约束
CREATE TABLE t_unique (email VARCHAR(100) UNIQUE);
INSERT INTO t_unique VALUES ('a@test.com');
INSERT INTO t_unique VALUES ('a@test.com'); -- 预期: 错误duplicate key

-- 测试15: CHECK约束
CREATE TABLE t_check (age INT CHECK (age >= 0 AND age <= 150));
INSERT INTO t_check VALUES (200); -- 预期: 错误check violation

-- 测试16: FOREIGN KEY
CREATE TABLE t_parent (id INT PRIMARY KEY);
CREATE TABLE t_child (pid INT REFERENCES t_parent(id));
INSERT INTO t_child VALUES (999); -- 预期: 错误foreign key violation
INSERT INTO t_parent VALUES (1);
INSERT INTO t_child VALUES (1); -- 预期: 成功

-- 测试17: DEFAULT值
CREATE TABLE t_default (name VARCHAR(50) DEFAULT 'unknown', ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO t_default (name) VALUES ('explicit');
INSERT INTO t_default DEFAULT VALUES; -- 或省略所有列
SELECT name FROM t_default ORDER BY name;

-- 测试18: ALTER TABLE ADD COLUMN
ALTER TABLE t_types ADD COLUMN new_col INT DEFAULT 0;

-- 测试19: ALTER TABLE MODIFY/CHANGE
ALTER TABLE t_types ALTER COLUMN c_varchar TYPE VARCHAR(200);

-- 测试20: DROP COLUMN
ALTER TABLE t_types DROP COLUMN new_col;

-- 测试21: RENAME TABLE
ALTER TABLE t_auto RENAME TO t_auto_renamed;

-- 测试22: TRUNCATE
TRUNCATE t_auto_renamed;

-- 测试23: CREATE INDEX variants
CREATE INDEX idx_char ON t_types(c_char);
CREATE INDEX idx_composite ON t_types(c_int, c_char);

-- 测试24: CREATE VIEW
CREATE VIEW v_types AS SELECT c_int, c_char FROM t_types;

-- 测试25: CREATE SEQUENCE
CREATE SEQUENCE seq_test START 100 INCREMENT 10;
SELECT nextval('seq_test'); -- 预期: 100

-- ============================================================
-- 第二组: 数据类型行为差异（测试26-40）
-- ============================================================

-- 测试26: BOOL输出格式（GaussDB: t/f, MySQL: 1/0）
SELECT TRUE AS bool_true, FALSE AS bool_false;
-- 预期GaussDB: t, f

-- 测试27: 整数UNION CTAS列长度差异
DROP TABLE IF EXISTS t_union;
CREATE TABLE t_union AS SELECT 1234567 UNION ALL SELECT '456789';
-- GaussDB列类型: varchar(11), MySQL: varchar(7)
SELECT column_name, data_type FROM information_schema.columns 
WHERE table_name = 't_union';

-- 测试28: 字符串长度
SELECT LENGTH('hello') AS len_ascii, CHAR_LENGTH('你好') AS len_unicode;
-- 预期: 5, 2

-- 测试29: 数值精度
SELECT CAST(123.456789 AS NUMERIC(10,4)) AS num_precision;
-- 预期: 123.4568

-- 测试30: NULL显示差异
SELECT NULL AS null_display;
-- GaussDB: 空值, MySQL: 'NULL'文本

-- 测试31: 比较操作符返回格式
SELECT 1 = 1 AS eq_true, 1 = 2 AS eq_false;
-- GaussDB: t, f; MySQL: 1, 0

-- 测试32: NULL比较差异
SELECT NULL = NULL AS null_eq; -- 预期: NULL
SELECT NULL IS NULL AS null_is; -- 预期: t
SELECT NULL <=> NULL AS null_safe; -- 预期: t (M模式)

-- 测试33: TIME精度
SELECT CURRENT_TIME(6); -- GaussDB支持[0,6], MySQL可到9
-- SELECT CURRENT_TIME(7); -- 预期: GaussDB报错

-- 测试34: TIMESTAMP精度
SELECT CAST('2024-01-15 10:30:00.123456789' AS TIMESTAMP);
-- GaussDB截断到微秒(6位), Oracle支持9位

-- 测试35: BINARY填充差异
SELECT LENGTH(BINARY(10)) AS binary_length;
-- GaussDB填充0x20, MySQL填充0x00

-- 测试36: TEXT/BLOB二进制输入
SELECT HEX(0x61) AS hex_output;
-- GaussDB: 十六进制61000000(含填充), MySQL: 61

-- 测试37: 字符串截断行为
SELECT TRIM('  hello  ') AS trimmed;
SELECT LPAD('ab', 10, 'x') AS lpad_result;
SELECT RPAD('ab', 10, 'y') AS rpad_result;

-- 测试38: 日期格式
SELECT DATE_FORMAT('2024-01-15', '%Y/%m/%d') AS date_fmt;
SELECT EXTRACT(YEAR FROM '2024-01-15') AS extract_year;

-- 测试39: 数值溢出
SELECT 2147483647 + 1; -- INT溢出: GaussDB可能报错, MySQL提升类型

-- 测试40: 除零
SELECT 1 / 0; -- 预期: 错误或NULL取决于模式

-- ============================================================
-- 第三组: 系统函数差异（测试41-60）
-- ============================================================

-- 测试41: GROUP_CONCAT
CREATE TABLE t_group (grp INT, val VARCHAR(10));
INSERT INTO t_group VALUES (1,'a'),(1,'b'),(2,'c'),(2,'d');
SELECT grp, GROUP_CONCAT(val ORDER BY val) AS concat_val FROM t_group GROUP BY grp;
-- 预期: (1,'a,b'), (2,'c,d')

-- 测试42: GROUP_CONCAT ORDER BY数字
SELECT GROUP_CONCAT(val ORDER BY 1) FROM t_group;
-- GaussDB: 数字是常量不排序; MySQL: 按第一列排序

-- 测试43: REPLACE NULL第三参数
SELECT REPLACE('1.23', '1', NULL);
-- GaussDB: NULL; MySQL: '1.23'

-- 测试44: NULLIF嵌套GROUP_CONCAT精度
SELECT NULLIF(GROUP_CONCAT(1/7), 1/7);
-- GaussDB/MySQL8: 0.1429; MySQL5.7: NULL

-- 测试45: COALESCE类型推导
SELECT COALESCE(1, 'text');
-- 类型不一致时GaussDB可能报错或返回TEXT

-- 测试46: IF()隐式转换
SELECT IF(TRUE, 1, 'invalid_number');
-- GaussDB: 可能报错; MySQL: 返回1

-- 测试47: 聚合函数variance/stddev
SELECT VARIANCE(val) FROM (VALUES (1),(2),(3),(4)) AS t(val);
-- GaussDB: 样本方差; MySQL: 总体方差

-- 测试48: CAST浮点精度
CREATE TABLE t_float (f FLOAT);
INSERT INTO t_float VALUES (1.23);
SELECT f, CAST(f AS CHAR) FROM t_float;
-- GaussDB: 准确值1.23; MySQL5.7: 失真值1.2300000190734863

-- 测试49: JSON函数
SELECT JSON_EXTRACT('{"a": 1, "b": 2}', '$.a') AS json_a;
-- 预期: 1

-- 测试50: JSON_UNQUOTE转义
SELECT JSON_UNQUOTE('"hello"');
-- 预期: hello

-- 测试51: 日期函数差异
SELECT ADD_MONTHS('2018-02-28', 3) AS add_months_result;
-- 不设end_month_calculate: 2018-05-28; 设置: 2018-05-31

-- 测试52: ROUND精度
SELECT ROUND(123.456, 2);
SELECT ROUND(NULL, 'q'); -- GaussDB: 报错; Oracle: NULL

-- 测试53: MOD返回类型
SELECT MOD(10, 3);
-- GaussDB返回int; Oracle返回NUMBER

-- 测试54: 字符函数
SELECT UPPER('hello'), LOWER('WORLD'), INITCAP('hello world');
SELECT SUBSTR('hello world', 1, 5); -- hello
SELECT INSTR('hello world', 'world'); -- 7

-- 测试55: 正则表达式
SELECT '12345' REGEXP '[0-9]+' AS regex_match;
-- GaussDB支持\d\w\s元字符, MySQL不支持

-- 测试56: EXTRACT DAY_MICROSECOND
SELECT EXTRACT(DAY_MICROSECOND FROM '2023-01-27 10:11:12.400000');
-- GaussDB常量和表数据都返回DAY部分

-- 测试57: DESCRIBE
DESCRIBE t_types;

-- 测试58: SHOW
SHOW TABLES;
SHOW COLUMNS FROM t_types;

-- 测试59: 用户变量
SET @my_var = 'hello';
SELECT @my_var;
-- SET @a := @b := 1; -- GaussDB不支持连续赋值

-- 测试60: 系统参数设置
SET sql_mode = '';
SET sql_mode = 'STRICT_TRANS_TABLES';

-- ============================================================
-- 第四组: GUC差异验证（测试61-75）
-- ============================================================

-- 测试61: correct_to_number
SET behavior_compat_options = '';
-- SELECT TO_NUMBER('34,50', '999,99'); -- 预期: 报错
SET behavior_compat_options = 'correct_to_number';
SELECT TO_NUMBER('34,50', '999,99') AS to_num;
-- 预期: 3450
SET behavior_compat_options = '';

-- 测试62: return_null_string
SET behavior_compat_options = '';
SELECT LENGTH(LPAD('123', 0, '*')) AS len_without;
-- 预期: NULL(空)
SET behavior_compat_options = 'return_null_string';
SELECT LENGTH(LPAD('123', 0, '*')) AS len_with;
-- 预期: 0
SET behavior_compat_options = '';

-- 测试63: hide_tailing_zero
SET behavior_compat_options = 'hide_tailing_zero';
SELECT CAST(123.123 AS NUMERIC(15,10)) AS hidden_zero;
-- 预期: 123.123（隐藏尾零）
SET behavior_compat_options = '';

-- 测试64: current_sysdate
SET behavior_compat_options = 'current_sysdate';
SELECT SYSDATE;
-- 预期: 当前系统时间（而非语句级时间）
SET behavior_compat_options = '';

-- 测试65: enable_funcname_with_argsname
SET behavior_compat_options = 'enable_funcname_with_argsname';
SELECT POWER(2,3) AS power_result;
-- 预期: 投影别名显示power(2,3)而非?column?
SET behavior_compat_options = '';

-- 测试66: enable_case_when_alias
SET behavior_compat_options = 'enable_case_when_alias';
SELECT CASE WHEN 1<2 THEN 'yes' ELSE 'no' END AS case_result;
SET behavior_compat_options = '';

-- 测试67: plsql_security_definer
SET behavior_compat_options = 'plsql_security_definer';
SET behavior_compat_options = '';

-- 测试68: bind_schema_tablespace
SET behavior_compat_options = 'bind_schema_tablespace';
SET SEARCH_PATH = test_extended;
SET behavior_compat_options = '';

-- 测试69: bind_procedure_searchpath
SET behavior_compat_options = 'bind_procedure_searchpath';
SET behavior_compat_options = '';

-- 测试70: aformat_null_test
SET behavior_compat_options = 'aformat_null_test';
SELECT NULL IS NULL AS null_test;
SET behavior_compat_options = '';

-- 测试71: enable_use_ora_timestamptz
SET behavior_compat_options = 'enable_use_ora_timestamptz';
SELECT TIMESTAMP '2024-03-20 01:30:00' AT TIME ZONE 'UTC';
SET behavior_compat_options = '';

-- 测试72: sys_function_without_brackets
SET behavior_compat_options = 'sys_function_without_brackets';
-- SELECT SYSTIMESTAMP; -- 无括号调用
SET behavior_compat_options = '';

-- 测试73: array_count_compat
SET behavior_compat_options = 'array_count_compat';
SET behavior_compat_options = '';

-- 测试74: enable_crosstype_integer_operator
SET behavior_compat_options = 'enable_crosstype_integer_operator';
CREATE TABLE t_int1 (c1 INT);
CREATE INDEX idx_int1 ON t_int1(c1);
SET behavior_compat_options = '';

-- 测试75: show_full_error_lineno
SET behavior_compat_options = 'show_full_error_lineno';
SET behavior_compat_options = '';

-- ============================================================
-- 第五组: 存储过程/游标（测试76-85）
-- ============================================================

-- 测试76: 简单存储过程
CREATE OR REPLACE PROCEDURE p_hello() AS
BEGIN
    DBE_OUTPUT.PRINT_LINE('Hello from procedure');
END;
/
CALL p_hello();

-- 测试77: 带参数存储过程
CREATE OR REPLACE PROCEDURE p_add(a IN INT, b IN INT, c OUT INT) AS
BEGIN
    c := a + b;
END;
/
DO $$
DECLARE
    result INT;
BEGIN
    CALL p_add(3, 4, result);
    DBE_OUTPUT.PRINT_LINE('Result: ' || result);
END;
$$;

-- 测试78: IF/ELSIF/ELSE
CREATE OR REPLACE PROCEDURE p_cond(x IN INT) AS
BEGIN
    IF x > 0 THEN
        DBE_OUTPUT.PRINT_LINE('positive');
    ELSIF x < 0 THEN
        DBE_OUTPUT.PRINT_LINE('negative');
    ELSE
        DBE_OUTPUT.PRINT_LINE('zero');
    END IF;
END;
/
CALL p_cond(5);
CALL p_cond(-3);
CALL p_cond(0);

-- 测试79: LOOP/EXIT WHEN
CREATE OR REPLACE PROCEDURE p_loop() AS
    i INT := 0;
BEGIN
    LOOP
        i := i + 1;
        EXIT WHEN i >= 5;
    END LOOP;
    DBE_OUTPUT.PRINT_LINE('Loop count: ' || i);
END;
/

-- 测试80: FOR循环
CREATE OR REPLACE PROCEDURE p_for() AS
BEGIN
    FOR i IN 1..5 LOOP
        DBE_OUTPUT.PRINT_LINE('Iteration: ' || i);
    END LOOP;
END;
/

-- 测试81: SAVEPOINT
BEGIN;
INSERT INTO t_parent VALUES (100);
SAVEPOINT sp1;
INSERT INTO t_parent VALUES (101);
ROLLBACK TO SAVEPOINT sp1;
COMMIT;
SELECT COUNT(*) FROM t_parent WHERE id >= 100;
-- 预期: 1（101被回滚）

-- 测试82: 游标声明和FETCH
CREATE OR REPLACE PROCEDURE p_cursor() AS
    CURSOR c1 IS SELECT id FROM t_parent ORDER BY id;
    v_id INT;
BEGIN
    OPEN c1;
    FETCH c1 INTO v_id;
    DBE_OUTPUT.PRINT_LINE('First id: ' || v_id);
    CLOSE c1;
END;
/

-- 测试83: 异常处理
CREATE OR REPLACE PROCEDURE p_exception() AS
BEGIN
    BEGIN
        RAISE EXCEPTION 'test error';
    EXCEPTION
        WHEN OTHERS THEN
            DBE_OUTPUT.PRINT_LINE('Caught: ' || SQLERRM);
    END;
END;
/
CALL p_exception();

-- 测试84: DBE_SQL动态SQL
CREATE OR REPLACE PROCEDURE p_dynamic() AS
    ctx_id INT;
    row_count INT;
BEGIN
    ctx_id := DBE_SQL.REGISTER_CONTEXT();
    DBE_SQL.SQL_SET_SQL(ctx_id, 'SELECT COUNT(*) FROM t_parent', 2);
    row_count := DBE_SQL.SQL_RUN(ctx_id);
    DBE_SQL.SQL_UNREGISTER_CONTEXT(ctx_id);
    DBE_OUTPUT.PRINT_LINE('Rows: ' || row_count);
END;
/

-- 测试85: DBE_OUTPUT缓冲区管理
CREATE OR REPLACE PROCEDURE p_output() AS
    line VARCHAR(100);
    status INT;
BEGIN
    DBE_OUTPUT.ENABLE(20000);
    DBE_OUTPUT.PUT_LINE('buffered line');
    DBE_OUTPUT.GET_LINE(line, status);
    DBE_OUTPUT.PRINT_LINE('Got: ' || line || ', status: ' || status);
END;
/

-- ============================================================
-- 第六组: 安全/权限（测试86-90）
-- ============================================================

-- 测试86: CREATE USER / DROP USER
-- CREATE USER test_user PASSWORD 'Test@123';
-- GRANT SELECT ON t_types TO test_user;
-- REVOKE SELECT ON t_types FROM test_user;
-- DROP USER test_user;

-- 测试87: 权限检查
SELECT has_table_privilege(CURRENT_USER, 't_types', 'SELECT');

-- 测试88: Schema权限
SELECT has_schema_privilege(CURRENT_USER, 'test_extended', 'USAGE');

-- 测试89: 角色检查
SELECT CURRENT_USER, SESSION_USER;

-- 测试90: 系统权限
-- SELECT has_database_privilege(CURRENT_USER, CURRENT_DATABASE(), 'CREATE');

-- ============================================================
-- 第七组: 高级特性（测试91-100）
-- ============================================================

-- 测试91: CTE (WITH子句)
WITH cte AS (SELECT 1 AS val UNION SELECT 2 UNION SELECT 3)
SELECT SUM(val) FROM cte;
-- 预期: 6

-- 测试92: 窗口函数
SELECT grp, val, ROW_NUMBER() OVER (PARTITION BY grp ORDER BY val) AS rn
FROM t_group ORDER BY grp, val;

-- 测试93: MERGE INTO
CREATE TABLE t_merge_target (id INT PRIMARY KEY, val VARCHAR(10));
CREATE TABLE t_merge_source (id INT, val VARCHAR(10));
INSERT INTO t_merge_target VALUES (1, 'old');
INSERT INTO t_merge_source VALUES (1, 'new'), (2, 'inserted');
MERGE INTO t_merge_target t
USING t_merge_source s ON t.id = s.id
WHEN MATCHED THEN UPDATE SET val = s.val
WHEN NOT MATCHED THEN INSERT VALUES (s.id, s.val);
SELECT * FROM t_merge_target ORDER BY id;

-- 测试94: 分区表
CREATE TABLE t_partition (id INT, name VARCHAR(50))
PARTITION BY RANGE (id) (
    PARTITION p1 VALUES LESS THAN (100),
    PARTITION p2 VALUES LESS THAN (200),
    PARTITION p3 VALUES LESS THAN (MAXVALUE)
);
INSERT INTO t_partition VALUES (50, 'p1'), (150, 'p2'), (250, 'p3');
SELECT COUNT(*) FROM t_partition PARTITION (p1);

-- 测试95: 触发器
CREATE TABLE t_trigger_log (action VARCHAR(50));
CREATE TABLE t_trigger_test (id INT);
CREATE OR REPLACE TRIGGER trig_test
BEFORE INSERT ON t_trigger_test
FOR EACH ROW
BEGIN
    INSERT INTO t_trigger_log VALUES ('inserted');
END;
/
INSERT INTO t_trigger_test VALUES (1);
SELECT * FROM t_trigger_log;

-- 测试96: 数组类型
CREATE TABLE t_array (id INT, arr INT[]);
INSERT INTO t_array VALUES (1, ARRAY[1,2,3]);
SELECT arr[1], arr[2], arr[3] FROM t_array;

-- 测试97: 复合类型/Struct
-- CREATE TYPE addr AS (street VARCHAR(100), city VARCHAR(50));
-- CREATE TABLE t_struct (id INT, a addr);
-- INSERT INTO t_struct VALUES (1, ('Main St', 'Beijing'));

-- 测试98: 递归CTE
WITH RECURSIVE rcte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM rcte WHERE n < 5
)
SELECT SUM(n) FROM rcte;
-- 预期: 15

-- 测试99: 信息Schema查询
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'test_extended' AND table_type = 'BASE TABLE'
ORDER BY table_name LIMIT 5;

-- 测试100: 系统视图查询
SELECT COUNT(*) AS table_count FROM information_schema.tables 
WHERE table_schema = 'test_extended';

-- ============================================================
-- 清理
-- ============================================================
DROP SCHEMA test_extended CASCADE;
SELECT '=== 100条扩展验证完成 ===' AS result;
