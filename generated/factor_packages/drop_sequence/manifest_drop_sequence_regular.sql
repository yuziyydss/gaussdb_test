-- generated_from: manifest_drop_sequence_regular
-- static_only: true
-- case_count: 9

-- case_id: manifest_drop_sequence_regular_725d4c5d881a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_one"}
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
DROP SEQUENCE seq_ds_one;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_df06e1df1d4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_two"}
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
DROP SEQUENCE IF EXISTS seq_ds_one, seq_ds_two RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_dc9d4262c6ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_cascade", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_dependent"}
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
DROP SEQUENCE seq_ds_dependent CASCADE;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_10d221de1c9d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_dependent"}
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
DROP SEQUENCE IF EXISTS seq_ds_dependent;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_6c244619b220
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_cascade", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_one"}
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
DROP SEQUENCE IF EXISTS seq_ds_one CASCADE;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_1c6a33b7d4ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_two"}
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
DROP SEQUENCE seq_ds_one, seq_ds_two;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_6722f54997cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_one"}
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
DROP SEQUENCE seq_ds_one RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_5e6014cadcc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_dependent"}
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
DROP SEQUENCE seq_ds_dependent RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_regular_de33e3d9e7f1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_cascade", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_two"}
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
DROP SEQUENCE seq_ds_one, seq_ds_two CASCADE;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
