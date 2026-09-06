-- generated_from: manifest_close_named
-- static_only: true
-- case_count: 2

-- case_id: manifest_close_named_d47fc3e2bb30
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "close_target_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
DECLARE c_cursor_second CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
CLOSE c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_close_named_8935145cb690
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "close_target_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
DECLARE c_cursor_second CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
CLOSE c_cursor_second;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
