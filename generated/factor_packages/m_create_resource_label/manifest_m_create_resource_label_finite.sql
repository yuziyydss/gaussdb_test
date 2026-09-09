-- generated_from: manifest_m_create_resource_label_finite
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_resource_label_finite_37eb24a4484e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_none", "resources": "m_create_resource_label_resources_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL m_create_resource_label_new ADD TABLE (m_label_namespace.source);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_8ebeaf94b5ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_yes", "resources": "m_create_resource_label_resources_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS m_create_resource_label_new ADD TABLE (m_label_namespace.source);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_251b6291a803
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_none", "resources": "m_create_resource_label_resources_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL m_create_resource_label_new ADD COLUMN (m_label_namespace.source.qty);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_4db925744bb8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_yes", "resources": "m_create_resource_label_resources_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS m_create_resource_label_new ADD COLUMN (m_label_namespace.source.qty);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_30a2a1d7baa6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_none", "resources": "m_create_resource_label_resources_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL m_create_resource_label_new ADD SCHEMA (m_label_namespace);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_74b407f6ea0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_yes", "resources": "m_create_resource_label_resources_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS m_create_resource_label_new ADD SCHEMA (m_label_namespace);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_729c7784cec9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_none", "resources": "m_create_resource_label_resources_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL m_create_resource_label_new ADD VIEW (m_label_namespace.source_view);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_3d51cfbff0ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_yes", "resources": "m_create_resource_label_resources_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS m_create_resource_label_new ADD VIEW (m_label_namespace.source_view);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_885eaeb6028f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_none", "resources": "m_create_resource_label_resources_columns"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL m_create_resource_label_new ADD COLUMN (m_label_namespace.source.id, m_label_namespace.source.qty);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_3c92fedad93f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_yes", "resources": "m_create_resource_label_resources_columns"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS m_create_resource_label_new ADD COLUMN (m_label_namespace.source.id, m_label_namespace.source.qty);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_dd97771dde97
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_none", "resources": "m_create_resource_label_resources_mixed"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL m_create_resource_label_new ADD TABLE (m_label_namespace.source), VIEW (m_label_namespace.source_view);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;

-- case_id: manifest_m_create_resource_label_finite_1274b6a691d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_resource_label_if_not_exists_yes", "resources": "m_create_resource_label_resources_mixed"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_resource_label_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_resource_label_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_label_namespace;
CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);
CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;
-- test_sql:
CREATE RESOURCE LABEL IF NOT EXISTS m_create_resource_label_new ADD TABLE (m_label_namespace.source), VIEW (m_label_namespace.source_view);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;
DROP VIEW m_label_namespace.source_view;
DROP TABLE m_label_namespace.source;
DROP SCHEMA m_label_namespace;
