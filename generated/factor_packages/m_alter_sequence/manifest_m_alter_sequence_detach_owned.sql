-- generated_from: manifest_m_alter_sequence_detach_owned
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_sequence_detach_owned_75f6938b653f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"change": "m_alter_sequence_change_unchanged", "if_exists": "m_alter_sequence_if_exists_none", "owned": "m_alter_sequence_owned_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_sequence_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["m_alter_sequence_fact_association_scope"], "key": "namespace"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_alter_sequence_fact_authority"], "key": "object_authority"}, {"allowed_values": ["create_any_sequence"], "fact_refs": ["m_create_sequence::m_create_sequence_fact_authority"], "key": "sequence_creation_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_creation_authority"}]
-- fixture_setup:
CREATE TABLE m_b03_sequence_owner (id INT);
CREATE SEQUENCE m_b03_existing_seq MINVALUE 1 MAXVALUE 100 START 5 CACHE 1 OWNED BY m_b03_sequence_owner.id;
-- test_sql:
ALTER SEQUENCE m_b03_existing_seq OWNED BY NONE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS m_b03_existing_seq;
DROP TABLE IF EXISTS m_b03_sequence_owner;
