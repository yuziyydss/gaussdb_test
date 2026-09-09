-- generated_from: manifest_m_alter_default_privileges_grant_tables
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_default_privileges_grant_tables_66c9eac176e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_grant", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_select", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT ON TABLES TO m_b04_role_existing;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_grant_tables_c5d92c7f28c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_grant", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_yes", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_insert", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT INSERT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_grant_tables_d62d4bdbae5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_grant", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_yes", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_select", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_grant_tables_e9bde6e14d20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_grant", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_insert", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT INSERT ON TABLES TO m_b04_role_existing;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
