-- generated_from: manifest_alter_table_partition_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_table_partition_negative_fae9623b6351
-- expected: error
-- expected_error_category: unsupported_partition_alter
-- expected_sqlstates: 0A000,42809
-- expected_error_regex: (?i)(partition|tablespace|key|support)
-- params: {"action_profile": "at_action_partition_set_tablespace", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned SET TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;

-- case_id: manifest_alter_table_partition_negative_a5c114374c4f
-- expected: error
-- expected_error_category: unsupported_partition_alter
-- expected_sqlstates: 0A000,42809
-- expected_error_regex: (?i)(partition|tablespace|key|support)
-- params: {"action_profile": "at_action_partition_key_type", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount) VALUES (1, 'P001', 'low', 10), (101, 'P101', 'high', 20);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN id TYPE BIGINT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
