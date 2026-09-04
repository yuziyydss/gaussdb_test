-- generated_from: manifest_create_index_ugin_array_positive
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_index_ugin_array_positive_da05533b310d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_bool_array", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ugin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_array CASCADE;
CREATE TABLE t_ci_ugin_array (tags BOOL[]) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_array VALUES (ARRAY[true, false]);
-- test_sql:
CREATE INDEX idx_ci_ua_da05533b ON t_ci_ugin_array USING ugin (tags _bool_ops);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_array CASCADE;

-- case_id: manifest_create_index_ugin_array_positive_a0f2d6863323
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_bool_array", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fastupdate_on", "table_profile": "ci_table_ugin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_array CASCADE;
CREATE TABLE t_ci_ugin_array (tags BOOL[]) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_array VALUES (ARRAY[true, false]);
-- test_sql:
CREATE INDEX idx_ci_ua_a0f2d686 ON t_ci_ugin_array USING ugin (tags _bool_ops) WITH (fastupdate = on);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_array CASCADE;

-- case_id: manifest_create_index_ugin_array_positive_d79061708c1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_bool_array", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_gin_pending_64", "table_profile": "ci_table_ugin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_array CASCADE;
CREATE TABLE t_ci_ugin_array (tags BOOL[]) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_array VALUES (ARRAY[true, false]);
-- test_sql:
CREATE INDEX idx_ci_ua_d7906170 ON t_ci_ugin_array USING ugin (tags _bool_ops) WITH (gin_pending_list_limit = 64);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_array CASCADE;
