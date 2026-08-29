-- generated_from: manifest_alter_table_rls_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_table_rls_negative_1157d0824110
-- expected: error
-- expected_error_category: unsupported_rls_target
-- expected_sqlstates: 0A000
-- expected_error_regex: (?i)(row.level.security|temporary|support)
-- params: {"action_profile": "at_action_enable_rls", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE t_at_temp ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;

-- case_id: manifest_alter_table_rls_negative_048e6451d211
-- expected: error
-- expected_error_category: unsupported_rls_target
-- expected_sqlstates: 0A000
-- expected_error_regex: (?i)(row.level.security|temporary|support)
-- params: {"action_profile": "at_action_force_rls", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_temporary", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_temp CASCADE;
CREATE TEMP TABLE t_at_temp (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL);
INSERT INTO t_at_temp (id, code, note, amount) VALUES (1, 'T001', 'temp', 10);
-- test_sql:
ALTER TABLE t_at_temp FORCE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_temp CASCADE;
