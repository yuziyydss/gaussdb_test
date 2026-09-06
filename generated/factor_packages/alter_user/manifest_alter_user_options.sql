-- generated_from: manifest_alter_user_options
-- static_only: true
-- case_count: 8

-- case_id: manifest_alter_user_options_d9abde201dc8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_nologin", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a NOLOGIN;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_e487ff5bb608
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_no_createdb", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a WITH NOCREATEDB;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_0f83f8cc3257
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_no_createrole", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a NOCREATEROLE;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_92a6f2f372c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_conn_one", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a CONNECTION LIMIT 1;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_02282d6ed762
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_no_createdb", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a NOCREATEDB;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_3116bd681b58
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_nologin", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a WITH NOLOGIN;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_25386a542c46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_no_createrole", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a WITH NOCREATEROLE;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_options_6a438a763147
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_options", "options": "alter_user_options_conn_one", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a WITH CONNECTION LIMIT 1;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;
