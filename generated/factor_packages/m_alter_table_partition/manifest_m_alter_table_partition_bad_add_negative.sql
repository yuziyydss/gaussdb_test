-- generated_from: manifest_m_alter_table_partition_bad_add_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_table_partition_bad_add_negative_2ec06f948a62
-- expected: error
-- expected_error_category: add_above_last
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action": "m_alter_table_partition_action_bad_add", "if_exists": "m_alter_table_partition_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_partition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_range_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));
INSERT INTO m_b06_range_source VALUES (1,10),(11,20),(21,30);
-- test_sql:
ALTER TABLE m_b06_range_source ADD PARTITION (PARTITION p_new VALUES LESS THAN (15));
-- fixture_teardown:
DROP TABLE m_b06_range_source PURGE;
