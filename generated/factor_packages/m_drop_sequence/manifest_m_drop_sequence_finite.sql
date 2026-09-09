-- generated_from: manifest_m_drop_sequence_finite
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_sequence_finite_363847c4f3b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_sequence_dependency_default", "if_exists": "m_drop_sequence_if_exists_none", "targets": "m_drop_sequence_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
DROP SEQUENCE m_b03_existing_seq;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_drop_sequence_finite_74a533f82301
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_sequence_dependency_cascade", "if_exists": "m_drop_sequence_if_exists_none", "targets": "m_drop_sequence_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
DROP SEQUENCE m_b03_existing_seq, m_b03_existing_seq_two CASCADE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_drop_sequence_finite_5811c6cac601
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_sequence_dependency_cascade", "if_exists": "m_drop_sequence_if_exists_yes", "targets": "m_drop_sequence_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
DROP SEQUENCE IF EXISTS m_b03_existing_seq CASCADE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_drop_sequence_finite_d1e80f083b23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_sequence_dependency_default", "if_exists": "m_drop_sequence_if_exists_yes", "targets": "m_drop_sequence_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
DROP SEQUENCE IF EXISTS m_b03_existing_seq, m_b03_existing_seq_two;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_drop_sequence_finite_275873f6a11c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_sequence_dependency_restrict", "if_exists": "m_drop_sequence_if_exists_none", "targets": "m_drop_sequence_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
DROP SEQUENCE m_b03_existing_seq RESTRICT;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_drop_sequence_finite_7ad69d7dd0ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_sequence_dependency_restrict", "if_exists": "m_drop_sequence_if_exists_yes", "targets": "m_drop_sequence_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_sequence_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
DROP SEQUENCE IF EXISTS m_b03_existing_seq, m_b03_existing_seq_two RESTRICT;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;
