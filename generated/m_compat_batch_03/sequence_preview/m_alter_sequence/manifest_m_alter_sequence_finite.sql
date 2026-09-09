-- generated_from: manifest_m_alter_sequence_finite
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_sequence_finite_405b87c1c171
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_max", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_unchanged"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq MAXVALUE 200;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_d5bd6115968e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_no_max", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq NO MAXVALUE OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_9992b005ba9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_compact", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq NOMAXVALUE OWNED BY m_b03_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_0a4c44c37fbb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_max", "if_exists": "m_alter_sequence_if_exists_yes", "owned": "m_alter_sequence_owned_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE IF EXISTS m_b03_existing_seq MAXVALUE 200 OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_0b29d6df6a93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_no_max", "if_exists": "m_alter_sequence_if_exists_yes", "owned": "m_alter_sequence_owned_unchanged"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE IF EXISTS m_b03_existing_seq NO MAXVALUE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_4d6435994b46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_cache_one", "if_exists": "m_alter_sequence_if_exists_yes", "owned": "m_alter_sequence_owned_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE IF EXISTS m_b03_existing_seq CACHE 1 OWNED BY m_b03_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_e46d851e35f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_cache_one", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_unchanged"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq CACHE 1;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_21e43b6332de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_cache_four", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_unchanged"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq CACHE 4;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_54d8989e6661
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_compact", "if_exists": "m_alter_sequence_if_exists_yes", "owned": "m_alter_sequence_owned_unchanged"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE IF EXISTS m_b03_existing_seq NOMAXVALUE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_128d72b2e1c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_cache_four", "if_exists": "m_alter_sequence_if_exists_yes", "owned": "m_alter_sequence_owned_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE IF EXISTS m_b03_existing_seq CACHE 4 OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_62911bb10e2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_max", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq MAXVALUE 200 OWNED BY m_b03_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_2831be5d2711
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_no_max", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq NO MAXVALUE OWNED BY m_b03_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_42e3385f04cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_compact", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq NOMAXVALUE OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_3e2c5ab57735
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_cache_one", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq CACHE 1 OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_alter_sequence_finite_a5fec2ffa02f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_cache_four", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq CACHE 4 OWNED BY m_b03_sequence_owner.id;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;
