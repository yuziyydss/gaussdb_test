-- generated_from: manifest_create_index_concurrent_positive
-- static_only: true
-- case_count: 17

-- case_id: manifest_create_index_concurrent_positive_aba053ff1442
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_aba053ff ON t_ci_regular (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_91958b80edc8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_temporary", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_online_91958b80 ON t_ci_temp USING btree (name ASC NULLS LAST) INCLUDE (note) WITH (fillfactor = 70) COMMENT 'factor index' VISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_48c63d61cc20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_48c63d61 ON t_ci_regular (name DESC NULLS FIRST) INCLUDE (note, postcode) WITH (fillfactor = 70) COMMENT 'factor index' INVISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_4f8672291db8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_online_4f867229 ON t_ci_temp USING btree (name DESC NULLS LAST) INCLUDE (note, postcode) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_c7d7fc255103
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_temporary", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_online_c7d7fc25 ON t_ci_temp USING btree (id, note) COMMENT 'factor index' TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_83c29cb056a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_83c29cb0 ON t_ci_regular (name ASC NULLS LAST) INCLUDE (note) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_4c4bd36ec0c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY idx_ci_online_4c4bd36e ON t_ci_regular (id, note) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_d369005a9e52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_d369005a ON t_ci_regular USING btree (name DESC NULLS LAST) WITH (fillfactor = 70) VISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_1d864180d676
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_online_1d864180 ON t_ci_temp (id) INCLUDE (note) WITH (fillfactor = 70) COMMENT 'factor index' INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_61432d393cd5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_temporary", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_temp CASCADE;
CREATE TEMP TABLE t_ci_temp (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_temp (id, note, name, postcode, payload) VALUES (11, 'temp_one', 'TempAlpha', '200001', NULL), (12, 'temp_two', 'TempBeta', '200002', NULL);
-- test_sql:
CREATE UNIQUE INDEX CONCURRENTLY idx_ci_online_61432d39 ON t_ci_temp USING btree (name DESC NULLS FIRST) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_temp CASCADE;

-- case_id: manifest_create_index_concurrent_positive_15fd8c6b759e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_online_15fd8c6b ON t_ci_regular USING btree (id) INCLUDE (note, postcode) VISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_677a29962848
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_677a2996 ON t_ci_regular (name DESC NULLS LAST) INCLUDE (note) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_c90442dfd420
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_c90442df ON t_ci_regular (name ASC NULLS LAST) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_756caff9922c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_756caff9 ON t_ci_regular (name ASC NULLS LAST) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_cbef2744189e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ci_online_cbef2744 ON t_ci_regular (name DESC NULLS FIRST) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_0ff3917ac2b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_0ff3917a ON t_ci_regular (id, note) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_concurrent_positive_98f1b02bb38d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_98f1b02b ON t_ci_regular (id, note) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
