-- generated_from: manifest_m_comment_sequence
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_comment_sequence_fa5f0570fd9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_sequence", "text": "m_comment_text_basic"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
COMMENT ON SEQUENCE m_b03_existing_seq IS 'm finite comment';
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_comment_sequence_a8f26864d152
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_sequence", "text": "m_comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
COMMENT ON SEQUENCE m_b03_existing_seq IS '测试注释';
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;

-- case_id: manifest_m_comment_sequence_80c312ee06a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"object": "m_comment_object_sequence", "text": "m_comment_text_clear"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_comment_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_comment_fact_owner"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
CREATE SEQUENCE m_b03_existing_seq_two MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;
SELECT nextval('m_b03_existing_seq');
-- test_sql:
COMMENT ON SEQUENCE m_b03_existing_seq IS NULL;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq_two;
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE m_b03_sequence_owner;
