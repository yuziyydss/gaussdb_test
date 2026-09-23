-- generated_from: manifest_m_alter_sequence_cache_zero
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_sequence_cache_zero_c513398ee8d2
-- expected: error
-- expected_error_category: cache_range
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"change": "m_alter_sequence_change_cache_zero", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_unchanged"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_alter_sequence_fact_outside_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq CACHE 0;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;
