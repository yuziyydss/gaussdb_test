-- generated_from: manifest_create_database_link_fresh_syntax
-- static_only: true
-- case_count: 5

-- case_id: manifest_create_database_link_fresh_syntax_b6dce568210a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"backend": "create_database_link_backend_gauss", "credential_clause": "create_database_link_credential_current_user", "link_name": "create_database_link_link_name_fresh", "using_clause": "create_database_link_using_gauss", "visibility": "create_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial"], "fact_refs": ["create_database_link_fact_no_initial"], "key": "actor_identity"}]
-- test_sql:
CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (host 'gaussdb-static-syntax.invalid');

-- case_id: manifest_create_database_link_fresh_syntax_4eb7a77f3181
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"backend": "create_database_link_backend_oracle", "credential_clause": "create_database_link_credential_current_user", "link_name": "create_database_link_link_name_fresh", "using_clause": "create_database_link_using_oracle", "visibility": "create_database_link_visibility_public"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial"], "fact_refs": ["create_database_link_fact_no_initial"], "key": "actor_identity"}]
-- test_sql:
CREATE PUBLIC DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (dbserver 'oracle-static-syntax.invalid');

-- case_id: manifest_create_database_link_fresh_syntax_f321f9b8a2c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"backend": "create_database_link_backend_gauss", "credential_clause": "create_database_link_credential_current_user", "link_name": "create_database_link_link_name_fresh", "using_clause": "create_database_link_using_oracle", "visibility": "create_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial"], "fact_refs": ["create_database_link_fact_no_initial"], "key": "actor_identity"}]
-- test_sql:
CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (dbserver 'oracle-static-syntax.invalid');

-- case_id: manifest_create_database_link_fresh_syntax_4f87f59fb5de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"backend": "create_database_link_backend_oracle", "credential_clause": "create_database_link_credential_current_user", "link_name": "create_database_link_link_name_fresh", "using_clause": "create_database_link_using_gauss", "visibility": "create_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial"], "fact_refs": ["create_database_link_fact_no_initial"], "key": "actor_identity"}]
-- test_sql:
CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (host 'gaussdb-static-syntax.invalid');

-- case_id: manifest_create_database_link_fresh_syntax_6b55c7749aaf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"backend": "create_database_link_backend_gauss", "credential_clause": "create_database_link_credential_current_user", "link_name": "create_database_link_link_name_fresh", "using_clause": "create_database_link_using_gauss", "visibility": "create_database_link_visibility_public"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial"], "fact_refs": ["create_database_link_fact_no_initial"], "key": "actor_identity"}]
-- test_sql:
CREATE PUBLIC DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (host 'gaussdb-static-syntax.invalid');
