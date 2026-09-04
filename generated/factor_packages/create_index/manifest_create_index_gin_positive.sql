-- generated_from: manifest_create_index_gin_positive
-- static_only: true
-- case_count: 5

-- case_id: manifest_create_index_gin_positive_9381a32b4ec9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gin_array", "method": "ci_method_gin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_gin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
CREATE TABLE t_ci_gin_array (id INTEGER, info INT[]) WITH (storage_type=astore);
INSERT INTO t_ci_gin_array VALUES (1, ARRAY[1, 2]);
-- test_sql:
CREATE INDEX idx_ci_gin_9381a32b ON t_ci_gin_array USING gin (info);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;

-- case_id: manifest_create_index_gin_positive_6e5d14797c92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gin_array", "method": "ci_method_gin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fastupdate_on", "table_profile": "ci_table_gin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
CREATE TABLE t_ci_gin_array (id INTEGER, info INT[]) WITH (storage_type=astore);
INSERT INTO t_ci_gin_array VALUES (1, ARRAY[1, 2]);
-- test_sql:
CREATE INDEX idx_ci_gin_6e5d1479 ON t_ci_gin_array USING gin (info) WITH (fastupdate = on);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;

-- case_id: manifest_create_index_gin_positive_460edecd1e03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gin_array", "method": "ci_method_gin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_gin_pending_64", "table_profile": "ci_table_gin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
CREATE TABLE t_ci_gin_array (id INTEGER, info INT[]) WITH (storage_type=astore);
INSERT INTO t_ci_gin_array VALUES (1, ARRAY[1, 2]);
-- test_sql:
CREATE INDEX idx_ci_gin_460edecd ON t_ci_gin_array USING gin (info) WITH (gin_pending_list_limit = 64);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;

-- case_id: manifest_create_index_gin_positive_9dad233d7ceb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gin_array", "method": "ci_method_gin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_gin_pending_max", "table_profile": "ci_table_gin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
CREATE TABLE t_ci_gin_array (id INTEGER, info INT[]) WITH (storage_type=astore);
INSERT INTO t_ci_gin_array VALUES (1, ARRAY[1, 2]);
-- test_sql:
CREATE INDEX idx_ci_gin_9dad233d ON t_ci_gin_array USING gin (info) WITH (gin_pending_list_limit = 2147483647);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;

-- case_id: manifest_create_index_gin_positive_50bb085d7a50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gin_array", "method": "ci_method_gin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_type_astore", "table_profile": "ci_table_gin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
CREATE TABLE t_ci_gin_array (id INTEGER, info INT[]) WITH (storage_type=astore);
INSERT INTO t_ci_gin_array VALUES (1, ARRAY[1, 2]);
-- test_sql:
CREATE INDEX idx_ci_gin_50bb085d ON t_ci_gin_array USING gin (info) WITH (storage_type = ASTORE);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
