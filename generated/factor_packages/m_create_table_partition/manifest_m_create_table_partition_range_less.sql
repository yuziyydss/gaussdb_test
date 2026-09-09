-- generated_from: manifest_m_create_table_partition_range_less
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_partition_range_less_977b1a84a30c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY RANGE (id) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_range_less_9559b6708a04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_yes", "count": "m_create_table_partition_count_three", "fillfactor": "m_create_table_partition_fillfactor_high", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_yes", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 100) PARTITION BY RANGE COLUMNS (id) PARTITIONS 3 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_range_less_f571e584789c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_three", "fillfactor": "m_create_table_partition_fillfactor_high", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 100) PARTITION BY RANGE (id) PARTITIONS 3 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_range_less_396f7e980d06
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_yes", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_yes", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY RANGE COLUMNS (id) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_range_less_05d04b68f115
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_yes", "count": "m_create_table_partition_count_none", "fillfactor": "m_create_table_partition_fillfactor_high", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_none", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 100) PARTITION BY RANGE COLUMNS (id) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;

-- case_id: manifest_m_create_table_partition_range_less_64d0d2c8883c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"bounds": "m_create_table_partition_bounds_ascending", "columns": "m_create_table_partition_columns_none", "count": "m_create_table_partition_count_three", "fillfactor": "m_create_table_partition_fillfactor_low", "form": "m_create_table_partition_form_range_less", "if_exists": "m_create_table_partition_if_exists_yes", "in": "m_create_table_partition_in_none", "method": "m_create_table_partition_method_hash"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_partition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["M_row_store_astore_available"], "fact_refs": ["m_create_table_partition_fact_row"], "key": "storage_environment"}]
-- fixture_setup:
CREATE SCHEMA m_create_partition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_partition_namespace.created (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 10) PARTITION BY RANGE (id) PARTITIONS 3 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20), PARTITION pmax VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;
DROP SCHEMA m_create_partition_namespace;
