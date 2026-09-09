-- generated_from: manifest_m_alter_table_schema
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_table_schema_c1e6de6514dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_schema", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_none", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["new_case_schema_creator"], "fact_refs": ["m_alter_table_fact_schema_authority"], "key": "destination_schema_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
CREATE SCHEMA m_alter_table_destination;
-- test_sql:
ALTER TABLE m_alter_table_namespace.source SET SCHEMA m_alter_table_destination;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_destination.source PURGE;
DROP SCHEMA m_alter_table_destination;
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;

-- case_id: manifest_m_alter_table_schema_fedf392afe77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_schema", "if_exists": "m_alter_table_if_exists_yes", "position": "m_alter_table_position_none", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}, {"allowed_values": ["new_case_schema_creator"], "fact_refs": ["m_alter_table_fact_schema_authority"], "key": "destination_schema_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
CREATE SCHEMA m_alter_table_destination;
-- test_sql:
ALTER TABLE IF EXISTS m_alter_table_namespace.source SET SCHEMA m_alter_table_destination;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_destination.source PURGE;
DROP SCHEMA m_alter_table_destination;
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;
