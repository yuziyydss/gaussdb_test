-- generated_from: manifest_fetch_forward_count
-- static_only: true
-- case_count: 8

-- case_id: manifest_fetch_forward_count_96b64868a328
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n0", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH 0 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_5b8dbe4381bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n1", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH 1 IN c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_7da79eb7fe59
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n3", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_forward_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD 3 FROM c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_f39e4d68d5a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n21", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_forward_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD 21 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_916baaeb0ad2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n3", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH 3 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_a0ffb87f3d61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n21", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH 21 FROM c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_61d2ba2e990f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n0", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_forward_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD 0 IN c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_count_589cca85b2c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_forward_count"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD 1 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
