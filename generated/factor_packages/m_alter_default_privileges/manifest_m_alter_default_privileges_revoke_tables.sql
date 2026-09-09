-- generated_from: manifest_m_alter_default_privileges_revoke_tables
-- static_only: true
-- case_count: 5

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_default_privileges_revoke_tables_e65bcb120858
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_revoke", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_select", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT, INSERT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE SELECT ON TABLES FROM m_b04_role_existing;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_revoke_tables_dbe21227b216
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_revoke", "behavior": "m_alter_default_privileges_behavior_restrict", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_insert", "revoke_option": "m_alter_default_privileges_revoke_option_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT, INSERT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE GRANT OPTION FOR INSERT ON TABLES FROM m_b04_role_existing RESTRICT;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_revoke_tables_eb59d6ddd652
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_revoke", "behavior": "m_alter_default_privileges_behavior_restrict", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_select", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT, INSERT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE SELECT ON TABLES FROM m_b04_role_existing RESTRICT;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_revoke_tables_9d14e658c2d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_revoke", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_select", "revoke_option": "m_alter_default_privileges_revoke_option_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT, INSERT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE GRANT OPTION FOR SELECT ON TABLES FROM m_b04_role_existing;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_alter_default_privileges_revoke_tables_73ebe8076a3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_default_privileges_action_revoke", "behavior": "m_alter_default_privileges_behavior_default", "grant_option": "m_alter_default_privileges_grant_option_none", "object": "m_alter_default_privileges_object_tables", "privilege": "m_alter_default_privileges_privilege_insert", "revoke_option": "m_alter_default_privileges_revoke_option_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_default_privileges_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["same_schema_creating_session"], "fact_refs": ["m_alter_default_privileges_fact_owner", "m_alter_default_privileges_fact_schema"], "key": "default_acl_creator"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_default_privilege_namespace;
GRANT USAGE ON SCHEMA m_default_privilege_namespace TO m_b04_role_existing;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT SELECT, INSERT ON TABLES TO m_b04_role_existing WITH GRANT OPTION;
-- test_sql:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE INSERT ON TABLES FROM m_b04_role_existing;
-- fixture_teardown:
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES FROM m_b04_role_existing RESTRICT;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES FROM m_b04_role_existing RESTRICT;
DROP SCHEMA m_default_privilege_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
