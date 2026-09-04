-- generated_from: manifest_insert_cte_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_insert_cte_positive_7cfdd178c88b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert AS (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_source CASCADE;

-- case_id: manifest_insert_cte_positive_4bf4805cf25e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_recursive_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH RECURSIVE src_insert(col_1, name) AS (VALUES (201, 'recursive') UNION ALL SELECT col_1 + 1, name FROM src_insert WHERE col_1 < 202) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_cte_positive_a13fe8996ed2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH src_insert AS (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_source CASCADE;

-- case_id: manifest_insert_cte_positive_05be08bfc362
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_recursive_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
WITH RECURSIVE src_insert(col_1, name) AS (VALUES (201, 'recursive') UNION ALL SELECT col_1 + 1, name FROM src_insert WHERE col_1 < 202) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
