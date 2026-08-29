-- generated_from: manifest_insert_partition_alias_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_partition_alias_negative_0d7bd314de9f
-- expected: error
-- expected_error_category: partition_alias_form_not_supported
-- expected_sqlstates: -
-- expected_error_regex: (?i)(alias|partition|syntax|not support)
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_partition_bare_alias_invalid", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER, note VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (1000), PARTITION p_high VALUES LESS THAN (MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned p PARTITION (p_low) (p.id, p.note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
