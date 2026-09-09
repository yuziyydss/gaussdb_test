-- generated_from: manifest_m_revoke_columns
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_revoke_columns_a9e36c2e275a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_select", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (id) ON m_grant_namespace.source FROM m_b04_role_existing;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_37cef731627b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_restrict", "column_privilege": "m_revoke_column_privilege_update", "grant_option": "m_revoke_grant_option_yes", "group_keyword": "m_revoke_group_keyword_yes", "recipients": "m_revoke_recipients_two", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_yes", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR UPDATE (qty) ON TABLE m_grant_namespace.source FROM GROUP m_b04_role_existing, m_b04_role_second RESTRICT;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_64aa5ebf73d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_restrict", "column_privilege": "m_revoke_column_privilege_both_columns", "grant_option": "m_revoke_grant_option_yes", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT (id, qty) ON m_grant_namespace.source FROM m_b04_role_existing RESTRICT;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_19e25d5fe442
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_mixed", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_yes", "recipients": "m_revoke_recipients_two", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (id), UPDATE (qty) ON m_grant_namespace.source FROM GROUP m_b04_role_existing, m_b04_role_second;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_86fed566a5b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_update", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_yes", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE UPDATE (qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_057b0c6347c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_restrict", "column_privilege": "m_revoke_column_privilege_select", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_two", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_yes", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (id) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_a02847365142
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_both_columns", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_yes", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_yes", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (id, qty) ON TABLE m_grant_namespace.source FROM GROUP m_b04_role_existing;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_979a800b8841
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_mixed", "grant_option": "m_revoke_grant_option_yes", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_yes", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT (id), UPDATE (qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_f0a93c44e0f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_select", "grant_option": "m_revoke_grant_option_yes", "group_keyword": "m_revoke_group_keyword_yes", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE GRANT OPTION FOR SELECT (id) ON m_grant_namespace.source FROM GROUP m_b04_role_existing;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_4fc0e72168e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_update", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE UPDATE (qty) ON m_grant_namespace.source FROM m_b04_role_existing;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_20c097ba0845
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_default", "column_privilege": "m_revoke_column_privilege_both_columns", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_two", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (id, qty) ON m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_revoke_columns_adaee7ad1d65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_revoke_behavior_restrict", "column_privilege": "m_revoke_column_privilege_mixed", "grant_option": "m_revoke_grant_option_none", "group_keyword": "m_revoke_group_keyword_none", "recipients": "m_revoke_recipients_one", "scope": "m_revoke_scope_columns", "table_keyword": "m_revoke_table_keyword_none", "table_privilege": "m_revoke_table_privilege_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_revoke_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_grant::m_grant_fact_owner"], "key": "object_authority"}, {"allowed_values": ["fixture_granted"], "fact_refs": ["m_grant::m_grant_fact_schema_usage"], "key": "schema_usage"}, {"allowed_values": ["same_setup_and_target_session"], "fact_refs": ["m_revoke_fact_grantor"], "key": "grantor_identity"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_grant_namespace;
CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);
GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;
-- test_sql:
REVOKE SELECT (id), UPDATE (qty) ON m_grant_namespace.source FROM m_b04_role_existing RESTRICT;
-- fixture_teardown:
REVOKE SELECT (id, qty), UPDATE (id, qty) ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;
DROP TABLE m_grant_namespace.source;
DROP SCHEMA m_grant_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
