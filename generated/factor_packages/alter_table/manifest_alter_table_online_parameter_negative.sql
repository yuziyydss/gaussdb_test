-- generated_from: manifest_alter_table_online_parameter_negative
-- static_only: true
-- case_count: 3

-- case_id: manifest_alter_table_online_parameter_negative_5ec944bf2770
-- expected: error
-- expected_error_category: invalid_online_parameter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_online_parallel0", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["at_fact_online_environment"], "key": "transaction_context"}, {"allowed_values": ["outside_procedure"], "fact_refs": ["at_fact_online_environment"], "key": "stored_procedure_context"}, {"allowed_values": ["supported"], "fact_refs": ["at_fact_online_environment"], "key": "online_ddl_compatibility"}, {"allowed_values": ["inactive"], "fact_refs": ["at_fact_online_environment"], "key": "upgrade_observation_period"}, {"allowed_values": ["sufficient"], "fact_refs": ["at_fact_online_environment"], "key": "disk_space"}, {"allowed_values": ["absent"], "fact_refs": ["at_fact_online_environment"], "key": "long_transaction"}]
-- fixture_setup:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
CREATE SCHEMA at_target_schema;
CREATE SEQUENCE at_seq;
CREATE TABLE t_at_regular (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64) DEFAULT 'n/a', amount INTEGER NOT NULL, required_later INTEGER, identity_text VARCHAR(32) NOT NULL, created_at TIMESTAMP);
CREATE UNIQUE INDEX uq_at_code ON t_at_regular (code);
CREATE INDEX idx_at_id ON t_at_regular (id);
ALTER TABLE t_at_regular ADD CONSTRAINT ck_at_amount_nonnegative CHECK (amount >= 0) NOT VALID;
INSERT INTO t_at_regular (id, code, note, amount, required_later, identity_text) VALUES (1, 'A001', 'alpha', 10, 100, 'text_1'), (2, 'A002', 'beta', 20, 200, 'text_2');
-- test_sql:
ALTER TABLE ONLINE WITH (parallel_threads = 0) t_at_regular ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_online_parameter_negative_42861f458539
-- expected: error
-- expected_error_category: invalid_online_parameter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_online_parallel33", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["at_fact_online_environment"], "key": "transaction_context"}, {"allowed_values": ["outside_procedure"], "fact_refs": ["at_fact_online_environment"], "key": "stored_procedure_context"}, {"allowed_values": ["supported"], "fact_refs": ["at_fact_online_environment"], "key": "online_ddl_compatibility"}, {"allowed_values": ["inactive"], "fact_refs": ["at_fact_online_environment"], "key": "upgrade_observation_period"}, {"allowed_values": ["sufficient"], "fact_refs": ["at_fact_online_environment"], "key": "disk_space"}, {"allowed_values": ["absent"], "fact_refs": ["at_fact_online_environment"], "key": "long_transaction"}]
-- fixture_setup:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
CREATE SCHEMA at_target_schema;
CREATE SEQUENCE at_seq;
CREATE TABLE t_at_regular (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64) DEFAULT 'n/a', amount INTEGER NOT NULL, required_later INTEGER, identity_text VARCHAR(32) NOT NULL, created_at TIMESTAMP);
CREATE UNIQUE INDEX uq_at_code ON t_at_regular (code);
CREATE INDEX idx_at_id ON t_at_regular (id);
ALTER TABLE t_at_regular ADD CONSTRAINT ck_at_amount_nonnegative CHECK (amount >= 0) NOT VALID;
INSERT INTO t_at_regular (id, code, note, amount, required_later, identity_text) VALUES (1, 'A001', 'alpha', 10, 100, 'text_1'), (2, 'A002', 'beta', 20, 200, 'text_2');
-- test_sql:
ALTER TABLE ONLINE WITH (parallel_threads = 33) t_at_regular ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_online_parameter_negative_9fa78d495499
-- expected: error
-- expected_error_category: invalid_online_parameter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_online_catchup51", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["outside_transaction"], "fact_refs": ["at_fact_online_environment"], "key": "transaction_context"}, {"allowed_values": ["outside_procedure"], "fact_refs": ["at_fact_online_environment"], "key": "stored_procedure_context"}, {"allowed_values": ["supported"], "fact_refs": ["at_fact_online_environment"], "key": "online_ddl_compatibility"}, {"allowed_values": ["inactive"], "fact_refs": ["at_fact_online_environment"], "key": "upgrade_observation_period"}, {"allowed_values": ["sufficient"], "fact_refs": ["at_fact_online_environment"], "key": "disk_space"}, {"allowed_values": ["absent"], "fact_refs": ["at_fact_online_environment"], "key": "long_transaction"}]
-- fixture_setup:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
CREATE SCHEMA at_target_schema;
CREATE SEQUENCE at_seq;
CREATE TABLE t_at_regular (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64) DEFAULT 'n/a', amount INTEGER NOT NULL, required_later INTEGER, identity_text VARCHAR(32) NOT NULL, created_at TIMESTAMP);
CREATE UNIQUE INDEX uq_at_code ON t_at_regular (code);
CREATE INDEX idx_at_id ON t_at_regular (id);
ALTER TABLE t_at_regular ADD CONSTRAINT ck_at_amount_nonnegative CHECK (amount >= 0) NOT VALID;
INSERT INTO t_at_regular (id, code, note, amount, required_later, identity_text) VALUES (1, 'A001', 'alpha', 10, 100, 'text_1'), (2, 'A002', 'beta', 20, 200, 'text_2');
-- test_sql:
ALTER TABLE ONLINE WITH (max_catchup_times = 51) t_at_regular ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
