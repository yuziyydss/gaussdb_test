-- generated_from: manifest_alter_global_configuration_fresh_syntax
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_global_configuration_fresh_syntax_4b11001fbca8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"entries": "alter_global_configuration_entries_one"}
-- environment_requirements: [{"allowed_values": ["initial_user"], "fact_refs": ["alter_global_configuration_fact_initial_user"], "key": "global_configuration_privilege"}]
-- test_sql:
ALTER GLOBAL CONFIGURATION WITH (g_alter_global_config_syntax = 'static_only');

-- case_id: manifest_alter_global_configuration_fresh_syntax_c8ca7e2447bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"entries": "alter_global_configuration_entries_two"}
-- environment_requirements: [{"allowed_values": ["initial_user"], "fact_refs": ["alter_global_configuration_fact_initial_user"], "key": "global_configuration_privilege"}]
-- test_sql:
ALTER GLOBAL CONFIGURATION WITH (b8_test_key_a = 'true', b8_test_key_b = 'false');
