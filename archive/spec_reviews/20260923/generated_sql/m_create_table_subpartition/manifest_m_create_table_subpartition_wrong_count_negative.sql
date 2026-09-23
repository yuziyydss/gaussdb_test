-- generated_from: manifest_m_create_table_subpartition_wrong_count_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_subpartition_wrong_count_negative_2cd0f5733fb2
-- expected: error
-- expected_error_category: sub_count_matches
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "m_create_table_subpartition_columns_none", "if_exists": "m_create_table_subpartition_if_exists_none", "layout": "m_create_table_subpartition_layout_explicit", "root": "m_create_table_subpartition_root_range", "root_count": "m_create_table_subpartition_root_count_none", "sub": "m_create_table_subpartition_sub_hash", "sub_count": "m_create_table_subpartition_sub_count_wrong"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) SUBPARTITION BY HASH (qty) SUBPARTITIONS 3 (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1_a, SUBPARTITION p1_b), PARTITION p2 VALUES LESS THAN (MAXVALUE) (SUBPARTITION p2_a, SUBPARTITION p2_b));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;
