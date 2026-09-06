-- generated_from: manifest_create_table_as_existing_notice
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_table_as_existing_notice_a31bb8b8aa8d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_existing", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_existing CASCADE;
CREATE TABLE t_ctas_existing (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_existing (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TABLE IF NOT EXISTS t_ctas_existing AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
DROP TABLE IF EXISTS t_ctas_existing CASCADE;
