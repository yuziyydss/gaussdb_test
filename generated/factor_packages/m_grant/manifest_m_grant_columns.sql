-- generated_from: manifest_m_grant_columns
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_grant_columns_1b1e78df4461
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id) ON m_grant_namespace.source TO m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_c514f622fadc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_update", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT UPDATE (qty) ON TABLE m_grant_namespace.source TO GROUP m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_f4f18200f14a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_both_columns", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id, qty) ON m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_1f8d764fa6a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_mixed", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id), UPDATE (qty) ON TABLE m_grant_namespace.source TO GROUP m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_25ca40a0b012
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id) ON m_grant_namespace.source TO GROUP m_b04_role_existing WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_2b87d7907757
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_8ef4be6e1acc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_update", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT UPDATE (qty) ON m_grant_namespace.source TO m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_c39a3d044ec9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_both_columns", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id, qty) ON TABLE m_grant_namespace.source TO GROUP m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_columns_0993e8a08e1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_mixed", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_columns", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT (id), UPDATE (qty) ON m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
