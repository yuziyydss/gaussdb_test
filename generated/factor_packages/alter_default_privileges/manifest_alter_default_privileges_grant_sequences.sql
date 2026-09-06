-- generated_from: manifest_alter_default_privileges_grant_sequences
-- static_only: true
-- case_count: 5

-- case_id: manifest_alter_default_privileges_grant_sequences_e27940d2b509
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_grant", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_sequences", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
GRANT USAGE ON SCHEMA fp_cs_one TO b9_role_b, b9_role_c;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT USAGE ON SEQUENCES TO b9_role_b;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
REVOKE USAGE ON SCHEMA fp_cs_one FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_grant_sequences_f4d3f73123aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_grant", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_with", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_sequences", "recipients": "alter_default_privileges_recipients_two", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage_update", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
GRANT USAGE ON SCHEMA fp_cs_one TO b9_role_b, b9_role_c;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT USAGE, UPDATE ON SEQUENCES TO b9_role_b, b9_role_c WITH GRANT OPTION;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
REVOKE USAGE ON SCHEMA fp_cs_one FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_grant_sequences_4b40580c831e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_grant", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_with", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_sequences", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
GRANT USAGE ON SCHEMA fp_cs_one TO b9_role_b, b9_role_c;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT USAGE ON SEQUENCES TO b9_role_b WITH GRANT OPTION;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
REVOKE USAGE ON SCHEMA fp_cs_one FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_grant_sequences_7692447c70f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_grant", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_sequences", "recipients": "alter_default_privileges_recipients_two", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
GRANT USAGE ON SCHEMA fp_cs_one TO b9_role_b, b9_role_c;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT USAGE ON SEQUENCES TO b9_role_b, b9_role_c;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
REVOKE USAGE ON SCHEMA fp_cs_one FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;

-- case_id: manifest_alter_default_privileges_grant_sequences_b544e5f6253b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_default_privileges_action_grant", "behavior": "alter_default_privileges_behavior_none", "function_privileges": "alter_default_privileges_function_privileges_execute", "grant_option": "alter_default_privileges_grant_option_none", "grant_option_for": "alter_default_privileges_grant_option_for_all", "object_kind": "alter_default_privileges_object_kind_sequences", "recipients": "alter_default_privileges_recipients_one", "sequence_privileges": "alter_default_privileges_sequence_privileges_usage_update", "table_privileges": "alter_default_privileges_table_privileges_select", "type_privileges": "alter_default_privileges_type_privileges_usage"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_default_privileges_fact_schema_create"], "key": "schema_create_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_role_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE ROLE b9_role_a NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_b NOLOGIN PASSWORD DISABLE;
CREATE ROLE b9_role_c NOLOGIN PASSWORD DISABLE;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
GRANT USAGE ON SCHEMA fp_cs_one TO b9_role_b, b9_role_c;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one GRANT USAGE, UPDATE ON SEQUENCES TO b9_role_b;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TABLES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON SEQUENCES FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON FUNCTIONS FROM b9_role_b, b9_role_c;
ALTER DEFAULT PRIVILEGES IN SCHEMA fp_cs_one REVOKE ALL PRIVILEGES ON TYPES FROM b9_role_b, b9_role_c;
REVOKE USAGE ON SCHEMA fp_cs_one FROM b9_role_b, b9_role_c;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP ROLE IF EXISTS b9_role_c;
DROP ROLE IF EXISTS b9_role_b;
DROP ROLE IF EXISTS b9_role_a;
