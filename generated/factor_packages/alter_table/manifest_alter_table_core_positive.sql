-- generated_from: manifest_alter_table_core_positive
-- static_only: true
-- case_count: 188

-- case_id: manifest_alter_table_core_positive_0c53994e6df4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_38e59eb16c5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_e71171db18f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_if_not_exists", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE IF EXISTS ONLY t_at_regular ADD COLUMN IF NOT EXISTS extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f7d14f8374fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE OFFLINE ONLY (t_at_regular) ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4a834c22b37f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_18283524c2f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE IF EXISTS ONLY (t_at_regular) ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f31f271e5558
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE OFFLINE ONLY t_at_regular ALTER COLUMN amount TYPE BIGINT USING amount::BIGINT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_73d01b9e8d56
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0627db943999
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN note DROP DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_8b042275b577
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN required_later SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f607b1046584
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount DROP NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_bb9d5630aeae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_37675bc17a6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_10000", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_fef94a440a9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount SET STATISTICS -1;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_dda7d09709f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_percent", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount SET STATISTICS PERCENT 100;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_e719c4ce2ca7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((id, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_8ca75d9c21aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_delete_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE t_at_regular DELETE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_5f7108300134
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE t_at_regular DISABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4b4b0f010f61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE t_at_regular ENABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_da5286c5a508
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount SET (n_distinct = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c5542ec3054f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN amount RESET (n_distinct);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_dbce297b95e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_6f9a5f0d034b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_external", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN note SET STORAGE EXTERNAL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_069008352dca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_extended", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN note SET STORAGE EXTENDED;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_11d5b7786961
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_main", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN note SET STORAGE MAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_00b493b0bce7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD CONSTRAINT ck_at_amount_upper CHECK (amount < 10000);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4ad5c9d74756
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check_not_valid", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD CONSTRAINT ck_at_amount_limit CHECK (amount < 5000) NOT VALID;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f39f24f127d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD CONSTRAINT uq_at_note UNIQUE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_5f2583973feb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_primary", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD CONSTRAINT pk_at_id PRIMARY KEY (id);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_e4917fa5de55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_validate_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular VALIDATE CONSTRAINT ck_at_amount_nonnegative;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b6b2661bd192
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_constraint", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular DROP CONSTRAINT IF EXISTS ck_at_amount_nonnegative RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_3354ec7f5fc9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_primary_using_index", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD CONSTRAINT pk_at_code PRIMARY KEY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_395e0ff3b77d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_cluster_on", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular CLUSTER ON idx_at_id;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_ab229cb19710
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_without_cluster", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular SET WITHOUT CLUSTER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_82103b8ca838
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular SET (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0b9f7adb836e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular RESET (fillfactor);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_2615f2d0db99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_2c0e6bb9bfec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_1495572ed80e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_3f50f65ed024
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_no_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular NO FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_3187d14f1441
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_9d4cdfa66272
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_full", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_48d5e69b24e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_nothing", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_10bd47cd7279
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular REPLICA IDENTITY UNIQUE;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b213b8ffd3f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular REPLICA IDENTITY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_53750dccdce2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_identity", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c7ba37b913a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_multiple", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD COLUMN extra_one INTEGER, ADD COLUMN extra_two INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_86d0b30f87d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE t_at_regular ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_9fa653ec219f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_29ddf5a5e5bd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE IF EXISTS t_at_regular ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_40e147ee744f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE IF EXISTS t_at_regular ALTER COLUMN amount TYPE BIGINT USING amount::BIGINT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0586bdd33c38
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_if_not_exists", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE OFFLINE t_at_regular ADD COLUMN IF NOT EXISTS extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_59ff103a080d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE OFFLINE t_at_regular ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_328d1b76b5aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_00c0a77cbd53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_bc15d0826870
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN note DROP DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_ce4f362653dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN required_later SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_5350f9416b7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount DROP NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b90ee386206a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b401d74481cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_10000", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_2ce782977dfb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount SET STATISTICS -1;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4551601819c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_percent", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount SET STATISTICS PERCENT 100;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_77697c170525
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD STATISTICS ((id, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_39829c68d122
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_delete_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_regular * DELETE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_a1dcf23fd609
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_regular * DISABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d4aa79b72b5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ENABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_ff3a81d781ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount SET (n_distinct = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_a79882662991
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN amount RESET (n_distinct);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_a5adfdeca1fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_38b9d250cd84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_external", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN note SET STORAGE EXTERNAL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_71e9db2e5593
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_extended", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN note SET STORAGE EXTENDED;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_6fb8438afa93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_main", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN note SET STORAGE MAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_593c07bfe98b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD CONSTRAINT ck_at_amount_upper CHECK (amount < 10000);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b5311904258a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check_not_valid", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD CONSTRAINT ck_at_amount_limit CHECK (amount < 5000) NOT VALID;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_09083bdbe359
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD CONSTRAINT uq_at_note UNIQUE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_a24efb2f50c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_primary", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD CONSTRAINT pk_at_id PRIMARY KEY (id);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_ea7543319b4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_validate_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * VALIDATE CONSTRAINT ck_at_amount_nonnegative;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_19cc8ee2a912
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_constraint", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * DROP CONSTRAINT IF EXISTS ck_at_amount_nonnegative RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0b62aacc335b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_primary_using_index", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD CONSTRAINT pk_at_code PRIMARY KEY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c79f23abbf5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_cluster_on", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * CLUSTER ON idx_at_id;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_246c559c5e90
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_without_cluster", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * SET WITHOUT CLUSTER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_63734b1ae941
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * SET (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_1ec370241cf6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * RESET (fillfactor);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0322c06d074c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b254b503384b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4eba40a76c1d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_9480dd766c5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_no_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * NO FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b51cf3f4be6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_845052f71c61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_full", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_199b5f15bb9e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_nothing", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_8d88acb7d2d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * REPLICA IDENTITY UNIQUE;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_8b708a46a3f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * REPLICA IDENTITY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_5840d7e00c45
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_identity", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_2ecdce1ddc5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_multiple", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE OFFLINE IF EXISTS t_at_regular * ADD COLUMN extra_one INTEGER, ADD COLUMN extra_two INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_eaef82162ec4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_if_not_exists", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * ADD COLUMN IF NOT EXISTS extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b879361dc002
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_3f0e472e4f66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_02a9498b6e16
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_star"}
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
ALTER TABLE t_at_regular * ALTER COLUMN amount TYPE BIGINT USING amount::BIGINT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_158e2b0eebaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_01c801239a4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c236d857c8f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_5866c74271d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_de5e553269b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN note TYPE VARCHAR(96);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_932b7514116f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_fcf953f5e598
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN note DROP DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_1acee3a6a11a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN required_later SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_732d2fe09944
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount DROP NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f53e19991c60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_2d6a00801da0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_10000", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_08072f19c00a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount SET STATISTICS -1;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_78ef5baac700
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_percent", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount SET STATISTICS PERCENT 100;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_777a2104c0af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD STATISTICS ((id, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_ab395fa9b39d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_delete_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE ONLY t_at_regular DELETE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_8715df7504fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE ONLY t_at_regular DISABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d4defcb5a5b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE ONLY t_at_regular ENABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_13e75538e72e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount SET (n_distinct = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_cdf2b521812d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN amount RESET (n_distinct);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_83c782812e8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d316e1d6b571
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_external", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN note SET STORAGE EXTERNAL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_426e2889d621
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_extended", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN note SET STORAGE EXTENDED;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_225501c74cde
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_main", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN note SET STORAGE MAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d9786a48aaca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD CONSTRAINT ck_at_amount_upper CHECK (amount < 10000);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_1b1549d864fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check_not_valid", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD CONSTRAINT ck_at_amount_limit CHECK (amount < 5000) NOT VALID;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_6b9cbcc0139b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD CONSTRAINT uq_at_note UNIQUE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d6fa0b301a41
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_primary", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD CONSTRAINT pk_at_id PRIMARY KEY (id);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b1dcc04b92d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_validate_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular VALIDATE CONSTRAINT ck_at_amount_nonnegative;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_902cac370e18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_constraint", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular DROP CONSTRAINT IF EXISTS ck_at_amount_nonnegative RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b41cd7a9838c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_primary_using_index", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD CONSTRAINT pk_at_code PRIMARY KEY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_a1ac1114aa46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_cluster_on", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular CLUSTER ON idx_at_id;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0d9f939a4c84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_without_cluster", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular SET WITHOUT CLUSTER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_b6bc5e7fff83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular SET (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_cb1db78c8bdc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular RESET (fillfactor);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_26a959ac537a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_eaac09fa7e64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_9355852b0353
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_e1ed5f672689
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_no_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular NO FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_117c9aefc5cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_48c79e9fcab3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_full", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_6d426432b3b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_nothing", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_82ce9ab70dda
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular REPLICA IDENTITY UNIQUE;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_aa20909a2224
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular REPLICA IDENTITY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_423f2f323c2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_identity", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_cf5f0f7fb25b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_multiple", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only"}
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
ALTER TABLE ONLY t_at_regular ADD COLUMN extra_one INTEGER, ADD COLUMN extra_two INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0f945996fc72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_99b8734367d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d66f0e7a08f1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_if_not_exists", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD COLUMN IF NOT EXISTS extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0eb876818aa9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c69253417c3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_alter_type_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount TYPE BIGINT USING amount::BIGINT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_24f18bf67604
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4ae632c00111
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN note DROP DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_9b655d12a600
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN required_later SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_034d76ae457e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount DROP NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4f47bd1585d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_79054a2be36f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_10000", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_87e8c344233a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount SET STATISTICS -1;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0e2c63295b13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_percent", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount SET STATISTICS PERCENT 100;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_db6c7120bf79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD STATISTICS ((id, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c7566e47f436
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_delete_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE ONLY (t_at_regular) DELETE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_eb26a454073f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE ONLY (t_at_regular) DISABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c4f866e072e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_multistat", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE t_at_regular ADD STATISTICS ((code, amount));
-- test_sql:
ALTER TABLE ONLY (t_at_regular) ENABLE STATISTICS ((code, amount));
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_1d6d27d2d858
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount SET (n_distinct = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_04a421e7982c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_ndistinct", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN amount RESET (n_distinct);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f08ae5a5687b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_40574b8b7746
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_external", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN note SET STORAGE EXTERNAL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_a6a239a8dd20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_extended", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN note SET STORAGE EXTENDED;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_77d4158585a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_main", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN note SET STORAGE MAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c993020f99e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD CONSTRAINT ck_at_amount_upper CHECK (amount < 10000);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_92a765e930e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_check_not_valid", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD CONSTRAINT ck_at_amount_limit CHECK (amount < 5000) NOT VALID;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_d97351881b09
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD CONSTRAINT uq_at_note UNIQUE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_da55f7f898d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_primary", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD CONSTRAINT pk_at_id PRIMARY KEY (id);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_c8162e8f8208
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_validate_check", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) VALIDATE CONSTRAINT ck_at_amount_nonnegative;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f323c0fa97d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_constraint", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) DROP CONSTRAINT IF EXISTS ck_at_amount_nonnegative RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_0524ce99a973
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_primary_using_index", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD CONSTRAINT pk_at_code PRIMARY KEY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_ac0f65562fdc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_cluster_on", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) CLUSTER ON idx_at_id;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f6921dadcbd3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_without_cluster", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) SET WITHOUT CLUSTER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_f5de41972c35
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) SET (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_5e2726dd9cf8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_reset_fillfactor", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) RESET (fillfactor);
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_3c0f3708d3d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_228d93dfad33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4ec7a36f4906
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_098e0698cc69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_no_force_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) NO FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_cd3c4b970035
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_2953ae01ed70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_full", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_390821f05c74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_nothing", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_af4efa2d3e11
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_unique", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) REPLICA IDENTITY UNIQUE;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_4fb0d7752d25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_using", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) REPLICA IDENTITY USING INDEX uq_at_code;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_27ae4d423b5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_identity", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;

-- case_id: manifest_alter_table_core_positive_92a0a5a090e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_multiple", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_only_parenthesized"}
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
ALTER TABLE ONLY (t_at_regular) ADD COLUMN extra_one INTEGER, ADD COLUMN extra_two INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
