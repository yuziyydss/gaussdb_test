-- generated_from: manifest_create_index_regular_positive
-- static_only: true
-- case_count: 149

-- case_id: manifest_create_index_regular_positive_7fbc9894dc90
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_7fbc9894 ON t_ci_regular (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_5067600177ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX IF NOT EXISTS idx_ci_regular_50676001 ON t_ci_regular (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_328e11904e42
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular USING btree (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_7ca264fa68f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_7ca264fa ON t_ci_regular (name ASC NULLS LAST) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e5017a8a40ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_e5017a8a ON t_ci_regular (name DESC NULLS FIRST) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d880c2635fca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_d880c263 ON t_ci_regular (id, note) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_f722be04f717
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_f722be04 ON t_ci_regular (name DESC NULLS LAST) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ecec4cf75c63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_ecec4cf7 ON t_ci_regular ((lower(name))) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d2a969b793f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_d2a969b7 ON t_ci_regular ((abs(id))) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_809df6a62a8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_809df6a6 ON t_ci_regular (id) VISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a7c13260ffe9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_a7c13260 ON t_ci_regular (id) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_da5a8f9f3484
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_da5a8f9f ON t_ci_regular USING btree (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_532448a90121
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a2ebca9dc6f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_a2ebca9d ON t_ci_regular (name ASC NULLS LAST) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_886c0144a887
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_886c0144 ON t_ci_regular (name DESC NULLS FIRST) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a59eb38c7a76
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_a59eb38c ON t_ci_regular (name DESC NULLS LAST) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_6ba33d1549cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_6ba33d15 ON t_ci_regular (id) INCLUDE (note) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a84bdaa0b549
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_a84bdaa0 ON t_ci_regular (id) INCLUDE (note, postcode) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_c4f8d4c78493
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_c4f8d4c7 ON t_ci_regular (id) WITH (fillfactor = 100) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_c4940df5a8ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_c4940df5 ON t_ci_regular ((lower(name)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_08c7ff64447e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_08c7ff64 ON t_ci_regular ((abs(id)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ebf6a215bb53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX ON t_ci_regular (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d0a39e469287
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_d0a39e46 ON t_ci_regular USING btree (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_229dfdec9be3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_229dfdec ON t_ci_regular (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_372bc5df400d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_372bc5df ON t_ci_regular (name ASC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_213025b6d326
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_213025b6 ON t_ci_regular (name DESC NULLS FIRST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_85bb0a128ce3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_85bb0a12 ON t_ci_regular (name DESC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_5563c8c71866
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_5563c8c7 ON t_ci_regular (id) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9df0e75e6d08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_9df0e75e ON t_ci_regular (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_af541802bbe2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_af541802 ON t_ci_regular (id) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_c17d4b4f58b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_c17d4b4f ON t_ci_regular (id) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b203eb74199d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_b203eb74 ON t_ci_regular (id) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_3f6233375511
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_3f623337 ON t_ci_regular (id) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e8932e53ee6c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_e8932e53 ON t_ci_regular (id) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_eecf51a4e7b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE UNIQUE INDEX idx_ci_regular_eecf51a4 ON t_ci_regular (id) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_f2f51e77b538
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_f2f51e77 ON t_ci_regular (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_2e10ac3d1426
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_2e10ac3d ON t_ci_regular (name ASC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_815413f5f175
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_815413f5 ON t_ci_regular (name DESC NULLS FIRST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b44044b27f22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_b44044b2 ON t_ci_regular (name DESC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ef352f51278e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_ef352f51 ON t_ci_regular ((lower(name)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_2a9b2b0946b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_2a9b2b09 ON t_ci_regular ((abs(id)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_4ca6c04afd9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_4ca6c04a ON t_ci_regular (id) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_672057894b3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_67205789 ON t_ci_regular (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_cd345908e9d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_cd345908 ON t_ci_regular (id) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e2c7540882ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_e2c75408 ON t_ci_regular (id) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_7ff45ee9a2ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_7ff45ee9 ON t_ci_regular (id) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b0c5d3a00a99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_b0c5d3a0 ON t_ci_regular (id) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_90f3a4c68a6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_90f3a4c6 ON t_ci_regular (id) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_36887625cb17
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_36887625 ON t_ci_regular (id) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_3b66916079d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX IF NOT EXISTS idx_ci_regular_3b669160 ON t_ci_regular (id) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_bf30a56c3c02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (name ASC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e693b8721760
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (name DESC NULLS FIRST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a076386de91e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (name DESC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_7e674c3e4dd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular ((lower(name)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_161b65d13f0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular ((abs(id)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_f022095050ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9b00b58f3152
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d4ebded51b53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_2ea185433b90
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9001117682f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a172e5b88c45
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_805f9adfd3ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e2d15189f6c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_581b99a38b5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_absent", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX ON t_ci_regular (id) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_64bf498be9b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_64bf498b ON t_ci_regular USING btree (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e70b57b0d753
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_e70b57b0 ON t_ci_regular USING btree (name ASC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9c4e057c9bea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_9c4e057c ON t_ci_regular USING btree (name DESC NULLS FIRST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ce0722833ec0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_ce072283 ON t_ci_regular USING btree (name DESC NULLS LAST);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_1e1afa5deebc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_1e1afa5d ON t_ci_regular USING btree ((lower(name)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_1338c8e1da0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_1338c8e1 ON t_ci_regular USING btree ((abs(id)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_bbad196f2ca3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_bbad196f ON t_ci_regular USING btree (id) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_aadfea8ffcba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_aadfea8f ON t_ci_regular USING btree (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d63357bde713
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_d63357bd ON t_ci_regular USING btree (id) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_04f4b26e6d4f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_04f4b26e ON t_ci_regular USING btree (id) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_fd2cc56307dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_fd2cc563 ON t_ci_regular USING btree (id) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_61388ac58837
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_61388ac5 ON t_ci_regular USING btree (id) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_fbbe24cd3129
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_fbbe24cd ON t_ci_regular USING btree (id) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_f8239bae9192
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_f8239bae ON t_ci_regular USING btree (id) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_88d357102f09
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_88d35710 ON t_ci_regular USING btree (id) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_196b3281b434
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_196b3281 ON t_ci_regular (name ASC NULLS LAST) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_126f4de5689e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_126f4de5 ON t_ci_regular (name DESC NULLS FIRST) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_c99b62d15852
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_c99b62d1 ON t_ci_regular (name DESC NULLS LAST) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_6b4f9e05fa64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_6b4f9e05 ON t_ci_regular (name DESC NULLS LAST) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_14f7aea9a086
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_14f7aea9 ON t_ci_regular ((lower(name))) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_2d0d95e27ee8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_2d0d95e2 ON t_ci_regular ((lower(name))) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_2d8dbb9f2cea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_2d8dbb9f ON t_ci_regular ((abs(id))) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_f9bc4274da8c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_f9bc4274 ON t_ci_regular ((abs(id))) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_58c425034a2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_58c42503 ON t_ci_regular (id, note) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a11891fde2b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_a11891fd ON t_ci_regular (id, note) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d4f51c7f5422
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_d4f51c7f ON t_ci_regular (name ASC NULLS LAST) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_7efd232ac737
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_7efd232a ON t_ci_regular (name ASC NULLS LAST) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_410f0d742413
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_410f0d74 ON t_ci_regular (name ASC NULLS LAST) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_7ff90fe0ccb7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_7ff90fe0 ON t_ci_regular (name DESC NULLS FIRST) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_250118c43c13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_250118c4 ON t_ci_regular (name DESC NULLS FIRST) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_50c46a0f724f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_50c46a0f ON t_ci_regular (name DESC NULLS FIRST) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_297c32a3ce20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_297c32a3 ON t_ci_regular (name DESC NULLS LAST) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_1160a374ee0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_1160a374 ON t_ci_regular (name DESC NULLS LAST) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_832b4e6aa9ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_832b4e6a ON t_ci_regular ((lower(name))) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9ca56c327456
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_9ca56c32 ON t_ci_regular ((lower(name))) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_93419c266e02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_93419c26 ON t_ci_regular ((abs(id))) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_313c9595b91a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_313c9595 ON t_ci_regular ((abs(id))) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_a9c06a342041
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_a9c06a34 ON t_ci_regular ((abs(id))) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_560c5c3af624
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_560c5c3a ON t_ci_regular (id, note) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ee4cf44cb61f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_ee4cf44c ON t_ci_regular (name ASC NULLS LAST) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_7555cc981164
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_7555cc98 ON t_ci_regular (name DESC NULLS FIRST) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ad627d8e3545
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_ad627d8e ON t_ci_regular (name DESC NULLS LAST) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_1c9a4e49623a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_1c9a4e49 ON t_ci_regular ((lower(name))) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_0d32d6d2a026
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_0d32d6d2 ON t_ci_regular (id, note) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b5b0a1408217
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_b5b0a140 ON t_ci_regular (id, note) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_44edf737154a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_44edf737 ON t_ci_regular (name ASC NULLS LAST) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_505a14f51a01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_505a14f5 ON t_ci_regular (name DESC NULLS FIRST) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_552fe10a24b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_552fe10a ON t_ci_regular (name DESC NULLS LAST) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d1889fc1d58f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_d1889fc1 ON t_ci_regular (name DESC NULLS LAST) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_e775e79deeb6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_e775e79d ON t_ci_regular ((lower(name))) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_4b2a0af2228b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_4b2a0af2 ON t_ci_regular ((lower(name))) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_d4db07d445cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_d4db07d4 ON t_ci_regular ((abs(id))) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b8c4ea091e80
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_b8c4ea09 ON t_ci_regular ((abs(id))) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_4ae5a1442b74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_4ae5a144 ON t_ci_regular (id, note) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_5b3516b1b68e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_5b3516b1 ON t_ci_regular (name ASC NULLS LAST) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_5d4709d27353
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_desc_nulls_first", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_5d4709d2 ON t_ci_regular (name DESC NULLS FIRST) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_cc9c4cf781b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_cc9c4cf7 ON t_ci_regular ((lower(name))) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b52446ca2d34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_abs_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_b52446ca ON t_ci_regular ((abs(id))) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_eb54a3c87892
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_eb54a3c8 ON t_ci_regular (id) INCLUDE (note) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ef7ba173c143
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_ef7ba173 ON t_ci_regular (id) INCLUDE (note) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_0217f49d85d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_0217f49d ON t_ci_regular (id) INCLUDE (note, postcode) WITH (fillfactor = 10);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9cb5e1128f7f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_9cb5e112 ON t_ci_regular (id) INCLUDE (note, postcode) WITH (fillfactor = 100);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_cd61d904c167
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_cd61d904 ON t_ci_regular (id) INCLUDE (note) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_3db3b7035080
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_3db3b703 ON t_ci_regular (id) INCLUDE (note, postcode) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9f46de931d6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_9f46de93 ON t_ci_regular (id) INCLUDE (note) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_21f7c16ece67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_21f7c16e ON t_ci_regular (id) INCLUDE (note) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_5febca2d3604
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_5febca2d ON t_ci_regular (id) INCLUDE (note, postcode) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_cc4c33a3414d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_cc4c33a3 ON t_ci_regular (id) INCLUDE (note, postcode) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_502328da574f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_502328da ON t_ci_regular (id) INCLUDE (note) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_27a39b4f3f33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_27a39b4f ON t_ci_regular (id) INCLUDE (note, postcode) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_b4f6d7349b62
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_b4f6d734 ON t_ci_regular (id) WITH (fillfactor = 10) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_059aef67e875
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_059aef67 ON t_ci_regular (id) WITH (fillfactor = 70) COMMENT 'factor index';
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_4d4467254ef4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_4d446725 ON t_ci_regular (id) WITH (fillfactor = 10) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_72b225bd24b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_72b225bd ON t_ci_regular (id) WITH (fillfactor = 10) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_72b9b2f1b5d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_72b9b2f1 ON t_ci_regular (id) WITH (fillfactor = 70) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_483c91b1e0d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_483c91b1 ON t_ci_regular (id) WITH (fillfactor = 70) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_9306cc2e5f43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_9306cc2e ON t_ci_regular (id) WITH (fillfactor = 100) VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_f281e87b4dc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_f281e87b ON t_ci_regular (id) WITH (fillfactor = 100) INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_ce63051f806f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_10", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_ce63051f ON t_ci_regular (id) WITH (fillfactor = 10) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_22b0f3bf7598
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_22b0f3bf ON t_ci_regular (id) WITH (fillfactor = 70) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_8d87bb0f7560
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_100", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_8d87bb0f ON t_ci_regular (id) WITH (fillfactor = 100) TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_3f35887590ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_visible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_3f358875 ON t_ci_regular (id) COMMENT 'factor index' VISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_c55408a35b18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_c55408a3 ON t_ci_regular (id) COMMENT 'factor index' INVISIBLE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_61c9f3c7dc5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_basic", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_61c9f3c7 ON t_ci_regular (id) COMMENT 'factor index' TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_regular_positive_64f753ec04e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_default", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_invisible"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_regular_64f753ec ON t_ci_regular (id) INVISIBLE TABLESPACE gs_default;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
