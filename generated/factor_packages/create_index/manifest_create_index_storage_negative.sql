-- generated_from: manifest_create_index_storage_negative
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_index_storage_negative_689dfa8e3639
-- expected: error
-- expected_error_category: invalid_index_storage_parameter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_9", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_st_bad_689dfa8e ON t_ci_astore (id) WITH (fillfactor = 9);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_storage_negative_b05a3f44d11e
-- expected: error
-- expected_error_category: invalid_index_storage_parameter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_101", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_st_bad_b05a3f44 ON t_ci_astore (id) WITH (fillfactor = 101);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_storage_negative_2cc0fb704f40
-- expected: error
-- expected_error_category: invalid_index_storage_parameter
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_encrypt_algo_manual", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_st_bad_2cc0fb70 ON t_ci_astore (id) WITH (encrypt_algo = 'AES_128_CTR');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
