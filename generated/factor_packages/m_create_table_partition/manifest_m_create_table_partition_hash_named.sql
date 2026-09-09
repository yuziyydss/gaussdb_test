-- generated_from: manifest_m_create_table_partition_hash_named
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_partition_hash_named_defce4f5e163
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_hash_named", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY HASH (id) (PARTITION p1, PARTITION p2, PARTITION p3);
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_hash_named_3fc9329493cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_three", "fillfactor": "m_create_table_partition_fillfactor_high", "form": "m_create_table_partition_form_hash_named", "if_exists": "m_create_table_partition_if_exists_yes", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_key"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 100) PARTITION BY KEY (id) PARTITIONS 3 (PARTITION p1, PARTITION p2, PARTITION p3);
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_hash_named_cb32cf03234a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_high", "form": "m_create_table_partition_form_hash_named", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_key"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 100) PARTITION BY KEY (id) (PARTITION p1, PARTITION p2, PARTITION p3);
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_hash_named_1fe2f9e41047
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_three", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_hash_named", "if_exists": "m_create_table_partition_if_exists_yes", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY HASH (id) PARTITIONS 3 (PARTITION p1, PARTITION p2, PARTITION p3);
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_hash_named_cfca9eeebb73
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_three", "fillfactor": "m_create_table_partition_fillfactor_high", "form": "m_create_table_partition_form_hash_named", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 100) PARTITION BY HASH (id) PARTITIONS 3 (PARTITION p1, PARTITION p2, PARTITION p3);
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_hash_named_9a0b93bc0042
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_hash_named", "if_exists": "m_create_table_partition_if_exists_yes", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_key"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY KEY (id) (PARTITION p1, PARTITION p2, PARTITION p3);
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;
