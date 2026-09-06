-- generated_from: manifest_alter_materialized_view_rename
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_materialized_view_rename_d7374def1dc9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_materialized_view_action_column", "if_exists": "alter_materialized_view_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
-- test_sql:
ALTER MATERIALIZED VIEW mv_full RENAME COLUMN col_1 TO renamed_1;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_alter_materialized_view_rename_719d57b7902c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_materialized_view_action_column_short", "if_exists": "alter_materialized_view_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
-- test_sql:
ALTER MATERIALIZED VIEW mv_full RENAME col_1 TO renamed_1;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_alter_materialized_view_rename_99f927a48064
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_materialized_view_action_name", "if_exists": "alter_materialized_view_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
SELECT 1;
-- test_sql:
ALTER MATERIALIZED VIEW mv_full RENAME TO mv_amv_renamed;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_amv_renamed CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_alter_materialized_view_rename_69b0c6b02b27
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_materialized_view_action_column", "if_exists": "alter_materialized_view_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
-- test_sql:
ALTER MATERIALIZED VIEW IF EXISTS mv_full RENAME COLUMN col_1 TO renamed_1;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_alter_materialized_view_rename_7093a3aaac27
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_materialized_view_action_column_short", "if_exists": "alter_materialized_view_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
-- test_sql:
ALTER MATERIALIZED VIEW IF EXISTS mv_full RENAME col_1 TO renamed_1;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_alter_materialized_view_rename_33d846c960d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_materialized_view_action_name", "if_exists": "alter_materialized_view_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
SELECT 1;
-- test_sql:
ALTER MATERIALIZED VIEW IF EXISTS mv_full RENAME TO mv_amv_renamed;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_amv_renamed CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
