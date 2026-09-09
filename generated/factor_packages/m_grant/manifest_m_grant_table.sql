-- generated_from: manifest_m_grant_table
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_grant_table_fd3b672234b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT ON m_grant_namespace.source TO m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_table_cc57b7cd5d40
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT UPDATE ON TABLE m_grant_namespace.source TO GROUP m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_table_05bcd4d9ebc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_both"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT, UPDATE ON m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_table_e1ffed1b689a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_both"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT, UPDATE ON TABLE m_grant_namespace.source TO GROUP m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_table_3c6897079d14
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_yes", "group_keyword": "m_grant_group_keyword_yes", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT ON m_grant_namespace.source TO GROUP m_b04_role_existing WITH GRANT OPTION;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_table_f062947d0bb7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_two", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_yes", "table_privilege": "m_grant_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT SELECT ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_grant_table_996ef3dbaad7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_privilege": "m_grant_column_privilege_select", "grant_option": "m_grant_grant_option_none", "group_keyword": "m_grant_group_keyword_none", "recipients": "m_grant_recipients_one", "scope": "m_grant_scope_table", "table_keyword": "m_grant_table_keyword_none", "table_privilege": "m_grant_table_privilege_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_grant_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant_fact_schema_usage"], "key": "schema_usage"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
GRANT UPDATE ON m_grant_namespace.source TO m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
