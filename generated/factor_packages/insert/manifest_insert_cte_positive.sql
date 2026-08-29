-- generated_from: manifest_insert_cte_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_insert_cte_positive_ae2930483bf0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_source"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
WITH src_insert AS (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_cte_positive_5c778c0e8cc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_columns", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_recursive_source"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
WITH RECURSIVE src_insert(col_1, name) AS (VALUES (1, 'one') UNION ALL SELECT col_1 + 1, name FROM src_insert WHERE col_1 < 2) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_cte_positive_033cc9dfce27
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_columns", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_source"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
WITH src_insert AS (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_cte_positive_ec13d0f701e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_cte_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_recursive_source"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
WITH RECURSIVE src_insert(col_1, name) AS (VALUES (1, 'one') UNION ALL SELECT col_1 + 1, name FROM src_insert WHERE col_1 < 2) INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM src_insert;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;
