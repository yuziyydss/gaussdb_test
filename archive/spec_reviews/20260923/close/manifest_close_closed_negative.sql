-- generated_from: manifest_close_closed_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_close_closed_negative_471f6846734b
-- expected: error
-- expected_error_category: closed_cursor_operation
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"target": "close_target_closed"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_close_closed CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
CLOSE c_close_closed;
-- test_sql:
CLOSE c_close_closed;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
