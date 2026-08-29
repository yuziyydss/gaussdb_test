-- generated_from: manifest_create_index_schema_positive
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_schema_positive_bc161833356a
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
CREATE INDEX public.idx_ci_schema_bc161833 ON t_ci_regular (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_regular CASCADE;
