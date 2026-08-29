-- generated_from: manifest_create_index_key_definition_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_create_index_key_definition_negative_8611b3a6f8d7
-- expected: error
-- expected_error_category: unsupported_index_key_definition
-- expected_sqlstates: -
-- expected_error_regex: (?i)(index|expression|is null|blob|clob|not support|invalid)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_is_null_invalid", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_bad_key_8611b3a6 ON t_ci_regular ((id IS NULL));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;

-- case_id: manifest_create_index_key_definition_negative_c56bd8269cf5
-- expected: error
-- expected_error_category: unsupported_index_key_definition
-- expected_sqlstates: -
-- expected_error_regex: (?i)(index|expression|is null|blob|clob|not support|invalid)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_blob_invalid", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX idx_ci_bad_key_c56bd826 ON t_ci_regular (payload);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
