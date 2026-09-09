-- generated_from: manifest_grant_database_link_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_grant_database_link_positive_f8a06855d797
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_database_link", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "fixture_executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}, {"allowed_values": ["independent_approval_and_grantor_preflight"], "fact_refs": ["grant_fact_security_guidance"], "key": "special_grant_authorization"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE DATABASE LINK TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_database_link_positive_a1dc58d4ef86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_public", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_database_link", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "fixture_executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}, {"allowed_values": ["independent_approval_and_grantor_preflight"], "fact_refs": ["grant_fact_security_guidance"], "key": "special_grant_authorization"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE PUBLIC DATABASE LINK TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_database_link_positive_5b77a2d0a2f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_alter", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_database_link", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "fixture_executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}, {"allowed_values": ["independent_approval_and_grantor_preflight"], "fact_refs": ["grant_fact_security_guidance"], "key": "special_grant_authorization"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER DATABASE LINK TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_database_link_positive_34bd5d180206
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_alter", "database_link_public": "grant_dblink_public", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_database_link", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "fixture_executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}, {"allowed_values": ["independent_approval_and_grantor_preflight"], "fact_refs": ["grant_fact_security_guidance"], "key": "special_grant_authorization"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER PUBLIC DATABASE LINK TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_database_link_positive_aaf1b0b68710
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_drop", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_database_link", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "fixture_executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}, {"allowed_values": ["independent_approval_and_grantor_preflight"], "fact_refs": ["grant_fact_security_guidance"], "key": "special_grant_authorization"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP DATABASE LINK TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_database_link_positive_49b0773c81df
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_drop", "database_link_public": "grant_dblink_public", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_database_link", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "fixture_executor_role"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}, {"allowed_values": ["independent_approval_and_grantor_preflight"], "fact_refs": ["grant_fact_security_guidance"], "key": "special_grant_authorization"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP PUBLIC DATABASE LINK TO grant_recipient;
-- fixture_teardown:
ROLLBACK;
