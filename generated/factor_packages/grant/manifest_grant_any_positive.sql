-- generated_from: manifest_grant_any_positive
-- static_only: true
-- case_count: 84

-- case_id: manifest_grant_any_positive_4a5c6dbb411c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TABLE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_665b9f446317
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_alter_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TABLE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_2289aa30b0fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_787795b80cab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_select_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY TABLE TO grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d3022fa8281f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_insert_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT INSERT ANY TABLE TO GROUP grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_3c97b14b0ac6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_update_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT UPDATE ANY TABLE TO grant_recipient, grant_recipient_two WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d798704612c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_delete_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DELETE ANY TABLE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_c74d29e5fcfd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_truncate_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT TRUNCATE ANY TABLE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_11983c1aed97
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY SEQUENCE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6f85a8721a1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY INDEX TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_4b41eb7e329d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_function", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY FUNCTION TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_95425f340930
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_execute_function", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT EXECUTE ANY FUNCTION TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_1832fb5f9cef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_package", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY PACKAGE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_8bc5cb0ecac4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_execute_package", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT EXECUTE ANY PACKAGE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_571b62a7161c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TYPE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_246c9a1fd51b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TYPE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_f6e54ce49338
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TYPE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6c23edcb1cf8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY SEQUENCE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_46525719d254
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY SEQUENCE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_a7b468bf4ba0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_select_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY SEQUENCE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_f3ff989b5aaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY INDEX TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_cbbc1cf5c68d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY INDEX TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_9ec984aaf96d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_synonym", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY SYNONYM TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_22012088cee2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_synonym", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY SYNONYM TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_622645aebb0d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TRIGGER TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_4e797d3cbcbe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TRIGGER TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_acf632f1cc65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TRIGGER TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_00c738351220
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_select_update_pair", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY TABLE, UPDATE ANY TABLE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_9fceb3105167
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TABLE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_43b4748078de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_update_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT UPDATE ANY TABLE TO grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_c12fd629801a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_drop_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TABLE TO grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6151ea3be791
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_insert_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_one", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT INSERT ANY TABLE TO grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_da93c6ea6cfb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_select_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY TABLE TO GROUP grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_5590884546c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TABLE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d053495d6a81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_delete_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DELETE ANY TABLE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_b024e3156be2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_truncate_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT TRUNCATE ANY TABLE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_8d4e742a5d53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY SEQUENCE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_94da1fd427b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY INDEX TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_70805604314c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_function", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY FUNCTION TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_5f2a278b2074
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_execute_function", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT EXECUTE ANY FUNCTION TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_a30dd3aa86cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_package", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY PACKAGE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_2f5c01b226e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_execute_package", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT EXECUTE ANY PACKAGE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_000d41e2ecff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TYPE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_649f6a541f96
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_alter_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TYPE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_b2275b578b9b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_drop_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TYPE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_86479f305ebd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_alter_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY SEQUENCE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_f973ea9107a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_drop_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY SEQUENCE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d2d7ca6a2a74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_select_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY SEQUENCE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_b1260a4e622c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_alter_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY INDEX TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6c47d68fb6d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_drop_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY INDEX TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_9c671c88c9fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_synonym", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY SYNONYM TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_0ec2dba869ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_drop_synonym", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY SYNONYM TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_ba4c762429fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_create_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TRIGGER TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_0df928901891
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_alter_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TRIGGER TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_386b17298443
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_drop_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TRIGGER TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_736e063c733f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_with_admin", "any_privilege": "grant_any_select_update_pair", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY TABLE, UPDATE ANY TABLE TO GROUP grant_recipient WITH ADMIN OPTION;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d7c49d812757
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TABLE TO GROUP grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d26ae30dfdf4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_update_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_group", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT UPDATE ANY TABLE TO GROUP grant_recipient;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_ec471eb1cf0a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6bbb7bffa728
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_25893ca7a444
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_select_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d52447cc7c69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_insert_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT INSERT ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_68e1723388b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_delete_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DELETE ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_91623e8a8db4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_truncate_table", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT TRUNCATE ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6b101779021d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY SEQUENCE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_ecdebf543939
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY INDEX TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d3c7c97ed75e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_function", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY FUNCTION TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_a77077fabbcf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_execute_function", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT EXECUTE ANY FUNCTION TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_92e5bc01bfb1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_package", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY PACKAGE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_4045dc2eb680
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_execute_package", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT EXECUTE ANY PACKAGE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_39cd30d194ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TYPE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_de3320382653
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TYPE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_2bac4fed2660
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_type", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TYPE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_3454ef6736ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY SEQUENCE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_61161aae2d3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY SEQUENCE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_791441a657d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_select_sequence", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY SEQUENCE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_e912002a41c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY INDEX TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_e656e6ad8d25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_index", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY INDEX TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_b1bbd1e71ff7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_synonym", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY SYNONYM TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_19a8c70a4b2a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_synonym", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY SYNONYM TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_181da0176267
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_create_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT CREATE ANY TRIGGER TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_d08389c4975f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_alter_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT ALTER ANY TRIGGER TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_ad24cbc36785
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_drop_trigger", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT DROP ANY TRIGGER TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_grant_any_positive_6fc47df95db2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option": "grant_admin_option_absent", "any_privilege": "grant_any_select_update_pair", "database_link_privilege": "grant_dblink_create", "database_link_public": "grant_dblink_private", "grant_option": "grant_option_absent", "object_grantee": "grant_grantee_role", "object_privilege": "grant_priv_select", "object_target": "grant_target_table", "public_synonym_privilege": "grant_public_synonym_create", "role_recipient": "grant_role_recipient_two", "role_source": "grant_role_source_one", "statement_form": "grant_form_any", "sysadmin_spelling": "grant_sysadmin_privileges"}
-- environment_requirements: [{"allowed_values": ["system_administrator"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_privilege", "create_role::create_role_fact_disable_admin"], "key": "executor_role"}, {"allowed_values": ["off"], "fact_refs": ["grant_fact_any_environment", "create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duties"}, {"allowed_values": ["isolated_instance_fresh_names"], "fact_refs": ["grant_fact_security_guidance", "grant_fact_existing_identifiers"], "key": "role_test_environment"}]
-- fixture_setup:
BEGIN;
CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;
CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;
-- test_sql:
GRANT SELECT ANY TABLE, UPDATE ANY TABLE TO grant_recipient, grant_recipient_two;
-- fixture_teardown:
ROLLBACK;
