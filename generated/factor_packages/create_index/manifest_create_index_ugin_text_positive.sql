-- generated_from: manifest_create_index_ugin_text_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_index_ugin_text_positive_9c23d750d74e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_trgm", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ugin_text", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
CREATE TABLE t_ci_ugin_text (name VARCHAR(100), note VARCHAR(100)) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_text (name, note) VALUES ('qwertyu0001', 'first'), ('2024新年快乐7days', 'second');
-- test_sql:
CREATE INDEX idx_ci_ut_9c23d750 ON t_ci_ugin_text USING ugin (name ugin_trgm_ops);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;

-- case_id: manifest_create_index_ugin_text_positive_8bef10c0cc36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_trgm", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fastupdate_on", "table_profile": "ci_table_ugin_text", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
CREATE TABLE t_ci_ugin_text (name VARCHAR(100), note VARCHAR(100)) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_text (name, note) VALUES ('qwertyu0001', 'first'), ('2024新年快乐7days', 'second');
-- test_sql:
CREATE INDEX idx_ci_ut_8bef10c0 ON t_ci_ugin_text USING ugin (name ugin_trgm_ops) WITH (fastupdate = on);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;

-- case_id: manifest_create_index_ugin_text_positive_bb6c1a8c7121
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_trgm", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_gin_pending_64", "table_profile": "ci_table_ugin_text", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
CREATE TABLE t_ci_ugin_text (name VARCHAR(100), note VARCHAR(100)) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_text (name, note) VALUES ('qwertyu0001', 'first'), ('2024新年快乐7days', 'second');
-- test_sql:
CREATE INDEX idx_ci_ut_bb6c1a8c ON t_ci_ugin_text USING ugin (name ugin_trgm_ops) WITH (gin_pending_list_limit = 64);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;

-- case_id: manifest_create_index_ugin_text_positive_12894853c0b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_ugin_trgm", "method": "ci_method_ugin", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_gin_pending_max", "table_profile": "ci_table_ugin_text", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
CREATE TABLE t_ci_ugin_text (name VARCHAR(100), note VARCHAR(100)) WITH (storage_type=ustore);
INSERT INTO t_ci_ugin_text (name, note) VALUES ('qwertyu0001', 'first'), ('2024新年快乐7days', 'second');
-- test_sql:
CREATE INDEX idx_ci_ut_12894853 ON t_ci_ugin_text USING ugin (name ugin_trgm_ops) WITH (gin_pending_list_limit = 2147483647);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ugin_text CASCADE;
