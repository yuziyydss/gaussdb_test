-- generated_from: manifest_create_index_online_expression_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_online_expression_negative_d938f7680f8c
-- expected: error
-- expected_error_category: online_expression_index_not_supported
-- expected_sqlstates: -
-- expected_error_regex: (?i)(concurrently|expression|online|not support)
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_expression_lower_name", "method": "ci_method_default", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
CREATE TABLE t_ci_regular (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6), payload BLOB);
INSERT INTO t_ci_regular (id, note, name, postcode, payload) VALUES (1, 'one', 'Alpha', '100001', NULL), (2, 'two', 'Beta', '100002', NULL);
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_online_expr_d938f768 ON t_ci_regular ((lower(name)));
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
