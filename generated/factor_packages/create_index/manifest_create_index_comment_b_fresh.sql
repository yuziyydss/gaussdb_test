-- generated_from: manifest_create_index_comment_b_fresh
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_comment_b_fresh_d5732e87fd22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment_clause": "ci_comment_short_b", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_comment_fresh", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["ci_fact_comment_b_mode"], "key": "compatibility_mode"}, {"allowed_values": ["create_any_index"], "fact_refs": ["ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["ci_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_ci_comment (id INTEGER) WITH (storage_type=astore);
-- test_sql:
CREATE INDEX idx_ci_comment_d5732e87 ON g_ci_comment USING btree (id) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE g_ci_comment;
