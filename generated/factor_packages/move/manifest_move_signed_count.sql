-- generated_from: manifest_move_signed_count
-- static_only: true
-- case_count: 18

-- case_id: manifest_move_signed_count_c127ad6beb57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_absent", "count": "move_count_neg2", "cursor": "move_cursor_auto", "direction": "move_direction_absolute"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE ABSOLUTE -2 c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_fe93698f8e34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_from", "count": "move_count_neg1", "cursor": "move_cursor_auto", "direction": "move_direction_relative"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE RELATIVE -1 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_f8a27378110c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_in", "count": "move_count_n0", "cursor": "move_cursor_auto", "direction": "move_direction_backward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE BACKWARD 0 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_f9e8b5c01b0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_from", "count": "move_count_n1", "cursor": "move_cursor_auto", "direction": "move_direction_absolute"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE ABSOLUTE 1 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_2ec624ba9289
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_in", "count": "move_count_n3", "cursor": "move_cursor_auto", "direction": "move_direction_absolute"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE ABSOLUTE 3 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_0281aba15233
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_absent", "count": "move_count_n21", "cursor": "move_cursor_auto", "direction": "move_direction_relative"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE RELATIVE 21 c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_65136490a94e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_in", "count": "move_count_neg2", "cursor": "move_cursor_auto", "direction": "move_direction_relative"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE RELATIVE -2 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_1ea49b827d66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_from", "count": "move_count_neg2", "cursor": "move_cursor_auto", "direction": "move_direction_backward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE BACKWARD -2 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_fe19a1ee2c48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_absent", "count": "move_count_neg1", "cursor": "move_cursor_auto", "direction": "move_direction_backward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE BACKWARD -1 c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_9f42fb866b88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_in", "count": "move_count_neg1", "cursor": "move_cursor_auto", "direction": "move_direction_absolute"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE ABSOLUTE -1 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_715fad509003
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_absent", "count": "move_count_n0", "cursor": "move_cursor_auto", "direction": "move_direction_absolute"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE ABSOLUTE 0 c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_1691cc483c24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_from", "count": "move_count_n21", "cursor": "move_cursor_auto", "direction": "move_direction_absolute"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE ABSOLUTE 21 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_f21ee42adba7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_from", "count": "move_count_n0", "cursor": "move_cursor_auto", "direction": "move_direction_relative"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE RELATIVE 0 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_4f758b0f878d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_absent", "count": "move_count_n1", "cursor": "move_cursor_auto", "direction": "move_direction_relative"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE RELATIVE 1 c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_29c51b4b685b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_absent", "count": "move_count_n3", "cursor": "move_cursor_auto", "direction": "move_direction_relative"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE RELATIVE 3 c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_c42214d4b844
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_in", "count": "move_count_n1", "cursor": "move_cursor_auto", "direction": "move_direction_backward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE BACKWARD 1 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_2eef74a03ae6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_from", "count": "move_count_n3", "cursor": "move_cursor_auto", "direction": "move_direction_backward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE BACKWARD 3 FROM c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_move_signed_count_58898b978102
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connector": "move_connector_in", "count": "move_count_n21", "cursor": "move_cursor_auto", "direction": "move_direction_backward_count"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["declare::declare_fact_scroll_plan"], "key": "cursor_reverse_supported"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
DECLARE c_cursor_auto CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- test_sql:
MOVE BACKWARD 21 IN c_cursor_auto;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
