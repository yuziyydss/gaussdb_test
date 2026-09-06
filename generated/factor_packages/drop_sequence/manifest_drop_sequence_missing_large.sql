-- generated_from: manifest_drop_sequence_missing_large
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_sequence_missing_large_ba25a7ef781e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_present", "targets": "drop_sequence_targets_large_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_ds_one START 101;
CREATE SEQUENCE seq_ds_two;
CREATE LARGE SEQUENCE seq_ds_large_one;
CREATE LARGE SEQUENCE seq_ds_large_two;
CREATE SEQUENCE seq_ds_dependent;
ALTER TABLE t_cs_owner ALTER COLUMN id SET DEFAULT nextval('seq_ds_dependent'::regclass);
DROP SEQUENCE IF EXISTS seq_ds_missing;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_missing;
-- test_sql:
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_missing;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_missing_large_8e5262723278
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_present", "targets": "drop_sequence_targets_large_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_ds_one START 101;
CREATE SEQUENCE seq_ds_two;
CREATE LARGE SEQUENCE seq_ds_large_one;
CREATE LARGE SEQUENCE seq_ds_large_two;
CREATE SEQUENCE seq_ds_dependent;
ALTER TABLE t_cs_owner ALTER COLUMN id SET DEFAULT nextval('seq_ds_dependent'::regclass);
DROP SEQUENCE IF EXISTS seq_ds_missing;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_missing;
-- test_sql:
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_missing RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_missing_large_02c87e08bab8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_cascade", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_present", "targets": "drop_sequence_targets_large_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
CREATE SEQUENCE seq_ds_one START 101;
CREATE SEQUENCE seq_ds_two;
CREATE LARGE SEQUENCE seq_ds_large_one;
CREATE LARGE SEQUENCE seq_ds_large_two;
CREATE SEQUENCE seq_ds_dependent;
ALTER TABLE t_cs_owner ALTER COLUMN id SET DEFAULT nextval('seq_ds_dependent'::regclass);
DROP SEQUENCE IF EXISTS seq_ds_missing;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_missing;
-- test_sql:
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_missing CASCADE;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
