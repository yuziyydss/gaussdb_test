-- generated_from: manifest_m_create_table_partition_descending_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_partition_descending_negative_93fa0b2a9eed
-- expected: error
-- expected_error_category: ascending_bounds
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"bounds": "m_create_table_partition_bounds_descending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY RANGE (id) (PARTITION p1 VALUES LESS THAN (20), PARTITION p2 VALUES LESS THAN (10), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;
