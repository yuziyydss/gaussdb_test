-- generated_from: manifest_m_alter_table_modify
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_table_modify_09d2fd69c1a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_modify", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_none", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
-- test_sql:
ALTER TABLE m_alter_table_namespace.source MODIFY qty BIGINT DEFAULT 9;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;

-- case_id: manifest_m_alter_table_modify_06898b56d627
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_yes", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_modify", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_first", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
-- test_sql:
ALTER TABLE m_alter_table_namespace.source MODIFY COLUMN qty BIGINT DEFAULT 9 FIRST;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;

-- case_id: manifest_m_alter_table_modify_3a10c08d1e0a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_modify", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_after", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
-- test_sql:
ALTER TABLE m_alter_table_namespace.source MODIFY qty BIGINT DEFAULT 9 AFTER id;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;

-- case_id: manifest_m_alter_table_modify_f2e723db2339
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_modify", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_first", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
-- test_sql:
ALTER TABLE m_alter_table_namespace.source MODIFY qty BIGINT DEFAULT 9 FIRST;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;

-- case_id: manifest_m_alter_table_modify_dc3caa9d452a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_yes", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_modify", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_none", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
-- test_sql:
ALTER TABLE m_alter_table_namespace.source MODIFY COLUMN qty BIGINT DEFAULT 9;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;

-- case_id: manifest_m_alter_table_modify_17ad4d9e7ead
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_yes", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_modify", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_after", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE SCHEMA m_alter_table_namespace;
CREATE TABLE m_alter_table_namespace.source (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);
INSERT INTO m_alter_table_namespace.source VALUES (1,10),(2,20);
-- test_sql:
ALTER TABLE m_alter_table_namespace.source MODIFY COLUMN qty BIGINT DEFAULT 9 AFTER id;
-- fixture_teardown:
DROP TABLE IF EXISTS m_alter_table_namespace.source PURGE;
DROP TABLE IF EXISTS m_alter_table_namespace.renamed PURGE;
DROP SCHEMA m_alter_table_namespace;
