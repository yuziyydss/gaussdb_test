-- generated_from: manifest_create_index_storage_negative
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_index_storage_negative_9dfeab0946d7
-- expected: error
-- expected_error_category: invalid_index_storage_parameter
-- expected_sqlstates: -
-- expected_error_regex: (?i)(fillfactor|encrypt_algo|storage parameter|range|invalid|not support)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_9", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_bad_storage_9dfeab09 ON t_ci_regular (id) WITH (fillfactor = 9);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_storage_negative_8296c2044509
-- expected: error
-- expected_error_category: invalid_index_storage_parameter
-- expected_sqlstates: -
-- expected_error_regex: (?i)(fillfactor|encrypt_algo|storage parameter|range|invalid|not support)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_101", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_bad_storage_8296c204 ON t_ci_regular (id) WITH (fillfactor = 101);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_storage_negative_8ea393a682fa
-- expected: error
-- expected_error_category: invalid_index_storage_parameter
-- expected_sqlstates: -
-- expected_error_regex: (?i)(fillfactor|encrypt_algo|storage parameter|range|invalid|not support)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_encrypt_algo_manual", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_bad_storage_8ea393a6 ON t_ci_regular (id) WITH (encrypt_algo = 'AES_128_CTR');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
