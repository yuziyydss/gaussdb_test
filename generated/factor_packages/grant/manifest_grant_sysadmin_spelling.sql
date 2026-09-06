-- generated_from: manifest_grant_sysadmin_spelling
-- static_only: true
-- case_count: 2

-- case_id: manifest_grant_sysadmin_spelling_b60baf0caf6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_sysadmin", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALL PRIVILEGES TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_sysadmin_spelling_148f131d70d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_sysadmin", "sysadmin_spelling": "grant_sysadmin_privilege"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_all_privileges_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALL PRIVILEGE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;
