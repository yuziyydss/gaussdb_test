-- generated_from: manifest_insert_cte_syntax_positive
-- static_only: true
-- case_count: 5

-- case_id: manifest_insert_cte_syntax_positive_d991dcd53331
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_multiple_selects"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert AS (SELECT col_1, name FROM t_insert_source), src_insert_2 AS (SELECT col_1, name FROM src_insert) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_source CASCADE;

-- case_id: manifest_insert_cte_syntax_positive_112e193631f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_materialized_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert AS MATERIALIZED (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_source CASCADE;

-- case_id: manifest_insert_cte_syntax_positive_5e14f90d0136
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_not_materialized_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert AS NOT MATERIALIZED (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_source CASCADE;

-- case_id: manifest_insert_cte_syntax_positive_02b1104687e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_values_body"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert(col_1, name) AS (VALUES (201, 'from values')) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_cte_syntax_positive_7ca6df0d1a24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_dml_returning_body"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert AS (INSERT INTO t_insert_target (id, note) VALUES (201, 'from dml') RETURNING id AS col_1, note AS name) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
