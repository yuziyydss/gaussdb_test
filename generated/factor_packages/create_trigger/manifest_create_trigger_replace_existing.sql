-- generated_from: manifest_create_trigger_replace_existing
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_trigger_replace_existing_8d509f7b8584
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_insert", "level": "create_trigger_level_row", "replace": "create_trigger_replace_replace", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger AFTER INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
CREATE OR REPLACE TRIGGER fp_trigger BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;
