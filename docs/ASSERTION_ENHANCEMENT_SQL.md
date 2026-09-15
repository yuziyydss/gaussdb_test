# Facts→Assertion 增强 SQL 清单

> 强模型生成，弱模型执行。每个增强用例对应一条兼容性fact。
> 连库后逐条跑，比对实际结果。

## 1. Boundary Tests（边界测试）

### 1.1 LPAD/RPAD 最大长度
**Fact**: GaussDB默认最大1048576，MySQL默认1398101
```sql
-- 边界值测试
SELECT LENGTH(LPAD('a', 1048576, 'b')) AS at_max;     -- 预期: 1048576
SELECT LENGTH(LPAD('a', 1048577, 'b')) AS over_max;    -- 预期: 截断到1048576（非报错）
```

### 1.2 INT溢出（B模式）
**Fact**: GaussDB不提升类型，超范围报错；MySQL提升到BIGINT
```sql
-- 边界值测试
SELECT 2147483647 + 1;  -- 预期: GaussDB报int4 overflow；MySQL返回2147483648
SELECT 2147483647::int4 + 1;  -- 预期: GaussDB报错

-- 正确的B模式写法
SELECT 2147483647::int8 + 1;  -- 成功，返回2147483648
```

### 1.3 INT(M)显示宽度（B模式）
**Fact**: GaussDB仅语法支持，不生效
```sql
CREATE TABLE b_test_width (a INT(3), b INT);
INSERT INTO b_test_width VALUES (12345, 12345);
SELECT a, b FROM b_width; -- 两列都显示完整12345，宽度不影响显示
```

### 1.4 前缀索引长度
**Fact**: GaussDB前缀最长2676字节
```sql
CREATE TABLE b_test_prefix (a VARCHAR(3000));
CREATE INDEX idx ON b_test_prefix(a(2676); -- 预期: 2676成功
CREATE INDEX idx2 ON b_test_prefix(a(2677); -- 预期: 报错或截断
```

### 1.5 NUMERIC精度截断
**Fact**: DATETIME/TIME/TIMESTAMP精度超6位时截断，MySQL报错
```sql
SELECT CAST('2024-01-15 10:30:00.123456789' AS TIMESTAMP);
-- 预期: GaussDB截断到.123456，MySQL报错
```

### 1.6 列长度限制
**Fact**: M模式CHARACTER/VARCHAR长度1~10485760，Oracle 1~32767
```sql
-- M模式长字符串
SELECT LENGTH(RPAD('x', 10485760, 'x')); -- 预期: 10485760
```

### 1.7 GROUP_CONCAT最大长度
**Fact**: GaussDB group_concat_max_len最大1073741823
```sql
SHOW group_concat_max_len;
SET group_concat_max_len = 1073741823;
```

## 2. Error Precision Tests（错误精确化）

### 2.1 IF()隐式转换错误
**Fact**: MySQL忽略错误，GaussDB报错
```sql
-- 预期: GaussDB报类型转换错误
SELECT IF(TRUE, 1, CAST('abc' AS INT));
```

### 2.2 REPLACE NULL第三参数
**Fact**: GaussDB返回NULL，MySQL返回第一参数
```sql
SELECT REPLACE('1.23', '1', NULL);
-- 预期: GaussDB返回NULL，MySQL返回'1.23'
```

### 2.3 ROUND(NULL, 'q')
**Fact**: Oracle返回null，GaussDB报错
```sql
SELECT ROUND(NULL, 'q');
-- 预期: GaussDB报invalid input syntax for integer: "q"
```

### 2.4 CHAR()转码失败
**Fact**: GaussDB报错，MySQL返回NULL+WARNING
```sql
SELECT CHAR(255 USING utf8);
-- 预期: GaussDB报错（MySQL返回NULL）

SELECT CHAR(65, 66, 67); -- 预期: 'ABC'成功
SELECT CHAR(256); -- GaussDB在\x00处截断，MySQL返回不可见字符
```

### 2.5 CAST嵌套日期
**Fact**: CAST(least(0.234) AS date) GaussDB返回WARNING+空值，MySQL返回0000-00-00
```sql
SELECT CAST(LEAST(1.23, 1.23, 0.234) AS DATE);
-- 预期: GaussDB WARNING + 空值

### 2.6 负数转换
**Fact**: GaussDB宽松模式结果0，严格模式报错
```sql
SET sql_mode = '';
SELECT (-1)::uint4;  -- 预期: GaussDB返回0

SET sql_mode = 'STRICT_TRANS_TABLES';
SELECT (-1)::uint4;  -- 预期: GaussDB报错（MySQL返回4294967295）
```

## 3. GUC Toggle Tests（GUC前后对比）

### 3.1 display_leading_zero
```sql
SET behavior_compat_options = '';
SELECT LENGTH(0.123); -- 预期: 4 (.123)

SET behavior_compat_options = 'display_leading_zero';
SELECT LENGTH(0.123); -- 预期: 5 (0.123)
```

### 3.2 end_month_calculate
```sql
SET behavior_compat_options = '';
SELECT ADD_MONTHS('2018-02-28', 3); -- 预期: 2018-05-28

SET behavior_compat_options = 'end_month_calculate';
SELECT ADD_MONTHS('2018-02-28', 3); -- 预期: 2018-05-31
```

### 3.3 correct_to_number
```sql
SET behavior_compat_options = '';
SELECT TO_NUMBER('34,50', '999,99'); -- 预期: ERROR

SET behavior_compat_options = 'correct_to_number';
SELECT TO_NUMBER('34,50', '999,99'); -- 预期: 3450
```

### 3.4 return_null_string
```sql
SET behavior_compat_options = '';
SELECT LENGTH(LPAD('123', 0, '*')); -- 预期: NULL

SET behavior_compat_options = 'return_null_string';
SELECT LENGTH(LPAD('123', 0, '*')); -- 预期: 0
```

### 3.5 hide_tailing_zero
```sql
SET behavior_compat_options = 'hide_tailing_zero';
SELECT CAST(123.123 AS NUMERIC(15,10)); -- 预期: 123.123
```

### 3.6 current_sysdate
```sql
SET behavior_compat_options = 'current_sysdate';
SELECT SYSDATE; -- 预期: 返回当前系统时间（非语句级）
```

## 4. Mode-Specific Tests（模式特定）

### 4.1 M模式BOOL输出
```sql
-- M模式
SELECT TRUE; -- 预期: t
SELECT FALSE; -- 预期: f
SELECT 1=1; -- 预期: t
SELECT 1=2; -- 颐期: f
```

### 4.2 M模式NULL排序
```sql
-- 预期: GaussDB NULL排最后
SELECT id FROM t_test ORDER BY id; -- NULL行在最后

-- NULLS FIRST可调整
SELECT id FROM t_test ORDER BY id NULLS FIRST; -- NULL行在最前
```

### 4.3 M模式COMMENT运算符
```sql
-- 不含forbid_none_space_comment时
SELECT --1; -- 预期: 1（--是注释）
SELECT - -1; -- 预期: 1（两个负号=正号）

-- 含forbid_none_space_comment时
SET behavior_compat_options = 'forbid_none_space_comment';
SELECT --1; -- 预期: 1（--是两次取负）
```

### 4.4 M模式XOR
```sql
-- M模式/GaussDB: ^是指数运算
SELECT 2 ^ 3; -- 预期: 8（指数）
SELECT 2 # 3; -- 预期: 1（异或用#）
```

### 4.5 M模式TIME精度
```sql
-- GaussDB只支持[0,6]
SELECT CURRENT_TIME(6); -- 成功
SELECT CURRENT_TIME(7); -- 报错
```

## 5. 权限测试增强

### 5.1 DESCRIBE权限
```sql
-- GaussDB需要Schema USAGE + 表/列权限
-- MySQL只需表/列权限
```

### 5.2 GRANT/REVOKE MySQL特有选项
```sql
-- 不支持: user@host, IDENTIFIED WITH auth_plugin, REQUIRE SSL, resource_option
-- 支持: 标准GRANT语法
GRANT SELECT ON v_test.t1 TO PUBLIC;
REVOKE SELECT ON v_test.t1 FROM PUBLIC;
```

## 6. 存储过程增强

### 6.1 DBE_OUTPUT
```sql
-- PUT_LINE先缓冲，匿名块结束时输出
BEGIN DBE_OUTPUT.PUT_LINE('buffered'); END;
-- PRINT_LINE直接输出
BEGIN DBE_OUTPUT.PRINT_LINE('direct'); END;
```

### 6.2 DBE_SQL生命周期
```sql
DECLARE
  ctx_id INT;
BEGIN
  ctx_id := DBE_SQL.REGISTER_CONTEXT();
  DBE_SQL.SQL_SET_SQL(ctx_id, 'SELECT 1', 2);
  DBE_SQL.SQL_RUN(ctx_id);
  DBE_SQL.SQL_UNREGISTER_CONTEXT(ctx_id);
END;
```
