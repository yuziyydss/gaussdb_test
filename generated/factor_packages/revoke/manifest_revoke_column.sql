-- generated_from: manifest_revoke_column
-- static_only: true
-- case_count: 11

-- case_id: manifest_revoke_column_2a9ac3f7b2d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1) ON TABLE b9_revoke_source FROM b9_role_b;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_5da87ceee389
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_two", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_f51c43e3ba99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_mixed", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1), UPDATE (col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c CASCADE;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_b740eba65fd4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT (col_1) ON TABLE b9_revoke_source FROM b9_role_b CASCADE;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_65171cf1eba7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_two", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_797a4dc64a63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_mixed", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_option", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT (col_1), UPDATE (col_2) ON TABLE b9_revoke_source FROM b9_role_b;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_e71de410434e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_two", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_4973634504a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_select_one", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1) ON TABLE b9_revoke_source FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_796e2baf39c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_none", "column_privileges": "revoke_column_privileges_select_two", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_0e5274afdd99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_cascade", "column_privileges": "revoke_column_privileges_select_two", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b CASCADE;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_revoke_column_e2c30393e792
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"admin_option_for": "revoke_admin_option_for_all", "behavior": "revoke_behavior_restrict", "column_privileges": "revoke_column_privileges_mixed", "form": "revoke_form_column", "grant_option_for": "revoke_grant_option_for_all", "privileges": "revoke_privileges_select", "recipients": "revoke_recipients_one", "table_keyword": "revoke_table_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE TABLE b9_revoke_source (col_1 INTEGER, col_2 INTEGER);
GRANT SELECT (col_1, col_2), UPDATE (col_1, col_2) ON TABLE b9_revoke_source TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (col_1), UPDATE (col_2) ON TABLE b9_revoke_source FROM b9_role_b RESTRICT;
-- fixture_teardown:
REVOKE ALL PRIVILEGES (col_1, col_2) ON TABLE b9_revoke_source FROM b9_role_b, b9_role_c;
DROP TABLE IF EXISTS b9_revoke_source;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
