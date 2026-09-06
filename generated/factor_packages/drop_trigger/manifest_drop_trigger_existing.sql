-- generated_from: manifest_drop_trigger_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_trigger_existing_32f9d95f14a5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_trigger_behavior_default", "if_exists": "drop_trigger_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
DROP TRIGGER fp_trigger_ready ON t_trigger_source;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_drop_trigger_existing_5e9185c22156
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_trigger_behavior_cascade", "if_exists": "drop_trigger_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
DROP TRIGGER fp_trigger_ready ON t_trigger_source CASCADE;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_drop_trigger_existing_89777507cd5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_trigger_behavior_restrict", "if_exists": "drop_trigger_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
DROP TRIGGER fp_trigger_ready ON t_trigger_source RESTRICT;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_drop_trigger_existing_9960fc5ffc38
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_trigger_behavior_default", "if_exists": "drop_trigger_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_drop_trigger_existing_fb9c97dddd53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_trigger_behavior_cascade", "if_exists": "drop_trigger_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source CASCADE;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;

-- case_id: manifest_drop_trigger_existing_914c89c3ff99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_trigger_behavior_restrict", "if_exists": "drop_trigger_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_trigger_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_trigger_source VALUES (1, 2), (3, 4);
CREATE FUNCTION fp_trigger_new() RETURNS TRIGGER AS 'BEGIN RETURN NEW; END;' LANGUAGE plpgsql;
CREATE FUNCTION fp_trigger_old() RETURNS TRIGGER AS 'BEGIN RETURN OLD; END;' LANGUAGE plpgsql;
CREATE TRIGGER fp_trigger_ready BEFORE INSERT ON t_trigger_source FOR EACH ROW EXECUTE PROCEDURE fp_trigger_new();
-- test_sql:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source RESTRICT;
-- fixture_teardown:
DROP TRIGGER IF EXISTS fp_trigger_ready ON t_trigger_source;
DROP FUNCTION IF EXISTS fp_trigger_new() CASCADE;
DROP FUNCTION IF EXISTS fp_trigger_old() CASCADE;
DROP TABLE IF EXISTS t_trigger_source CASCADE;
