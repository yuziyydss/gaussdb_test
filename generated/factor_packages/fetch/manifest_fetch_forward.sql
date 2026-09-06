-- generated_from: manifest_fetch_forward
-- static_only: true
-- case_count: 8

-- case_id: manifest_fetch_forward_c26313f7ba6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_next"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH NEXT FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_89efae33590a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n1", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_all"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH ALL IN c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_0f0fd92dde2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n1", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_forward"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD FROM c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_cdd8c83618c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_forward_all"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD ALL IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_9d0592eb719d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n1", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_next"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH NEXT IN c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_ec9c7463f627
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_all"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH ALL FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_80b19762c108
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_n1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_forward"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_forward_551ce997576c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_n1", "cursor": "fetch_cursor_no_scroll", "direction": "fetch_direction_forward_all"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_no_scroll NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD ALL FROM c_cursor_no_scroll;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
