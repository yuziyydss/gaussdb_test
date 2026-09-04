-- generated_from: manifest_alter_table_partition_positive
-- static_only: true
-- case_count: 28

-- case_id: manifest_alter_table_partition_positive_f5aa70355295
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_9d5810b00ad7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_fbace6cb75d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE IF EXISTS t_at_partitioned ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_3243619cad26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE t_at_partitioned DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_92162ace3d1d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_c3124a576dc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN required_later SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_4a6c0e5d70ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_1006f0d5df7f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_10000", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_62905b5f59a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_fee43edbf350
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_b9fc6ee275be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_fec42524abcc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_38e269620823
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_full", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_5f9951a4ece4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_nothing", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_94fe97b56721
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_fd6f6a1fef2a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_drop_column", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE IF EXISTS t_at_partitioned DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_4f8d13df7db7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_add_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE t_at_partitioned ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_abfaed542a11
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_b862b94ab4e8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_950d31a8b2b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_set_not_null", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN required_later SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_c4754926e457
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_0", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_872423d5e295
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_statistics_10000", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_474482b9d639
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_storage_plain", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_7b4d8430ec4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_e55e9bd7ade4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_disable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_f4e21d123bbf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_e10dff7e6923
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_full", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_d62b3e77ae82
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_replica_nothing", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
