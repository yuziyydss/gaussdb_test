-- generated_from: manifest_create_trigger_truncate_row
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_trigger_truncate_row_d1a762fcd709
-- expected: error
-- expected_error_category: trigger_truncate_requires_statement
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"event": "create_trigger_event_truncate", "level": "create_trigger_level_row", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE TRUNCATE ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;
