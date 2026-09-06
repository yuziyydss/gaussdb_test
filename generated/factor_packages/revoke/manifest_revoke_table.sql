-- generated_from: manifest_revoke_table
-- static_only: true
-- case_count: 11

-- case_id: manifest_revoke_table_801f89e638c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT ON b9_revoke_source FROM b9_role_b;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_ee903e79dd2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select_insert", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT, INSERT ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_89762eeab434
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select_update", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT, UPDATE ON TABLE b9_revoke_source FROM b9_role_b CASCADE;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_4a1542dc8f16
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT ON b9_revoke_source FROM b9_role_b, b9_role_c CASCADE;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_c0e383ac45da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select_insert", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT, INSERT ON b9_revoke_source FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_c36b1e2b793b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select_update", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT, UPDATE ON b9_revoke_source FROM b9_role_b, b9_role_c;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_cb5cc9a2b0e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_table"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_05513b014345
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT ON b9_revoke_source FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_c05c815656dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select_insert", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT, INSERT ON b9_revoke_source FROM b9_role_b;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_bd140f1df873
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select_insert", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT, INSERT ON b9_revoke_source FROM b9_role_b CASCADE;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_table_8e1a0e16a843
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_table", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select_update", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT, INSERT, UPDATE ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT, UPDATE ON b9_revoke_source FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
