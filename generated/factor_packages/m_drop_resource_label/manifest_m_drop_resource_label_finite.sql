-- generated_from: manifest_m_drop_resource_label_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_resource_label_finite_e825338056ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_resource_label_if_exists_none", "targets": "m_drop_resource_label_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_drop_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_drop_resource_label_one ADD TABLE (m_label_namespace.source);
CREATE RESOURCE LABEL m_drop_resource_label_two ADD VIEW (m_label_namespace.source_view);
-- test_sql:
DROP RESOURCE LABEL m_drop_resource_label_one;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_two;
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_one;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_drop_resource_label_finite_89b7187dd64a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_resource_label_if_exists_none", "targets": "m_drop_resource_label_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_drop_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_drop_resource_label_one ADD TABLE (m_label_namespace.source);
CREATE RESOURCE LABEL m_drop_resource_label_two ADD VIEW (m_label_namespace.source_view);
-- test_sql:
DROP RESOURCE LABEL m_drop_resource_label_one, m_drop_resource_label_two;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_two;
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_one;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_drop_resource_label_finite_f061dba16dd9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_resource_label_if_exists_yes", "targets": "m_drop_resource_label_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_drop_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_drop_resource_label_one ADD TABLE (m_label_namespace.source);
CREATE RESOURCE LABEL m_drop_resource_label_two ADD VIEW (m_label_namespace.source_view);
-- test_sql:
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_one;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_two;
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_one;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_drop_resource_label_finite_2c19e4fb90b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_resource_label_if_exists_yes", "targets": "m_drop_resource_label_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_drop_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_drop_resource_label_one ADD TABLE (m_label_namespace.source);
CREATE RESOURCE LABEL m_drop_resource_label_two ADD VIEW (m_label_namespace.source_view);
-- test_sql:
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_one, m_drop_resource_label_two;
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_two;
DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_one;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;
