-- generated_from: manifest_m_alter_audit_policy_drop_filter
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_audit_policy_drop_filter_07773566f7f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_audit_policy_change_drop_filter", "if_exists": "m_alter_audit_policy_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_alter_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_alter_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
CREATE AUDIT POLICY m_alter_audit_policy_existing PRIVILEGES CREATE ON LABEL (m_b05_audit_label) FILTER ON IP('127.0.0.1') DISABLE;
-- test_sql:
ALTER AUDIT POLICY m_alter_audit_policy_existing DROP FILTER;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_alter_audit_policy_existing;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_alter_audit_policy_drop_filter_a1f90ae00564
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_audit_policy_change_drop_filter", "if_exists": "m_alter_audit_policy_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_alter_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_alter_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
CREATE AUDIT POLICY m_alter_audit_policy_existing PRIVILEGES CREATE ON LABEL (m_b05_audit_label) FILTER ON IP('127.0.0.1') DISABLE;
-- test_sql:
ALTER AUDIT POLICY IF EXISTS m_alter_audit_policy_existing DROP FILTER;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_alter_audit_policy_existing;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;
