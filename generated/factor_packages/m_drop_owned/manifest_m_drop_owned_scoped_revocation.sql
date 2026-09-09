-- generated_from: manifest_m_drop_owned_scoped_revocation
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_owned_scoped_revocation_07bceeef2052
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_owned_behavior_default", "roles": "m_drop_owned_roles_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_owned_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fresh_case_roles_no_external_ownership_or_grants"], "fact_refs": ["m_drop_owned_fact_scope"], "key": "drop_owned_target_isolation"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_drop_owned_namespace;
CREATE TABLE m_drop_owned_namespace.source (id INTEGER);
INSERT INTO m_drop_owned_namespace.source VALUES (1);
GRANT USAGE ON SCHEMA m_drop_owned_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT ON TABLE m_drop_owned_namespace.source TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
DROP OWNED BY m_b04_role_existing;
-- fixture_teardown:
DROP TABLE m_drop_owned_namespace.source;
DROP SCHEMA m_drop_owned_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_drop_owned_scoped_revocation_448dfced0183
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_owned_behavior_restrict", "roles": "m_drop_owned_roles_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_owned_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fresh_case_roles_no_external_ownership_or_grants"], "fact_refs": ["m_drop_owned_fact_scope"], "key": "drop_owned_target_isolation"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_drop_owned_namespace;
CREATE TABLE m_drop_owned_namespace.source (id INTEGER);
INSERT INTO m_drop_owned_namespace.source VALUES (1);
GRANT USAGE ON SCHEMA m_drop_owned_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT ON TABLE m_drop_owned_namespace.source TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
DROP OWNED BY m_b04_role_existing RESTRICT;
-- fixture_teardown:
DROP TABLE m_drop_owned_namespace.source;
DROP SCHEMA m_drop_owned_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_drop_owned_scoped_revocation_a3f8cb33efeb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_owned_behavior_default", "roles": "m_drop_owned_roles_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_owned_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fresh_case_roles_no_external_ownership_or_grants"], "fact_refs": ["m_drop_owned_fact_scope"], "key": "drop_owned_target_isolation"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_drop_owned_namespace;
CREATE TABLE m_drop_owned_namespace.source (id INTEGER);
INSERT INTO m_drop_owned_namespace.source VALUES (1);
GRANT USAGE ON SCHEMA m_drop_owned_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT ON TABLE m_drop_owned_namespace.source TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
DROP OWNED BY m_b04_role_existing, m_b04_role_second;
-- fixture_teardown:
DROP TABLE m_drop_owned_namespace.source;
DROP SCHEMA m_drop_owned_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;

-- case_id: manifest_m_drop_owned_scoped_revocation_1f54fb389e48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_owned_behavior_restrict", "roles": "m_drop_owned_roles_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_owned_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fresh_case_roles_no_external_ownership_or_grants"], "fact_refs": ["m_drop_owned_fact_scope"], "key": "drop_owned_target_isolation"}]
-- fixture_setup:
CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_b04_role_second NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE SCHEMA m_drop_owned_namespace;
CREATE TABLE m_drop_owned_namespace.source (id INTEGER);
INSERT INTO m_drop_owned_namespace.source VALUES (1);
GRANT USAGE ON SCHEMA m_drop_owned_namespace TO m_b04_role_existing, m_b04_role_second;
GRANT SELECT ON TABLE m_drop_owned_namespace.source TO m_b04_role_existing, m_b04_role_second;
-- test_sql:
DROP OWNED BY m_b04_role_existing, m_b04_role_second RESTRICT;
-- fixture_teardown:
DROP TABLE m_drop_owned_namespace.source;
DROP SCHEMA m_drop_owned_namespace;
DROP ROLE IF EXISTS m_b04_role_second;
DROP ROLE IF EXISTS m_b04_role_existing;
