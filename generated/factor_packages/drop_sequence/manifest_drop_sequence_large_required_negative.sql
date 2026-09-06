-- generated_from: manifest_drop_sequence_large_required_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_sequence_large_required_negative_7c4d79af2a1c
-- expected: error
-- expected_error_category: large_sequence_modifier_required
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_large_one"}
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
DROP SEQUENCE seq_ds_large_one;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_large_required_negative_6c72eeafd9e1
-- expected: error
-- expected_error_category: large_sequence_modifier_required
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_large_one"}
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
DROP SEQUENCE IF EXISTS seq_ds_large_one RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_large_required_negative_4ef530bb80a5
-- expected: error
-- expected_error_category: large_sequence_modifier_required
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_large_one"}
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
DROP SEQUENCE seq_ds_large_one RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_large_required_negative_2fc3e9abea9d
-- expected: error
-- expected_error_category: large_sequence_modifier_required
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_large_one"}
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
DROP SEQUENCE IF EXISTS seq_ds_large_one;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;
