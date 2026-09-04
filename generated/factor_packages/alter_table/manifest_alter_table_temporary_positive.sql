-- generated_from: manifest_alter_table_temporary_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_alter_table_temporary_positive_0b7f8a1ec930
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE t_at_temp ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_b33e492c22af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_temp ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_7d8f538f942a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE IF EXISTS t_at_temp ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_58577a12c802
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE OFFLINE t_at_temp ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_3ada41cef26c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE t_at_temp ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_fc94b6c76f57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE IF EXISTS t_at_temp ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_9ba81a28d566
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE OFFLINE t_at_temp ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_temporary_positive_70e6d3fb945b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_temp ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;
