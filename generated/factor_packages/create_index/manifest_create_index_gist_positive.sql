-- generated_from: manifest_create_index_gist_positive
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_index_gist_positive_a39cc7bdbd94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gist_point", "method": "ci_method_gist", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_gist_point", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gist_point CASCADE;
CREATE TABLE t_ci_gist_point (location POINT, id INTEGER NOT NULL);
INSERT INTO t_ci_gist_point (location, id) VALUES ('(1,2)', 1);
-- test_sql:
CREATE INDEX idx_ci_gist_a39cc7bd ON t_ci_gist_point USING gist (location);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gist_point CASCADE;

-- case_id: manifest_create_index_gist_positive_b3b2cf65b043
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gist_point", "method": "ci_method_gist", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_gist_point", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gist_point CASCADE;
CREATE TABLE t_ci_gist_point (location POINT, id INTEGER NOT NULL);
INSERT INTO t_ci_gist_point (location, id) VALUES ('(1,2)', 1);
-- test_sql:
CREATE INDEX idx_ci_gist_b3b2cf65 ON t_ci_gist_point USING gist (location) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gist_point CASCADE;

-- case_id: manifest_create_index_gist_positive_acb171b53a1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_gist_point", "method": "ci_method_gist", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_gist_buffering_auto", "table_profile": "ci_table_gist_point", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_gist_point CASCADE;
CREATE TABLE t_ci_gist_point (location POINT, id INTEGER NOT NULL);
INSERT INTO t_ci_gist_point (location, id) VALUES ('(1,2)', 1);
-- test_sql:
CREATE INDEX idx_ci_gist_acb171b5 ON t_ci_gist_point USING gist (location) WITH (buffering = auto);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_gist_point CASCADE;
