-- generated_from: manifest_create_user_isolated_no_login
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_user_isolated_no_login_76ca74275b07
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"password_keyword": "create_user_password_keyword_password", "with_keyword": "create_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "user_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_user_absent FROM gs_roles WHERE rolname = 'b9_user_new';
-- test_sql:
CREATE USER b9_user_new NOLOGIN PASSWORD DISABLE;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_new RESTRICT;

-- case_id: manifest_create_user_isolated_no_login_862089eb85fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"password_keyword": "create_user_password_keyword_identified", "with_keyword": "create_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "user_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_user_absent FROM gs_roles WHERE rolname = 'b9_user_new';
-- test_sql:
CREATE USER b9_user_new NOLOGIN IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_new RESTRICT;

-- case_id: manifest_create_user_isolated_no_login_db77fb949646
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"password_keyword": "create_user_password_keyword_password", "with_keyword": "create_user_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "user_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_user_absent FROM gs_roles WHERE rolname = 'b9_user_new';
-- test_sql:
CREATE USER b9_user_new WITH NOLOGIN PASSWORD DISABLE;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_new RESTRICT;

-- case_id: manifest_create_user_isolated_no_login_3da9d1965db5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"password_keyword": "create_user_password_keyword_identified", "with_keyword": "create_user_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "user_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_user_absent FROM gs_roles WHERE rolname = 'b9_user_new';
-- test_sql:
CREATE USER b9_user_new WITH NOLOGIN IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_new RESTRICT;
