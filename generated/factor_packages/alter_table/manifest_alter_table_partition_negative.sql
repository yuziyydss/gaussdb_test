-- generated_from: manifest_alter_table_partition_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_table_partition_negative_3908e26e96d9
-- expected: error
-- expected_error_category: unsupported_partition_alter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_partition_key_type", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_partitioned", "target_form": "at_target_plain"}
-- fixture_setup:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
CREATE TABLE t_at_partitioned (id INTEGER NOT NULL, code VARCHAR(32) NOT NULL, note VARCHAR(64), amount INTEGER NOT NULL, required_later INTEGER) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_at_partitioned (id, code, note, amount, required_later) VALUES (1, 'P001', 'low', 10, 100), (101, 'P101', 'high', 20, 200);
-- test_sql:
ALTER TABLE t_at_partitioned ALTER COLUMN id TYPE BIGINT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_at_partitioned CASCADE;
