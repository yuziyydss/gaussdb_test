-- generated_from: manifest_drop_weak_password_dictionary_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_weak_password_dictionary_fresh_syntax_b5dbfc3f40c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "drop_weak_password_dictionary_command_fixed"}
-- environment_requirements: [{"allowed_values": ["initial_user_sysadmin_or_security_admin"], "fact_refs": ["drop_weak_password_dictionary_fact_privilege"], "key": "weak_password_dictionary_privilege"}]
-- test_sql:
DROP WEAK PASSWORD DICTIONARY;
