-- generated_from: manifest_create_index_lpi_global_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_lpi_global_negative_7b615cbfe184
-- expected: error
-- expected_error_category: lpi_parallel_method_not_local
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_lpi_bad_7b615cbf ON t_ci_partitioned (id) GLOBAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
