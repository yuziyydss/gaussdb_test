-- ============================================================
-- GaussDB 规格驱动SQL测试生成系统 — 最小验证脚本
-- 
-- 用途: 验证生成链路的正确性
-- 前提: M-Compatibility 模式数据库连接
-- 用法: gsql -d <dbname> -p <port> -f minimal_validation_script.sql
-- ============================================================

-- 0. 环境检查
SELECT '=== 环境检查 ===' AS step;
SELECT version() AS gaussdb_version;
SHOW sql_compatibility;
SHOW behavior_compat_options;
SHOW m_format_behavior_compat_options;

-- 1. 创建独立测试schema
DROP SCHEMA IF EXISTS test_validation CASCADE;
CREATE SCHEMA test_validation;
SET current_schema = test_validation;

-- ============================================================
-- 测试1: CREATE TABLE 基础语法
-- 预期: 成功
-- ============================================================
SELECT '=== 测试1: CREATE TABLE ===' AS step;
CREATE TABLE t1_basic (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 预期: CREATE TABLE / NOTICE: PRIMARY KEY will create implicit index

-- ============================================================
-- 测试2: INSERT VALUES
-- 预期: INSERT 0 3
-- ============================================================
SELECT '=== 测试2: INSERT VALUES ===' AS step;
INSERT INTO t1_basic (id, name) VALUES (1, 'alice'), (2, 'bob'), (3, 'charlie');
-- 预期: INSERT 0 3

-- ============================================================
-- 测试3: SELECT 基础查询
-- 预期: 3行
-- ============================================================
SELECT '=== 测试3: SELECT ===' AS step;
SELECT id, name FROM t1_basic ORDER BY id;
-- 预期: (1, alice), (2, bob), (3, charlie)

-- ============================================================
-- 测试4: UPDATE
-- 预期: UPDATE 1
-- ============================================================
SELECT '=== 测试4: UPDATE ===' AS step;
UPDATE t1_basic SET name = 'alice_updated' WHERE id = 1;
-- 预期: UPDATE 1
SELECT name FROM t1_basic WHERE id = 1;
-- 预期: alice_updated

-- ============================================================
-- 测试5: DELETE
-- 预期: DELETE 1
-- ============================================================
SELECT '=== 测试5: DELETE ===' AS step;
DELETE FROM t1_basic WHERE id = 3;
-- 预期: DELETE 1
SELECT COUNT(*) FROM t1_basic;
-- 预期: 2

-- ============================================================
-- 测试6: CREATE INDEX
-- 预期: CREATE INDEX
-- ============================================================
SELECT '=== 测试6: CREATE INDEX ===' AS step;
CREATE INDEX idx_t1_name ON t1_basic(name);
-- 预期: CREATE INDEX

-- ============================================================
-- 测试7: GRANT / REVOKE
-- 预期: GRANT / REVOKE
-- ============================================================
SELECT '=== 测试7: GRANT ===' AS step;
GRANT SELECT ON t1_basic TO PUBLIC;
-- 预期: GRANT
REVOKE SELECT ON t1_basic FROM PUBLIC;
-- 预期: REVOKE

-- ============================================================
-- 测试8: BEGIN / COMMIT 事务控制
-- 预期: COMMIT
-- ============================================================
SELECT '=== 测试8: 事务 ===' AS step;
BEGIN;
INSERT INTO t1_basic (id, name) VALUES (4, 'dave');
COMMIT;
-- 预期: BEGIN / INSERT 0 1 / COMMIT
SELECT COUNT(*) FROM t1_basic;
-- 预期: 3

-- ============================================================
-- 测试9: behavior_compat_options 差异验证
-- display_leading_zero
-- ============================================================
SELECT '=== 测试9: display_leading_zero ===' AS step;

-- 保存当前设置
CREATE TEMP TABLE saved_guc AS SELECT current_setting('behavior_compat_options') AS saved;

-- 不设置: 0.123显示为.123
SET behavior_compat_options = '';
SELECT 0.123 AS without_leading_zero, LENGTH(0.123) AS len_without;
-- 预期: .123, 4

-- 设置后: 0.123显示为0.123
SET behavior_compat_options = 'display_leading_zero';
SELECT 0.123 AS with_leading_zero, LENGTH(0.123) AS len_with;
-- 预期: 0.123, 5

-- 恢复
SET behavior_compat_options = (SELECT saved FROM saved_guc);

-- ============================================================
-- 测试10: behavior_compat_options 差异验证
-- end_month_calculate
-- ============================================================
SELECT '=== 测试10: end_month_calculate ===' AS step;

-- 不设置: 2月28日+3月=5月28日
SET behavior_compat_options = '';
SELECT ADD_MONTHS('2018-02-28', 3) AS without_end_month;
-- 预期: 2018-05-28 00:00:00

-- 设置后: 2月28日+3月=5月31日（取月末）
SET behavior_compat_options = 'end_month_calculate';
SELECT ADD_MONTHS('2018-02-28', 3) AS with_end_month;
-- 预期: 2018-05-31 00:00:00

-- 恢复
SET behavior_compat_options = (SELECT saved FROM saved_guc);

-- ============================================================
-- 清理
-- ============================================================
SELECT '=== 清理 ===' AS step;
DROP SCHEMA test_validation CASCADE;
-- 预期: DROP SCHEMA

SELECT '=== 验证完成 ===' AS result;
