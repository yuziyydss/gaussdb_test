-- generated_from: manifest_create_index_concurrent_positive
-- static_only: true
-- case_count: 17

-- case_id: manifest_create_index_concurrent_positive_3b517e92d5fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_3b517e92 ON t_ci_astore (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_concurrent_positive_644e75d225d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_on_644e75d2 ON t_ci_partitioned USING btree (id, note) LOCAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_fcfad80b12ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_on_fcfad80b ON t_ci_ustore USING ubtree (name ASC NULLS LAST) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_concurrent_positive_c6fbf9877358
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY idx_ci_on_c6fbf987 ON t_ci_partitioned USING ubtree (name ASC NULLS LAST) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_5e1ec0a1e1a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_5e1ec0a1 ON t_ci_temp USING btree (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_3522ed914461
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_on_3522ed91 ON t_ci_partitioned (id) GLOBAL WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_081ac9def6ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY idx_ci_on_081ac9de ON t_ci_ustore (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_concurrent_positive_62037c381e44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY idx_ci_on_62037c38 ON t_ci_astore USING btree (name ASC NULLS LAST) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_concurrent_positive_e0459653acce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_on_e0459653 ON t_ci_temp (name ASC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_dd8631bdc579
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_dd8631bd ON t_ci_partitioned USING ubtree (id) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_56cbf6fa0df3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_on_56cbf6fa ON t_ci_astore USING ubtree (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_concurrent_positive_464096335629
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_astore_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_46409633 ON t_ci_temp USING btree (id) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_4f10918c1688
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_4f10918c ON t_ci_partitioned (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_db5e254da474
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_db5e254d ON t_ci_ustore USING btree (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_concurrent_positive_6c23c3a63567
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_6c23c3a6 ON t_ci_partitioned (name ASC NULLS LAST) LOCAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_e498d95503cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_global", "statement_form": "ci_statement_partition", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_partitioned", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;
CREATE TABLE t_ci_partitioned (id INTEGER, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB, info INT[]) WITH (storage_type=astore) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (100), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_ci_partitioned (id, note, name, postcode, info) VALUES (1, 'one', 'Alpha', '300001', ARRAY[1,2]), (101, 'two', 'Beta', '300002', ARRAY[2,3]);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_e498d955 ON t_ci_partitioned USING btree (id, note) GLOBAL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_partitioned CASCADE;

-- case_id: manifest_create_index_concurrent_positive_ef6c6ee3552f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_on_ef6c6ee3 ON t_ci_temp USING ubtree (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
