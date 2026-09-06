-- generated_from: manifest_fetch_negative_forward_count
-- static_only: true
-- case_count: 5

-- case_id: manifest_fetch_negative_forward_count_d997cf62e0de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_neg2", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH -2 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_negative_forward_count_e55871f7e2e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_neg1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_forward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD -1 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_negative_forward_count_1fc8ac6c826a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_in", "count": "fetch_count_neg2", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH -2 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_negative_forward_count_1dcb787a48d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_neg1", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH -1 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_fetch_negative_forward_count_d52362c38b26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "fetch_connector_from", "count": "fetch_count_neg2", "cursor": "fetch_cursor_auto", "direction": "fetch_direction_forward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
FETCH FORWARD -2 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
