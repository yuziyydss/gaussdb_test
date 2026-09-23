-- generated_from: manifest_drop_global_configuration_fresh_syntax
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_global_configuration_fresh_syntax_f3c01aadb404
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"names": "drop_global_configuration_names_one"}
-- environment_requirements: [{"allowed_values": ["initial_user"], "fact_refs": ["drop_global_configuration_fact_initial_user"], "key": "global_configuration_privilege"}]
-- test_sql:
DROP GLOBAL CONFIGURATION g_drop_global_config_syntax;

-- case_id: manifest_drop_global_configuration_fresh_syntax_985a4adaeb3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"names": "drop_global_configuration_names_two"}
-- environment_requirements: [{"allowed_values": ["initial_user"], "fact_refs": ["drop_global_configuration_fact_initial_user"], "key": "global_configuration_privilege"}]
-- test_sql:
DROP GLOBAL CONFIGURATION b8_test_key_a, b8_test_key_b;
