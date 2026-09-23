-- generated_from: manifest_create_table_as_collision_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_table_as_collision_negative_642f77ad0f7f
-- expected: error
-- expected_error_category: relation_already_exists
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_existing", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_existing CASCADE;
CREATE TABLE t_ctas_existing (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_existing (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TABLE t_ctas_existing AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
DROP TABLE IF EXISTS t_ctas_existing CASCADE;
