-- generated_from: manifest_alter_default_privileges_revoke_tables
-- static_only: true
-- case_count: 9

-- case_id: manifest_alter_default_privileges_revoke_tables_8eac8f509af5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE SELECT ON TABLES FROM b9_role_b;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_58e67fefbc7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_restrict", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_option", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_two", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select_insert", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE GRANT OPTION FOR SELECT, INSERT ON TABLES FROM b9_role_b, b9_role_c RESTRICT;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_a21a479f9d1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_cascade", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_option", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE GRANT OPTION FOR SELECT ON TABLES FROM b9_role_b CASCADE;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_eb7312c48543
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_constraints", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_two", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE SELECT ON TABLES FROM b9_role_b, b9_role_c CASCADE CONSTRAINTS;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_cad68e03001c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_restrict", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select_insert", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE SELECT, INSERT ON TABLES FROM b9_role_b RESTRICT;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_363097fcfb31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_constraints", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_option", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select_insert", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE GRANT OPTION FOR SELECT, INSERT ON TABLES FROM b9_role_b CASCADE CONSTRAINTS;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_e31f51cd46ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_cascade", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_two", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select_insert", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE SELECT, INSERT ON TABLES FROM b9_role_b, b9_role_c CASCADE;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_413af7752da4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_option", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_two", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select_insert", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE GRANT OPTION FOR SELECT, INSERT ON TABLES FROM b9_role_b, b9_role_c;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_revoke_tables_df0936ca43d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_revoke", "behavior": "alter_default_privileges_behavior_restrict", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_tables", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TABLES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON FUNCTIONS TO b9_role_b, b9_role_c WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT ALL PRIVILEGES ON TYPES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE SELECT ON TABLES FROM b9_role_b RESTRICT;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
