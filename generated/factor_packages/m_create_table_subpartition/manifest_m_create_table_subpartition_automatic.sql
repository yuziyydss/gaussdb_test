-- generated_from: manifest_m_create_table_subpartition_automatic
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_subpartition_automatic_088062325877
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_none", "if_exists": "m_create_table_subpartition_if_exists_none", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_range", "root_count": "m_create_table_subpartition_root_count_none", "sub": "m_create_table_subpartition_sub_hash", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) SUBPARTITION BY HASH (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;

-- case_id: manifest_m_create_table_subpartition_automatic_c5c3c1d40d04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_yes", "if_exists": "m_create_table_subpartition_if_exists_yes", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_list", "root_count": "m_create_table_subpartition_root_count_two", "sub": "m_create_table_subpartition_sub_key", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY LIST COLUMNS (id) PARTITIONS 2 SUBPARTITION BY KEY (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES IN (1,2), PARTITION p2 VALUES IN (3,4));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;

-- case_id: manifest_m_create_table_subpartition_automatic_cd0023979e2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_none", "if_exists": "m_create_table_subpartition_if_exists_yes", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_range", "root_count": "m_create_table_subpartition_root_count_two", "sub": "m_create_table_subpartition_sub_hash", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) PARTITIONS 2 SUBPARTITION BY HASH (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;

-- case_id: manifest_m_create_table_subpartition_automatic_eb5ede3485a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_yes", "if_exists": "m_create_table_subpartition_if_exists_none", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_range", "root_count": "m_create_table_subpartition_root_count_none", "sub": "m_create_table_subpartition_sub_key", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE COLUMNS (id) SUBPARTITION BY KEY (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;

-- case_id: manifest_m_create_table_subpartition_automatic_e3b733333286
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_none", "if_exists": "m_create_table_subpartition_if_exists_none", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_list", "root_count": "m_create_table_subpartition_root_count_none", "sub": "m_create_table_subpartition_sub_hash", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY LIST (id) SUBPARTITION BY HASH (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES IN (1,2), PARTITION p2 VALUES IN (3,4));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;

-- case_id: manifest_m_create_table_subpartition_automatic_b3a4e3b9ed22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_yes", "if_exists": "m_create_table_subpartition_if_exists_none", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_range", "root_count": "m_create_table_subpartition_root_count_two", "sub": "m_create_table_subpartition_sub_hash", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE COLUMNS (id) PARTITIONS 2 SUBPARTITION BY HASH (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;

-- case_id: manifest_m_create_table_subpartition_automatic_33a997309083
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_subpartition_columns_none", "if_exists": "m_create_table_subpartition_if_exists_yes", "layout": "m_create_table_subpartition_layout_automatic", "root": "m_create_table_subpartition_root_range", "root_count": "m_create_table_subpartition_root_count_none", "sub": "m_create_table_subpartition_sub_key", "sub_count": "m_create_table_subpartition_sub_count_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_subpartition_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["ordinary_m_no_encryption_no_ledger_row_store"], "fact_refs": ["m_create_table_subpartition_fact_row"], "key": "database_features"}]
-- fixture_setup:
CREATE SCHEMA m_create_subpartition_namespace;
-- test_sql:
CREATE TABLE IF NOT EXISTS m_create_subpartition_namespace.created (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) SUBPARTITION BY KEY (qty) SUBPARTITIONS 2 (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (MAXVALUE));
-- fixture_teardown:
DROP TABLE IF EXISTS m_create_subpartition_namespace.created PURGE;
DROP SCHEMA m_create_subpartition_namespace;
