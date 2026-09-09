-- generated_from: manifest_m_alter_table_add_position_fresh
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_table_add_position_fresh_4a074742e8b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_add_position_fresh", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_first", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["new_case_table_creator"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "source_creation_authority"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_at_add_position (id INTEGER,qty INTEGER,note INTEGER);
INSERT INTO m_at_add_position VALUES (1,10,100),(2,20,200);
-- test_sql:
ALTER TABLE m_at_add_position ADD extra INTEGER FIRST;
-- fixture_teardown:
DROP TABLE m_at_add_position;

-- case_id: manifest_m_alter_table_add_position_fresh_43ae584867ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_yes", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_add_position_fresh", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_after", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["new_case_table_creator"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "source_creation_authority"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_at_add_position (id INTEGER,qty INTEGER,note INTEGER);
INSERT INTO m_at_add_position VALUES (1,10,100),(2,20,200);
-- test_sql:
ALTER TABLE m_at_add_position ADD COLUMN extra INTEGER AFTER id;
-- fixture_teardown:
DROP TABLE m_at_add_position;

-- case_id: manifest_m_alter_table_add_position_fresh_76d8d809e2fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_none", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_add_position_fresh", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_after", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["new_case_table_creator"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "source_creation_authority"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_at_add_position (id INTEGER,qty INTEGER,note INTEGER);
INSERT INTO m_at_add_position VALUES (1,10,100),(2,20,200);
-- test_sql:
ALTER TABLE m_at_add_position ADD extra INTEGER AFTER id;
-- fixture_teardown:
DROP TABLE m_at_add_position;

-- case_id: manifest_m_alter_table_add_position_fresh_ae5074e2dcdd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_alter_table_column_yes", "constraint_action": "m_alter_table_constraint_action_not_null", "default_action": "m_alter_table_default_action_set", "equals": "m_alter_table_equals_none", "form": "m_alter_table_form_add_position_fresh", "if_exists": "m_alter_table_if_exists_none", "position": "m_alter_table_position_first", "rename_keyword": "m_alter_table_rename_keyword_none", "storage_action": "m_alter_table_storage_action_low"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["new_case_table_creator"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "source_creation_authority"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_at_add_position (id INTEGER,qty INTEGER,note INTEGER);
INSERT INTO m_at_add_position VALUES (1,10,100),(2,20,200);
-- test_sql:
ALTER TABLE m_at_add_position ADD COLUMN extra INTEGER FIRST;
-- fixture_teardown:
DROP TABLE m_at_add_position;
