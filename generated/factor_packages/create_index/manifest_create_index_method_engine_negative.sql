-- generated_from: manifest_create_index_method_engine_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_method_engine_negative_617ba94c01e7
-- expected: error
-- expected_error_category: index_method_storage_engine_mismatch
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_trgm", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_eng_bad_617ba94c ON t_ci_astore USING ugin (name ugin_trgm_ops);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
