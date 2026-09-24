-- generated_from: manifest_create_index_key_method_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_key_method_negative_c7f3020c62ec
-- expected: error
-- expected_error_category: index_method_key_type_mismatch
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_gin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_gin_array", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
CREATE TABLE t_ci_gin_array (id INTEGER, info INT[]) WITH (storage_type=astore);
INSERT INTO t_ci_gin_array VALUES (1, ARRAY[1, 2]);
-- test_sql:
CREATE INDEX idx_ci_keym_bad_c7f3020c ON t_ci_gin_array USING gin (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gin_array CASCADE;
