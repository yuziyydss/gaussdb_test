-- generated_from: manifest_cursor_ordinary
-- static_only: true
-- case_count: 7

-- case_id: manifest_cursor_ordinary_f7c028fc7031
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_text", "hold": "cursor_hold_default", "query": "cursor_query_values", "scroll": "cursor_scroll_auto"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor FOR VALUES (1, 2), (3, 4);
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_cursor_ordinary_efecf31b6a92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_text", "hold": "cursor_hold_with", "query": "cursor_query_select", "scroll": "cursor_scroll_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor NO SCROLL WITH HOLD FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_cursor_ordinary_a782989b72c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_binary", "hold": "cursor_hold_without", "query": "cursor_query_select", "scroll": "cursor_scroll_auto"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor BINARY WITHOUT HOLD FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_cursor_ordinary_0e602b4bae86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_binary", "hold": "cursor_hold_default", "query": "cursor_query_values", "scroll": "cursor_scroll_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor BINARY NO SCROLL FOR VALUES (1, 2), (3, 4);
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_cursor_ordinary_efac54590dc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_text", "hold": "cursor_hold_without", "query": "cursor_query_values", "scroll": "cursor_scroll_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor NO SCROLL WITHOUT HOLD FOR VALUES (1, 2), (3, 4);
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_cursor_ordinary_b4a39840ddc6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_binary", "hold": "cursor_hold_with", "query": "cursor_query_values", "scroll": "cursor_scroll_auto"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor BINARY WITH HOLD FOR VALUES (1, 2), (3, 4);
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_cursor_ordinary_389cb24a126a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "cursor_binary_text", "hold": "cursor_hold_default", "query": "cursor_query_select", "scroll": "cursor_scroll_auto"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["cursor_fact_transaction"], "key": "cursor_transaction_ready"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
CURSOR fp_cursor FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
CLOSE fp_cursor;
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
