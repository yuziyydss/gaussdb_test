-- generated_from: manifest_insert_partition_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_insert_partition_positive_c8225b0042a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_name", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION (p_low) (id, note) VALUES (1, 'partition low');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_partition_positive_08c63311bf2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_for", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION FOR (1) (id, note) VALUES (1, 'partition low') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_partition_positive_bc8daaed7512
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION (p_low) AS dst (dst.id, dst.note) VALUES (1, 'partition low');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_partition_positive_84f07856996e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_name", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION (p_low) (id, note) VALUES (1, 'partition low') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_partition_positive_c1c3080410be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_for", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION FOR (1) (id, note) VALUES (1, 'partition low');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_partition_positive_34ae1a820718
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_as_alias", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION (p_low) AS dst (dst.id, dst.note) VALUES (1, 'partition low') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
