-- generated_from: manifest_create_role_no_login_disabled_password
-- static_only: true
-- case_count: 12

-- case_id: manifest_create_role_no_login_disabled_password_6297f6df685d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_nologin", "password_keyword": "create_role_password_keyword_password", "with_keyword": "create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new NOLOGIN PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_e8e5ead094d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_no_createdb", "password_keyword": "create_role_password_keyword_identified", "with_keyword": "create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new NOLOGIN NOCREATEDB IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_be5db33b75b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_nologin", "password_keyword": "create_role_password_keyword_identified", "with_keyword": "create_role_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new WITH NOLOGIN IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_d624c22b7d04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_no_createdb", "password_keyword": "create_role_password_keyword_password", "with_keyword": "create_role_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new WITH NOLOGIN NOCREATEDB PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_645302cd51f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_no_createrole", "password_keyword": "create_role_password_keyword_password", "with_keyword": "create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new NOLOGIN NOCREATEROLE PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_f4c5cc046c8d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_conn_zero", "password_keyword": "create_role_password_keyword_password", "with_keyword": "create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new NOLOGIN CONNECTION LIMIT 0 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_d1b5e6ad0329
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_conn_one", "password_keyword": "create_role_password_keyword_password", "with_keyword": "create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new NOLOGIN CONNECTION LIMIT 1 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_9ca5fe244eff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_conn_unlimited", "password_keyword": "create_role_password_keyword_password", "with_keyword": "create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new NOLOGIN CONNECTION LIMIT -1 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_c0e4a7098552
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_no_createrole", "password_keyword": "create_role_password_keyword_identified", "with_keyword": "create_role_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new WITH NOLOGIN NOCREATEROLE IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_f56da826c02d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_conn_zero", "password_keyword": "create_role_password_keyword_identified", "with_keyword": "create_role_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new WITH NOLOGIN CONNECTION LIMIT 0 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_9720c1e517a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_conn_one", "password_keyword": "create_role_password_keyword_identified", "with_keyword": "create_role_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new WITH NOLOGIN CONNECTION LIMIT 1 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;

-- case_id: manifest_create_role_no_login_disabled_password_112a4795cf47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_role_options_conn_unlimited", "password_keyword": "create_role_password_keyword_identified", "with_keyword": "create_role_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_role_absent FROM gs_roles WHERE rolname = 'b9_role_new';
-- test_sql:
CREATE ROLE b9_role_new WITH NOLOGIN CONNECTION LIMIT -1 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_role_new;
