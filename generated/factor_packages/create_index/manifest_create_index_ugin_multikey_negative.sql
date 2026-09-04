-- generated_from: manifest_create_index_ugin_multikey_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_ugin_multikey_negative_c3b9dc09d87b
-- expected: error
-- expected_error_category: ugin_multikey_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_two_columns_invalid", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ugin_text", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
CREATE TABLE t_ci_ugin_text (name VARCHAR(100), note VARCHAR(100)) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_text (name, note) VALUES ('qwertyu0001', 'first'), ('2024新年快乐7days', 'second');
-- test_sql:
CREATE INDEX idx_ci_ugin_bad_c3b9dc09 ON t_ci_ugin_text USING ugin (name ugin_trgm_ops, note ugin_trgm_ops);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
