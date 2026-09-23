-- generated_from: manifest_create_database_link_backend_mismatch_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_database_link_backend_mismatch_negative_af46eca4002f
-- expected: error
-- expected_error_category: backend_option_mismatch
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"backend": "create_database_link_backend_oracle", "credential_clause": "create_database_link_credential_current_user", "link_name": "create_database_link_link_name_fresh", "using_clause": "create_database_link_using_gauss", "visibility": "create_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial"], "fact_refs": ["create_database_link_fact_no_initial"], "key": "actor_identity"}]
-- test_sql:
CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (host 'gaussdb-static-syntax.invalid');
