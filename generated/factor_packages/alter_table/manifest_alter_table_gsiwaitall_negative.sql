-- generated_from: manifest_alter_table_gsiwaitall_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_table_gsiwaitall_negative_99f26007b0b7
-- expected: error
-- expected_error_category: unsupported_gsiwaitall
-- expected_sqlstates: 0A000
-- expected_error_regex: (?i)(gsiwaitall|global.secondary.index|support)
-- params: {"action_profile": "at_action_gsiwaitall", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_regular", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
CREATE SCHEMA at_target_schema;
CREATE SEQUENCE at_seq;
CREATE TABLE t_at_regular (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64) DEFAULT 'n/a', amount INTEGER NOT NULL, created_at TIMESTAMP);
CREATE UNIQUE INDEX uq_at_code ON t_at_regular (code);
CREATE INDEX idx_at_id ON t_at_regular (id);
ALTER TABLE t_at_regular ADD CONSTRAINT ck_at_amount_nonnegative CHECK (amount >= 0) NOT VALID;
INSERT INTO t_at_regular (id, code, note, amount) VALUES (1, 'A001', 'alpha', 10), (2, 'A002', 'beta', 20);
-- test_sql:
ALTER TABLE t_at_regular GSIWAITALL;
-- fixture_teardown:
DROP TABLE IF EXISTS at_target_schema.t_at_regular CASCADE;
DROP TABLE IF EXISTS t_at_renamed CASCADE;
DROP TABLE IF EXISTS t_at_regular CASCADE;
DROP SEQUENCE IF EXISTS at_seq CASCADE;
DROP SCHEMA IF EXISTS at_target_schema CASCADE;
