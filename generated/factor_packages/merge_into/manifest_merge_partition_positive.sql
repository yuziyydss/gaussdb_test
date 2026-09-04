-- generated_from: manifest_merge_partition_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_merge_partition_positive_b6398f118924
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_update_then_insert", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_partition_name"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
CREATE TABLE t_merge_partitioned (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_merge_partitioned (id, name, category) VALUES (1, 'old-one', 'old');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_partitioned PARTITION (p_low) AS dst USING t_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name, category = src.category WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;

-- case_id: manifest_merge_partition_positive_b6ebe19905fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_partition_for"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
CREATE TABLE t_merge_partitioned (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_merge_partitioned (id, name, category) VALUES (1, 'old-one', 'old');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_partitioned PARTITION FOR (1) AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;

-- case_id: manifest_merge_partition_positive_67bd1ac408d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_not_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_partition_name"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
CREATE TABLE t_merge_partitioned (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_merge_partitioned (id, name, category) VALUES (1, 'old-one', 'old');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_partitioned PARTITION (p_low) AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;

-- case_id: manifest_merge_partition_positive_ed005b85af34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_not_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_partition_for"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
CREATE TABLE t_merge_partitioned (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_merge_partitioned (id, name, category) VALUES (1, 'old-one', 'old');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_partitioned PARTITION FOR (1) AS dst USING t_merge_source AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;

-- case_id: manifest_merge_partition_positive_00c0b4e423e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_partition_name"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
CREATE TABLE t_merge_partitioned (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_merge_partitioned (id, name, category) VALUES (1, 'old-one', 'old');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_partitioned PARTITION (p_low) AS dst USING t_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;

-- case_id: manifest_merge_partition_positive_08dcc307d031
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_update_then_insert", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_partition_for"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
CREATE TABLE t_merge_partitioned (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_merge_partitioned (id, name, category) VALUES (1, 'old-one', 'old');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_partitioned PARTITION FOR (1) AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name, category = src.category WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_partitioned CASCADE;
