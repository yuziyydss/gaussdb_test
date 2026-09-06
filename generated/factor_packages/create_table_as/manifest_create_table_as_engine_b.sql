-- generated_from: manifest_create_table_as_engine_b
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_table_as_engine_b_bfc77102d7c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_bare", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table_as_fact_engine"], "key": "sql_compatibility"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate ENGINE InnoDB AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_engine_b_32f31371ca86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_equal", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table_as_fact_engine"], "key": "sql_compatibility"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate ENGINE = InnoDB AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_engine_b_da54a29071f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_single", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table_as_fact_engine"], "key": "sql_compatibility"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate ENGINE = 'InnoDB' AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_engine_b_c33070665c72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_double", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table_as_fact_engine"], "key": "sql_compatibility"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate ENGINE = "InnoDB" AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;
