-- generated_from: manifest_alter_trigger_rename
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_trigger_rename_e74c33c6f009
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"new_name": "alter_trigger_new_name_short"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
ALTER TRIGGER fp_trigger_ready ON t_trigger_source RENAME TO fp_trigger_renamed;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_alter_trigger_rename_b40b8d647981
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"new_name": "alter_trigger_new_name_max"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
ALTER TRIGGER fp_trigger_ready ON t_trigger_source RENAME TO ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;
