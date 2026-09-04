-- generated_from: manifest_insert_partition_alias_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_partition_alias_negative_45c4f1a101a4
-- expected: error
-- expected_error_category: partition_alias_form_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partition_low", "target_profile": "insert_target_partition_bare_alias_invalid", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned dst PARTITION (p_low) (dst.id, dst.note) VALUES (1, 'partition low');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
