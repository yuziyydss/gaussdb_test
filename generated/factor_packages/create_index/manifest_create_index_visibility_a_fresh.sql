-- generated_from: manifest_create_index_visibility_a_fresh
-- static_only: true
-- case_count: 2

-- case_id: manifest_create_index_visibility_a_fresh_8b37fa29fa00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_visibility_fresh", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible_a_fresh"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["ci_fact_visible_mode", "ci_fact_invisible_mode"], "key": "compatibility_mode"}, {"allowed_values": ["empty"], "fact_refs": ["ci_fact_visible_keyword", "ci_fact_invisible_keyword"], "key": "disable_keyword_options_state"}, {"allowed_values": ["not_upgrading"], "fact_refs": ["ci_fact_visible_upgrade", "ci_fact_invisible_upgrade"], "key": "upgrade_phase"}, {"allowed_values": ["create_any_index"], "fact_refs": ["ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["ci_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_ci_visibility (id INTEGER) WITH (storage_type=astore);
-- test_sql:
CREATE INDEX idx_ci_visibility_8b37fa29 ON g_ci_visibility USING btree (id) VISIBLE;
-- fixture_teardown:
DROP TABLE g_ci_visibility;

-- case_id: manifest_create_index_visibility_a_fresh_4b56ebd21e83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_visibility_fresh", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible_a_fresh"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["ci_fact_visible_mode", "ci_fact_invisible_mode"], "key": "compatibility_mode"}, {"allowed_values": ["empty"], "fact_refs": ["ci_fact_visible_keyword", "ci_fact_invisible_keyword"], "key": "disable_keyword_options_state"}, {"allowed_values": ["not_upgrading"], "fact_refs": ["ci_fact_visible_upgrade", "ci_fact_invisible_upgrade"], "key": "upgrade_phase"}, {"allowed_values": ["create_any_index"], "fact_refs": ["ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["ci_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_ci_visibility (id INTEGER) WITH (storage_type=astore);
-- test_sql:
CREATE INDEX idx_ci_visibility_4b56ebd2 ON g_ci_visibility USING btree (id) INVISIBLE;
-- fixture_teardown:
DROP TABLE g_ci_visibility;
