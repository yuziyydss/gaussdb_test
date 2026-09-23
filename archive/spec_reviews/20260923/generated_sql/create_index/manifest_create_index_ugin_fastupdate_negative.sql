-- generated_from: manifest_create_index_ugin_fastupdate_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_ugin_fastupdate_negative_af5cb9f303b2
-- expected: error
-- expected_error_category: ugin_fastupdate_disabled
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_bool_array", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fastupdate_off_ugin", "table_profile": "ci_table_ugin_storage", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["ci_fact_ugin_non_m_environment", "create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}, {"allowed_values": ["create_any_index"], "fact_refs": ["ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["ci_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_ci_ugin_storage (tags BOOL[]) WITH (storage_type=ustore);
-- test_sql:
CREATE INDEX idx_ci_ugin_fastupdate_negative_af5cb9f3 ON g_ci_ugin_storage USING ugin (tags _bool_ops) WITH (fastupdate = off);
-- fixture_teardown:
DROP TABLE g_ci_ugin_storage;
