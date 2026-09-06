-- generated_from: manifest_alter_index_partition_rebuild
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_index_partition_rebuild_e6f8281a3721
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_index_action_rebuild_partition", "if_exists": "alter_index_if_exists_absent", "index_name": "alter_index_index_name_local", "new_name": "alter_index_new_name_new", "new_partition": "alter_index_new_partition_new", "partition_name": "alter_index_partition_name_low", "reset_parameters": "alter_index_reset_parameters_fillfactor", "storage_parameters": "alter_index_storage_parameters_fillfactor", "tablespace": "alter_index_tablespace_prepared"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
CREATE INDEX idx_ai_local ON t_ci_partitioned(id) LOCAL (PARTITION p_ai_low, PARTITION p_ai_max);
-- test_sql:
ALTER INDEX idx_ai_local REBUILD PARTITION p_ai_low;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_ai_local;
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_alter_index_partition_rebuild_74ac14043fbe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_index_action_rebuild_partition", "if_exists": "alter_index_if_exists_absent", "index_name": "alter_index_index_name_local", "new_name": "alter_index_new_name_new", "new_partition": "alter_index_new_partition_new", "partition_name": "alter_index_partition_name_max", "reset_parameters": "alter_index_reset_parameters_fillfactor", "storage_parameters": "alter_index_storage_parameters_fillfactor", "tablespace": "alter_index_tablespace_prepared"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
CREATE INDEX idx_ai_local ON t_ci_partitioned(id) LOCAL (PARTITION p_ai_low, PARTITION p_ai_max);
-- test_sql:
ALTER INDEX idx_ai_local REBUILD PARTITION p_ai_max;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_ai_local;
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
