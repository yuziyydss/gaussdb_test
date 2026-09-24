-- generated_from: manifest_drop_sequence_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_sequence_restrict_negative_6f3f3b95189b
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_dependent"}
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
DROP SEQUENCE seq_ds_dependent;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_restrict_negative_6d9938cc7e92
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_dependent"}
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
DROP SEQUENCE IF EXISTS seq_ds_dependent RESTRICT;
-- fixture_teardown:
ALTER TABLE t_cs_owner ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS seq_ds_dependent;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_two;
DROP LARGE SEQUENCE IF EXISTS seq_ds_large_one;
DROP SEQUENCE IF EXISTS seq_ds_two;
DROP SEQUENCE IF EXISTS seq_ds_one;
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_drop_sequence_restrict_negative_0363cc5078e6
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
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

-- case_id: manifest_drop_sequence_restrict_negative_b3089cb2831a
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
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
