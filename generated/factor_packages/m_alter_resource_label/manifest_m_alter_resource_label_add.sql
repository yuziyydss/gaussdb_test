-- generated_from: manifest_m_alter_resource_label_add
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_resource_label_add_8bedd29f10b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_resource_label_action_add", "resources": "m_alter_resource_label_resources_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_alter_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_alter_resource_label_existing ADD COLUMN (m_label_namespace.source.id);
-- test_sql:
ALTER RESOURCE LABEL m_alter_resource_label_existing ADD TABLE (m_label_namespace.source);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_alter_resource_label_existing;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_alter_resource_label_add_f0148ab0c5e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_resource_label_action_add", "resources": "m_alter_resource_label_resources_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_alter_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_alter_resource_label_existing ADD COLUMN (m_label_namespace.source.id);
-- test_sql:
ALTER RESOURCE LABEL m_alter_resource_label_existing ADD COLUMN (m_label_namespace.source.qty);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_alter_resource_label_existing;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_alter_resource_label_add_b3a7d3e7541e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_resource_label_action_add", "resources": "m_alter_resource_label_resources_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_alter_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_alter_resource_label_existing ADD COLUMN (m_label_namespace.source.id);
-- test_sql:
ALTER RESOURCE LABEL m_alter_resource_label_existing ADD SCHEMA (m_label_namespace);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_alter_resource_label_existing;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_alter_resource_label_add_d3da2ad36e17
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_resource_label_action_add", "resources": "m_alter_resource_label_resources_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_alter_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
CREATE RESOURCE LABEL m_alter_resource_label_existing ADD COLUMN (m_label_namespace.source.id);
-- test_sql:
ALTER RESOURCE LABEL m_alter_resource_label_existing ADD VIEW (m_label_namespace.source_view);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_alter_resource_label_existing;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;
