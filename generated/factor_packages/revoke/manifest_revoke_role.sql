-- generated_from: manifest_revoke_role
-- static_only: true
-- case_count: 6

-- case_id: manifest_revoke_role_430750c150dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_role", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
GRANT b9_role_a TO b9_role_b, b9_role_c WITH ADMIN OPTION;
-- test_sql:
REVOKE b9_role_a FROM b9_role_b;
-- fixture_teardown:
REVOKE b9_role_a FROM b9_role_b, b9_role_c;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_role_e5ccb98d141b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_option", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_role", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
GRANT b9_role_a TO b9_role_b, b9_role_c WITH ADMIN OPTION;
-- test_sql:
REVOKE ADMIN OPTION FOR b9_role_a FROM b9_role_b, b9_role_c RESTRICT;
-- fixture_teardown:
REVOKE b9_role_a FROM b9_role_b, b9_role_c;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_role_94cbd986b0f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_role", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
GRANT b9_role_a TO b9_role_b, b9_role_c WITH ADMIN OPTION;
-- test_sql:
REVOKE b9_role_a FROM b9_role_b, b9_role_c CASCADE;
-- fixture_teardown:
REVOKE b9_role_a FROM b9_role_b, b9_role_c;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_role_f27dd9a65e96
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_option", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_role", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
GRANT b9_role_a TO b9_role_b, b9_role_c WITH ADMIN OPTION;
-- test_sql:
REVOKE ADMIN OPTION FOR b9_role_a FROM b9_role_b CASCADE;
-- fixture_teardown:
REVOKE b9_role_a FROM b9_role_b, b9_role_c;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_role_cfe4a9e812e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_role", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
GRANT b9_role_a TO b9_role_b, b9_role_c WITH ADMIN OPTION;
-- test_sql:
REVOKE b9_role_a FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE b9_role_a FROM b9_role_b, b9_role_c;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_role_0f49ef133aaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_option", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_role", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
GRANT b9_role_a TO b9_role_b, b9_role_c WITH ADMIN OPTION;
-- test_sql:
REVOKE ADMIN OPTION FOR b9_role_a FROM b9_role_b, b9_role_c;
-- fixture_teardown:
REVOKE b9_role_a FROM b9_role_b, b9_role_c;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
