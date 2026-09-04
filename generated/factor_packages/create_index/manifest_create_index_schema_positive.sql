-- generated_from: manifest_create_index_schema_positive
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_schema_positive_acf872304082
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_schema_astore", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP SCHEMA IF EXISTS ci_target_schema CASCADE;
CREATE SCHEMA ci_target_schema;
CREATE TABLE ci_target_schema.t_ci_schema (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO ci_target_schema.t_ci_schema (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX ci_target_schema.idx_ci_schema_acf87230 ON ci_target_schema.t_ci_schema (id);
-- fixture_teardown:
DROP SCHEMA IF EXISTS ci_target_schema CASCADE;
