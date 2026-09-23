-- generated_from: manifest_create_group_disabled_password
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_group_disabled_password_0a33e89499c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"legacy_option": "create_group_legacy_option_nologin", "password_keyword": "create_group_password_keyword_password", "with_keyword": "create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_group_absent FROM gs_roles WHERE rolname = 'b9_group_new';
-- test_sql:
CREATE GROUP b9_group_new NOLOGIN PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_group_new;

-- case_id: manifest_create_group_disabled_password_2d48fe565d82
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"legacy_option": "create_group_legacy_option_nologin", "password_keyword": "create_group_password_keyword_identified", "with_keyword": "create_group_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_group_absent FROM gs_roles WHERE rolname = 'b9_group_new';
-- test_sql:
CREATE GROUP b9_group_new WITH NOLOGIN IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_group_new;

-- case_id: manifest_create_group_disabled_password_31dad54a63fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"legacy_option": "create_group_legacy_option_nologin", "password_keyword": "create_group_password_keyword_identified", "with_keyword": "create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_group_absent FROM gs_roles WHERE rolname = 'b9_group_new';
-- test_sql:
CREATE GROUP b9_group_new NOLOGIN IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_group_new;

-- case_id: manifest_create_group_disabled_password_e75e291c8c29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"legacy_option": "create_group_legacy_option_nologin", "password_keyword": "create_group_password_keyword_password", "with_keyword": "create_group_with_keyword_with"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_group_absent FROM gs_roles WHERE rolname = 'b9_group_new';
-- test_sql:
CREATE GROUP b9_group_new WITH NOLOGIN PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS b9_group_new;
