-- generated_from: manifest_create_weak_password_dictionary_fresh_single
-- static_only: true
-- case_count: 2

-- case_id: manifest_create_weak_password_dictionary_fresh_single_ea0a2a5bcc7a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"password_values": "create_weak_password_dictionary_password_values_static_only", "with_values": "create_weak_password_dictionary_with_values_none"}
-- environment_requirements: [{"allowed_values": ["initial_user_sysadmin_or_security_admin"], "fact_refs": ["create_weak_password_dictionary_fact_privilege"], "key": "weak_password_dictionary_privilege"}]
-- test_sql:
CREATE WEAK PASSWORD DICTIONARY ('static_only');

-- case_id: manifest_create_weak_password_dictionary_fresh_single_4154c5339a6c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"password_values": "create_weak_password_dictionary_password_values_static_only", "with_values": "create_weak_password_dictionary_with_values_yes"}
-- environment_requirements: [{"allowed_values": ["initial_user_sysadmin_or_security_admin"], "fact_refs": ["create_weak_password_dictionary_fact_privilege"], "key": "weak_password_dictionary_privilege"}]
-- test_sql:
CREATE WEAK PASSWORD DICTIONARY WITH VALUES ('static_only');
