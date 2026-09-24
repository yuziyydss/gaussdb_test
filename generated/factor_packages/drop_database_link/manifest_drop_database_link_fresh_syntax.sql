-- generated_from: manifest_drop_database_link_fresh_syntax
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_database_link_fresh_syntax_bb5b8daf950c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_link_if_exists_none", "link_name": "drop_database_link_link_name_fresh", "visibility": "drop_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link::create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial_user"], "fact_refs": ["create_database_link::create_database_link_fact_no_initial"], "key": "executor"}]
-- test_sql:
DROP DATABASE LINK g_drop_database_link;

-- case_id: manifest_drop_database_link_fresh_syntax_a12fd2790ca2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_link_if_exists_yes", "link_name": "drop_database_link_link_name_fresh", "visibility": "drop_database_link_visibility_public"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link::create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial_user"], "fact_refs": ["create_database_link::create_database_link_fact_no_initial"], "key": "executor"}]
-- test_sql:
DROP PUBLIC DATABASE LINK IF EXISTS g_drop_database_link;

-- case_id: manifest_drop_database_link_fresh_syntax_c3f8db3165e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_link_if_exists_yes", "link_name": "drop_database_link_link_name_fresh", "visibility": "drop_database_link_visibility_private"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link::create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial_user"], "fact_refs": ["create_database_link::create_database_link_fact_no_initial"], "key": "executor"}]
-- test_sql:
DROP DATABASE LINK IF EXISTS g_drop_database_link;

-- case_id: manifest_drop_database_link_fresh_syntax_b67977342b84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_database_link_if_exists_none", "link_name": "drop_database_link_link_name_fresh", "visibility": "drop_database_link_visibility_public"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database_link::create_database_link_fact_compat_a"], "key": "compatibility_mode"}, {"allowed_values": ["non_initial_user"], "fact_refs": ["create_database_link::create_database_link_fact_no_initial"], "key": "executor"}]
-- test_sql:
DROP PUBLIC DATABASE LINK g_drop_database_link;
