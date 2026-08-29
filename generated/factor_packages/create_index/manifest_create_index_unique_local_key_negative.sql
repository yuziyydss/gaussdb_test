-- generated_from: manifest_create_index_unique_local_key_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_unique_local_key_negative_9e3d9c909b9c
-- expected: error
-- expected_error_category: unique_local_missing_partition_key
-- expected_sqlstates: -
-- expected_error_regex: (?i)(unique|local|partition key|partition column)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_unique_local_9e3d9c90 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
