-- generated_from: manifest_create_index_partition_positive
-- static_only: true
-- case_count: 19

-- case_id: manifest_create_index_partition_positive_adc6dbca9a9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_adc6dbca ON t_ci_partitioned (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_47018310bee5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_explicit_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX IF NOT EXISTS idx_ci_part_47018310 ON t_ci_partitioned USING btree (id, note) LOCAL WITH (fillfactor = 70) ILM ADD POLICY ROW STORE COMPRESS NONE TABLESPACE pg_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4d7732be7af2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_explicit_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_4d7732be ON t_ci_partitioned (name ASC NULLS LAST) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (lpi_parallel_method = 'partition') ILM ADD POLICY ROW STORE COMPRESS NONE TABLESPACE pg_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_7c5f62f18354
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_part_7c5f62f1 ON t_ci_partitioned USING ubtree ((abs(id))) GLOBAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_9bbe4d1512fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_part_9bbe4d15 ON t_ci_partitioned USING btree (id, note) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_18c1751abf49
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_explicit_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_part_18c1751a ON t_ci_partitioned USING ubtree (id) GLOBAL ILM ADD POLICY ROW STORE COMPRESS NONE TABLESPACE pg_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_59e7c76a1026
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_part_59e7c76a ON t_ci_partitioned USING btree (name ASC NULLS LAST) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_914d23f1c2ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_explicit_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_part_914d23f1 ON t_ci_partitioned ((abs(id))) WITH (fillfactor = 70) ILM ADD POLICY ROW STORE COMPRESS NONE TABLESPACE pg_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_90e14ebd0877
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_part_90e14ebd ON t_ci_partitioned (id) LOCAL WITH (lpi_parallel_method = 'partition') TABLESPACE pg_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_14cb75fad1bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_explicit_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_part_14cb75fa ON t_ci_partitioned USING ubtree (id, note) ILM ADD POLICY ROW STORE COMPRESS NONE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_8f5b4c49618a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_part_8f5b4c49 ON t_ci_partitioned USING btree (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_3f15988d38ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_3f15988d ON t_ci_partitioned USING btree ((abs(id))) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4b20e697ea6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_part_4b20e697 ON t_ci_partitioned (name ASC NULLS LAST) GLOBAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_623740825528
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_62374082 ON t_ci_partitioned USING ubtree (name ASC NULLS LAST) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f4ca40fbdabc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_f4ca40fb ON t_ci_partitioned (id, note) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_18e759c5514c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_18e759c5 ON t_ci_partitioned ((abs(id))) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_2ac22c7945bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_2ac22c79 ON t_ci_partitioned USING btree (name ASC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_c465ae6cd0cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_c465ae6c ON t_ci_partitioned USING btree (id) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_00ef265a3536
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX idx_ci_part_00ef265a ON t_ci_partitioned USING ubtree (id) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
