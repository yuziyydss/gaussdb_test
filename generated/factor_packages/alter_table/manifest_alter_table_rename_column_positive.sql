-- generated_from: manifest_alter_table_rename_column_positive
-- static_only: true
-- case_count: 9

-- case_id: manifest_alter_table_rename_column_positive_9262d87b1996
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword_none", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular RENAME code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_148470217df2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * RENAME COLUMN code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_cef4467eefa4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular RENAME COLUMN code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_493309967b31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword_none", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE IF EXISTS ONLY (t_at_regular) RENAME code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_f2166ee6253c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword_none", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE t_at_regular * RENAME code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_012dd8e59201
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE OFFLINE ONLY (t_at_regular) RENAME COLUMN code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_e0e78b6e6ca7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular RENAME COLUMN code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_a0c82029656b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword_none", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE OFFLINE IF EXISTS ONLY t_at_regular RENAME code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_rename_column_positive_b901ca40d2be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword_none", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_rename_column", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * RENAME code TO code_new;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
