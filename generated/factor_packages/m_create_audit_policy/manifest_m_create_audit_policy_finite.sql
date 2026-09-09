-- generated_from: manifest_m_create_audit_policy_finite
-- static_only: true
-- case_count: 16

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_audit_policy_finite_cb32002a5b3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_none", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_alter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new PRIVILEGES ALTER ON LABEL (m_b05_audit_label);
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_6b745c8f6d0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_enable", "filter": "m_create_audit_policy_filter_ip", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_analyze"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new PRIVILEGES ANALYZE ON LABEL (m_b05_audit_label) FILTER ON IP('127.0.0.1') ENABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_26014b0af323
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_disable", "filter": "m_create_audit_policy_filter_app", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new ACCESS SELECT ON LABEL (m_b05_audit_label) FILTER ON APP(gsql) DISABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_d9a12530381b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_disable", "filter": "m_create_audit_policy_filter_ip", "if_not_exists": "m_create_audit_policy_if_not_exists_yes", "operation": "m_create_audit_policy_operation_alter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS m_create_audit_policy_new PRIVILEGES ALTER ON LABEL (m_b05_audit_label) FILTER ON IP('127.0.0.1') DISABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_75082e405ae4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_app", "if_not_exists": "m_create_audit_policy_if_not_exists_yes", "operation": "m_create_audit_policy_operation_analyze"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS m_create_audit_policy_new PRIVILEGES ANALYZE ON LABEL (m_b05_audit_label) FILTER ON APP(gsql);
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_956fc2e3318e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_enable", "filter": "m_create_audit_policy_filter_none", "if_not_exists": "m_create_audit_policy_if_not_exists_yes", "operation": "m_create_audit_policy_operation_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS m_create_audit_policy_new ACCESS SELECT ON LABEL (m_b05_audit_label) ENABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_09a695928ada
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_combined", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new ACCESS UPDATE ON LABEL (m_b05_audit_label) FILTER ON APP(gsql), IP('127.0.0.1', '127.0.0.0/24');
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_4ab0bb844074
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_enable", "filter": "m_create_audit_policy_filter_combined", "if_not_exists": "m_create_audit_policy_if_not_exists_yes", "operation": "m_create_audit_policy_operation_alter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS m_create_audit_policy_new PRIVILEGES ALTER ON LABEL (m_b05_audit_label) FILTER ON APP(gsql), IP('127.0.0.1', '127.0.0.0/24') ENABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_db6741bbe8b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_disable", "filter": "m_create_audit_policy_filter_none", "if_not_exists": "m_create_audit_policy_if_not_exists_yes", "operation": "m_create_audit_policy_operation_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY IF NOT EXISTS m_create_audit_policy_new ACCESS UPDATE ON LABEL (m_b05_audit_label) DISABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_d1b4a902cbf3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_disable", "filter": "m_create_audit_policy_filter_combined", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_analyze"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new PRIVILEGES ANALYZE ON LABEL (m_b05_audit_label) FILTER ON APP(gsql), IP('127.0.0.1', '127.0.0.0/24') DISABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_4ab4025f8f31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_ip", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new ACCESS SELECT ON LABEL (m_b05_audit_label) FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_eaf595c70c44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_enable", "filter": "m_create_audit_policy_filter_app", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new ACCESS UPDATE ON LABEL (m_b05_audit_label) FILTER ON APP(gsql) ENABLE;
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_d7d0bfb82a32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_app", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_alter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new PRIVILEGES ALTER ON LABEL (m_b05_audit_label) FILTER ON APP(gsql);
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_1cd362e0c501
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_none", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_analyze"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new PRIVILEGES ANALYZE ON LABEL (m_b05_audit_label);
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_87e4006166e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_combined", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new ACCESS SELECT ON LABEL (m_b05_audit_label) FILTER ON APP(gsql), IP('127.0.0.1', '127.0.0.0/24');
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_audit_policy_finite_063a455cb742
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"enabled": "m_create_audit_policy_enabled_default", "filter": "m_create_audit_policy_filter_ip", "if_not_exists": "m_create_audit_policy_if_not_exists_none", "operation": "m_create_audit_policy_operation_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_audit_policy_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_audit_policy_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["on"], "fact_refs": ["m_create_audit_policy_fact_security_on"], "key": "enable_security_policy"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_b05_audit_label ADD TABLE (m_label_namespace.source);
-- test_sql:
CREATE AUDIT POLICY m_create_audit_policy_new ACCESS UPDATE ON LABEL (m_b05_audit_label) FILTER ON IP('127.0.0.1');
-- fixture_teardown:
DROP AUDIT POLICY IF EXISTS m_create_audit_policy_new;
DROP RESOURCE LABEL IF EXISTS m_b05_audit_label;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;
