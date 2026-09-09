-- generated_from: manifest_m_alter_table_subpartition_truncate
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_table_subpartition_truncate_d358709c6956
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_table_subpartition_form_truncate", "if_exists": "m_alter_table_subpartition_if_exists_none", "selector": "m_alter_table_subpartition_selector_name"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_subpartition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_sub_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) SUBPARTITION BY HASH (qty) (PARTITION p_low VALUES LESS THAN (10) (SUBPARTITION s_low), PARTITION p_high VALUES LESS THAN (MAXVALUE) (SUBPARTITION s_high));
INSERT INTO m_b06_sub_source VALUES (1,10),(2,20),(11,30);
-- test_sql:
ALTER TABLE m_b06_sub_source TRUNCATE SUBPARTITION s_low;
-- fixture_teardown:
DROP TABLE m_b06_sub_source PURGE;

-- case_id: manifest_m_alter_table_subpartition_truncate_3d9a6440d9c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_table_subpartition_form_truncate", "if_exists": "m_alter_table_subpartition_if_exists_none", "selector": "m_alter_table_subpartition_selector_for"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table_subpartition_fact_authority"], "key": "actor_authority"}]
-- fixture_setup:
CREATE TABLE m_b06_sub_source (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) SUBPARTITION BY HASH (qty) (PARTITION p_low VALUES LESS THAN (10) (SUBPARTITION s_low), PARTITION p_high VALUES LESS THAN (MAXVALUE) (SUBPARTITION s_high));
INSERT INTO m_b06_sub_source VALUES (1,10),(2,20),(11,30);
-- test_sql:
ALTER TABLE m_b06_sub_source TRUNCATE SUBPARTITION FOR (1, 10);
-- fixture_teardown:
DROP TABLE m_b06_sub_source PURGE;
