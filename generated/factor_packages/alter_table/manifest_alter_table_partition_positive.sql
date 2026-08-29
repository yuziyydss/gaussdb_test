-- generated_from: manifest_alter_table_partition_positive
-- static_only: true
-- case_count: 28

-- case_id: manifest_alter_table_partition_positive_51d6a7135ebb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_5bc9d9c7089c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_add_column", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_3e3abc894d44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_add_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE IF EXISTS t_at_partitioned ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_4a1bc3b94072
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_drop_column", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE t_at_partitioned DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_6f56aebd6f3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_set_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_0904fa388989
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_set_not_null", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN amount SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_b0372ede22a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_statistics_0", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_6b693f048db9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_statistics_10000", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_44c7cca21081
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_storage_plain", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_4d9ced6b9835
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_enable_rls", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_19ba9e9c6924
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_disable_rls", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_ba0189cce893
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_replica_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_96523b0c7fdb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_replica_full", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_7f5893985bbd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_replica_nothing", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_874f3e503786
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_add_column", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ADD COLUMN extra_col INTEGER;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_03b03a2c2f86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_drop_column", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE IF EXISTS t_at_partitioned DROP COLUMN note RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_5e1d43e19267
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_add_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE t_at_partitioned ADD COLUMN state INTEGER DEFAULT 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_c68c275a361b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned COMMENT = 'factor table';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_6dbdaab5c197
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_set_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN note SET DEFAULT 'unknown';
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_e6bd1fbe9cea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_set_not_null", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN amount SET NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_d83cc3de3f83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_statistics_0", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN amount SET STATISTICS 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_2f1a16a769d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_statistics_10000", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN amount SET STATISTICS 10000;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_5751b024999e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_storage_plain", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ALTER COLUMN id SET STORAGE PLAIN;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_79e3a3922c9d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_enable_rls", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_c008bae889be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_disable_rls", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned DISABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_3cc07ea1af65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_replica_default", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned REPLICA IDENTITY DEFAULT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_3ae06e241025
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_replica_full", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned REPLICA IDENTITY FULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_positive_a5ea76ba8009
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"action_profile": "at_action_replica_nothing", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_offline", "if_exists": "at_if_exists", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE OFFLINE IF EXISTS t_at_partitioned REPLICA IDENTITY NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
