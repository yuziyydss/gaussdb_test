-- generated_from: manifest_create_trigger_ordinary
-- static_only: true
-- case_count: 17

-- case_id: manifest_create_trigger_ordinary_ae85ad7d8408
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_insert", "level": "create_trigger_level_default", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE INSERT ON t_trigger_source EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_a753cce5564c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_update", "level": "create_trigger_level_row", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_after", "when": "create_trigger_when_true"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger AFTER UPDATE ON t_trigger_source FOR EACH ROW WHEN (TRUE) EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_d078fb92027a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_delete", "level": "create_trigger_level_statement", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_true"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE DELETE ON t_trigger_source FOR EACH STATEMENT WHEN (TRUE) EXECUTE PROCEDURE fp_trigger_old();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_0f38704d8063
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_i_u", "level": "create_trigger_level_statement", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_after", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger AFTER INSERT OR UPDATE ON t_trigger_source FOR EACH STATEMENT EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_c7fce1423a52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_update_of", "level": "create_trigger_level_row", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE UPDATE OF col_1, col_2 ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_bfc74e0f5449
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_truncate", "level": "create_trigger_level_default", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_after", "when": "create_trigger_when_true"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger AFTER TRUNCATE ON t_trigger_source WHEN (TRUE) EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_3f86eaa0c416
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_update", "level": "create_trigger_level_default", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE UPDATE ON t_trigger_source EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_1e3edf3a5399
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_i_u", "level": "create_trigger_level_default", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_true"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE INSERT OR UPDATE ON t_trigger_source WHEN (TRUE) EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_cc8f0b13dd6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_truncate", "level": "create_trigger_level_statement", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE TRUNCATE ON t_trigger_source FOR EACH STATEMENT EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_c1aa1891593d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_insert", "level": "create_trigger_level_row", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_after", "when": "create_trigger_when_true"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger AFTER INSERT ON t_trigger_source FOR EACH ROW WHEN (TRUE) EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_bf4a10e08132
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_delete", "level": "create_trigger_level_default", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_after", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger AFTER DELETE ON t_trigger_source EXECUTE PROCEDURE fp_trigger_old();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_84840ff22982
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_update_of", "level": "create_trigger_level_default", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_after", "when": "create_trigger_when_true"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger AFTER UPDATE OF col_1, col_2 ON t_trigger_source WHEN (TRUE) EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_42c1f0899fea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_insert", "level": "create_trigger_level_statement", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE INSERT ON t_trigger_source FOR EACH STATEMENT EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_ad3e4d268a6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_update", "level": "create_trigger_level_statement", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE UPDATE ON t_trigger_source FOR EACH STATEMENT EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_037aed770539
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_delete", "level": "create_trigger_level_row", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE DELETE ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_old();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_b24ffee71519
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_i_u", "level": "create_trigger_level_row", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE INSERT OR UPDATE ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_create_trigger_ordinary_761a18ca4578
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"event": "create_trigger_event_update_of", "level": "create_trigger_level_statement", "replace": "create_trigger_replace_new", "timing": "create_trigger_timing_before", "when": "create_trigger_when_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
-- test_sql:
CREATE TRIGGER fp_trigger BEFORE UPDATE OF col_1, col_2 ON t_trigger_source FOR EACH STATEMENT EXECUTE PROCEDURE fp_trigger_new();
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;
