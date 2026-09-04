-- generated_from: manifest_alter_table_rename_constraint_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_alter_table_rename_constraint_positive_40ac8f804d53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_4f2a106afe25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_358f4eb26dcd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE IF EXISTS ONLY t_at_regular RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_6d14f8fe7100
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE OFFLINE ONLY (t_at_regular) RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_18357c1b990f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_e760750ecbf9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE IF EXISTS ONLY (t_at_regular) RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_40982542f36f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE OFFLINE ONLY t_at_regular RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_constraint_positive_754665237229
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_constraint", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular RENAME CONSTRAINT ck_at_amount_nonnegative TO ck_at_amount_renamed;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
