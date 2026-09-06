-- generated_from: manifest_declare_cursor
-- static_only: true
-- case_count: 7

-- case_id: manifest_declare_cursor_87e391465c4c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_text", "cursor_name": "declare_cursor_name_one", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_absent", "projection": "declare_projection_two", "query_form": "declare_query_form_select", "scroll": "declare_scroll_auto", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_one CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_declare_cursor_569d6889e4b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_binary", "cursor_name": "declare_cursor_name_two", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_with", "projection": "declare_projection_two", "query_form": "declare_query_form_values", "scroll": "declare_scroll_no", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_two BINARY NO SCROLL CURSOR WITH HOLD FOR VALUES (1, 1), (2, 2);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_declare_cursor_9ba310ad8d12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_text", "cursor_name": "declare_cursor_name_one", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_without", "projection": "declare_projection_two", "query_form": "declare_query_form_values", "scroll": "declare_scroll_no", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_one NO SCROLL CURSOR WITHOUT HOLD FOR VALUES (1, 1), (2, 2);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_declare_cursor_aac7497da28e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_binary", "cursor_name": "declare_cursor_name_two", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_without", "projection": "declare_projection_two", "query_form": "declare_query_form_select", "scroll": "declare_scroll_auto", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_two BINARY CURSOR WITHOUT HOLD FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_declare_cursor_54885ca3e044
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_text", "cursor_name": "declare_cursor_name_one", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_with", "projection": "declare_projection_two", "query_form": "declare_query_form_select", "scroll": "declare_scroll_auto", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_one CURSOR WITH HOLD FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_declare_cursor_52b5b59ed343
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_binary", "cursor_name": "declare_cursor_name_one", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_absent", "projection": "declare_projection_two", "query_form": "declare_query_form_values", "scroll": "declare_scroll_auto", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_one BINARY CURSOR FOR VALUES (1, 1), (2, 2);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;

-- case_id: manifest_declare_cursor_50c53a697a07
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_text", "cursor_name": "declare_cursor_name_two", "declarations": "declare_declarations_integer", "form": "declare_form_cursor", "hold": "declare_hold_absent", "projection": "declare_projection_two", "query_form": "declare_query_form_select", "scroll": "declare_scroll_no", "value_rows": "declare_value_rows_two"}
-- environment_requirements: [{"allowed_values": ["active_transaction"], "fact_refs": ["declare_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_cursor_source CASCADE;
CREATE TABLE t_cursor_source (col_1 INTEGER NOT NULL, col_2 INTEGER NOT NULL);
INSERT INTO t_cursor_source (col_1, col_2) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
BEGIN;
-- test_sql:
DECLARE c_decl_two NO SCROLL CURSOR FOR SELECT col_1, col_2 FROM t_cursor_source ORDER BY col_1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_cursor_source CASCADE;
