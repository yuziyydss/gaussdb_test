-- generated_from: manifest_create_index_partition_positive
-- static_only: true
-- case_count: 132

-- case_id: manifest_create_index_partition_positive_563f8c0ea693
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_563f8c0e ON t_ci_partitioned (id) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_ca95898cdfed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_ca95898c ON t_ci_partitioned (name ASC NULLS LAST) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_a13ad2b76ca2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_a13ad2b7 ON t_ci_partitioned USING btree (id, note) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_261fc9ff0b02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_261fc9ff ON t_ci_partitioned (name DESC NULLS LAST) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d89d75e89ecc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d89d75e8 ON t_ci_partitioned ((abs(id))) LOCAL INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_8cb772f1605f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_8cb772f1 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_3770dfe9743a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_3770dfe9 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 70) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_24831b0f58d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_24831b0f ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 100) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_572ed4787277
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_572ed478 ON t_ci_partitioned (id) LOCAL WITH (lpi_parallel_method = 'partition') INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_7e5901530524
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_7e590153 ON t_ci_partitioned (id) LOCAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_1219534808da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_12195348 ON t_ci_partitioned USING btree (id) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_c2d6452f0cec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_c2d6452f ON t_ci_partitioned (name ASC NULLS LAST) LOCAL INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_5466f4bd0d51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_5466f4bd ON t_ci_partitioned ((abs(id))) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0a524f537ff3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_0a524f53 ON t_ci_partitioned (id, note) LOCAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f7cbe5632ca2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_f7cbe563 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_24e0e168f79f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_24e0e168 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_dc2192102e31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_dc219210 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 100) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_16f613905f85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_16f61390 ON t_ci_partitioned (id) LOCAL COMMENT 'factor index' VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0467e1084523
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_0467e108 ON t_ci_partitioned (name DESC NULLS LAST) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_098fbfaa58d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_098fbfaa ON t_ci_partitioned (id) LOCAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_ce1f26a0d1e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_ce1f26a0 ON t_ci_partitioned (id) LOCAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_25b4f9289c69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_25b4f928 ON t_ci_partitioned USING btree (id) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_e48656f62eb1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_e48656f6 ON t_ci_partitioned (id, note) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4e86fcefe0f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_4e86fcef ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_a4df02f0800f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_a4df02f0 ON t_ci_partitioned (id) LOCAL INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_286b15b903a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_286b15b9 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0b5035f79949
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_0b5035f7 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d87fdae4e852
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_d87fdae4 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_3e9bf796bd6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_3e9bf796 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4e06bcba85e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_4e06bcba ON t_ci_partitioned (id) LOCAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_af2f03ffe397
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_partition_af2f03ff ON t_ci_partitioned (id) LOCAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_065380271390
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_06538027 ON t_ci_partitioned USING btree (name ASC NULLS LAST) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_c00412c704f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_c00412c7 ON t_ci_partitioned USING btree (name DESC NULLS LAST) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_464feaedbb3f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_464feaed ON t_ci_partitioned USING btree ((abs(id))) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_29531d826d54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_29531d82 ON t_ci_partitioned USING btree (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_8381f199747f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_8381f199 ON t_ci_partitioned USING btree (id) LOCAL INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4f9417342d58
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4f941734 ON t_ci_partitioned USING btree (id) LOCAL INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4a323dffed92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4a323dff ON t_ci_partitioned USING btree (id) LOCAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_821493632098
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_82149363 ON t_ci_partitioned USING btree (id) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_b5ac93a3ac77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_b5ac93a3 ON t_ci_partitioned USING btree (id) LOCAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_2659b2d5fcbc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_2659b2d5 ON t_ci_partitioned USING btree (id) LOCAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_60db21071d08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_60db2107 ON t_ci_partitioned USING btree (id) LOCAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_1558115772b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_15581157 ON t_ci_partitioned USING btree (id) LOCAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_ddda2361f8f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_ddda2361 ON t_ci_partitioned USING btree (id) LOCAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4c59f4f561fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4c59f4f5 ON t_ci_partitioned USING btree (id) LOCAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_192ca2616d29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_192ca261 ON t_ci_partitioned (id, note) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_586639df7d2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_586639df ON t_ci_partitioned (id, note) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d33e6ddccb9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d33e6ddc ON t_ci_partitioned (name ASC NULLS LAST) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f6a0b6378376
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_f6a0b637 ON t_ci_partitioned ((abs(id))) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_53d2e2d1a159
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_53d2e2d1 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_41627bd28839
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_41627bd2 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_8c49726db98c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_8c49726d ON t_ci_partitioned (name DESC NULLS LAST) LOCAL INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_54c85bf2f2d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_54c85bf2 ON t_ci_partitioned ((abs(id))) LOCAL INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_879f4d2f6f5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_879f4d2f ON t_ci_partitioned (id, note) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0e103714e4a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_0e103714 ON t_ci_partitioned (id, note) LOCAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_961bbcf39279
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_961bbcf3 ON t_ci_partitioned (id, note) LOCAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_a8d4ad0262f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_a8d4ad02 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_61f32614f2b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_61f32614 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_17c19a2fb531
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_17c19a2f ON t_ci_partitioned (name ASC NULLS LAST) LOCAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_ff2cea21b7f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_ff2cea21 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_616a74a118ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_616a74a1 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_858cb5c2cb1e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_858cb5c2 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_c7a623d458b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_c7a623d4 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_3a65f41e71d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_3a65f41e ON t_ci_partitioned ((abs(id))) LOCAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_81331e0eba63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_81331e0e ON t_ci_partitioned ((abs(id))) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_7c5a43850209
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_7c5a4385 ON t_ci_partitioned ((abs(id))) LOCAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_2247da59ed3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_2247da59 ON t_ci_partitioned ((abs(id))) LOCAL WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_e387ce801d8e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_e387ce80 ON t_ci_partitioned (id, note) LOCAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_8e7f677b73c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_8e7f677b ON t_ci_partitioned (name ASC NULLS LAST) LOCAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_175f78767378
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_175f7876 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_02bd9015572f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_02bd9015 ON t_ci_partitioned ((abs(id))) LOCAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_36ad64eb2efa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_36ad64eb ON t_ci_partitioned (id, note) LOCAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4e4ace63b9b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4e4ace63 ON t_ci_partitioned (id, note) LOCAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f0991af786f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_f0991af7 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d569e536191a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d569e536 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_713898b726ea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_713898b7 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_e7b582c059b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_e7b582c0 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_52189fd12dbb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_52189fd1 ON t_ci_partitioned ((abs(id))) LOCAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_ace1ae76ca05
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_ace1ae76 ON t_ci_partitioned ((abs(id))) LOCAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_2a2190e23f2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_2a2190e2 ON t_ci_partitioned (id, note) LOCAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_cd506848e9b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_cd506848 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_27a4c69902c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_27a4c699 ON t_ci_partitioned (name DESC NULLS LAST) LOCAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_587e7bd7684a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_587e7bd7 ON t_ci_partitioned ((abs(id))) LOCAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_af3dbeee461b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_af3dbeee ON t_ci_partitioned (id) GLOBAL INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_84438ef8df4c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_84438ef8 ON t_ci_partitioned (id) GLOBAL INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_3b00a3f07141
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_3b00a3f0 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_609ae8e0cb55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_609ae8e0 ON t_ci_partitioned (id) GLOBAL WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_259406f98c7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_259406f9 ON t_ci_partitioned (id) GLOBAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4defb5137688
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4defb513 ON t_ci_partitioned (id) GLOBAL WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_1b2b6a17b3a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_1b2b6a17 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4b1057de6966
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4b1057de ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_9a5889bfc61d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_9a5889bf ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0459bef1a919
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_0459bef1 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_38679221d373
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_38679221 ON t_ci_partitioned (id) GLOBAL COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_08e1b392ec68
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_08e1b392 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_4e2b01120991
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_4e2b0112 ON t_ci_partitioned (id) GLOBAL VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_62437ac4d7da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_62437ac4 ON t_ci_partitioned (id) GLOBAL INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0bbc3e14b612
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_0bbc3e14 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_49d941976406
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_49d94197 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_5153d8401162
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_5153d840 ON t_ci_partitioned (id) GLOBAL TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f223d9a0dee9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local_named", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_f223d9a0 ON t_ci_partitioned (id) LOCAL (PARTITION idx_p_low, PARTITION idx_p_max) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_713f8298d0d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_713f8298 ON t_ci_partitioned (id) LOCAL INCLUDE (note) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f16e9afef284
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_f16e9afe ON t_ci_partitioned (id) LOCAL INCLUDE (note) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_8eeeb8a26272
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_8eeeb8a2 ON t_ci_partitioned (id) LOCAL INCLUDE (note) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_76acb257bce7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_76acb257 ON t_ci_partitioned (id) LOCAL INCLUDE (note) WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_0d744bfacbcd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_0d744bfa ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_799e26c16351
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_799e26c1 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_6f2d78586ce2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_6f2d7858 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) WITH (lpi_parallel_method = 'partition');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_cb642c1d559a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_cb642c1d ON t_ci_partitioned (id) LOCAL INCLUDE (note) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_7daaf22b71b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_7daaf22b ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_1049e02d5936
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_1049e02d ON t_ci_partitioned (id) LOCAL INCLUDE (note) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_83b83c2e5765
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_83b83c2e ON t_ci_partitioned (id) LOCAL INCLUDE (note) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_e581ce730705
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_e581ce73 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_701b8e14fb99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_701b8e14 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_a82f014c0633
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_a82f014c ON t_ci_partitioned (id) LOCAL INCLUDE (note) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_a50e66c90576
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_a50e66c9 ON t_ci_partitioned (id) LOCAL INCLUDE (note, postcode) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d71a31101659
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d71a3110 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 10) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_6fb057fe307d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_6fb057fe ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 100) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_a2f2cb7838a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_a2f2cb78 ON t_ci_partitioned (id) LOCAL WITH (lpi_parallel_method = 'partition') COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d9248805eea6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d9248805 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 10) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_6ad1e284e2c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_6ad1e284 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 10) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_fe72a00a3046
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_fe72a00a ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 70) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d98d3e992d60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d98d3e99 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 70) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_7019efee3ee9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_7019efee ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 100) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_cac1112f2317
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_cac1112f ON t_ci_partitioned (id) LOCAL WITH (lpi_parallel_method = 'partition') VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_dd0d98ca5e71
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_dd0d98ca ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 10) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_f335aef30e50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_f335aef3 ON t_ci_partitioned (id) LOCAL WITH (fillfactor = 70) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_9ae67b3b4109
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_lpi_partition", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_9ae67b3b ON t_ci_partitioned (id) LOCAL WITH (lpi_parallel_method = 'partition') TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_81091db8321e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_81091db8 ON t_ci_partitioned (id) LOCAL COMMENT 'factor index' INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_71eb7cad8515
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_71eb7cad ON t_ci_partitioned (id) LOCAL COMMENT 'factor index' TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_d0f5a1966a7e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_d0f5a196 ON t_ci_partitioned (id) LOCAL VISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_partition_positive_588564a064f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_partitioned", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '300001'), (101, 'two', 'Beta', '300002');
-- test_sql:
CREATE INDEX idx_ci_partition_588564a0 ON t_ci_partitioned (id) LOCAL INVISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
