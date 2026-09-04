-- generated_from: manifest_create_index_include_method_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_index_include_method_negative_15f58aa05e7c
-- expected: error
-- expected_error_category: include_requires_ubtree
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_inc_bad_15f58aa0 ON t_ci_astore (id) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_include_method_negative_6d0d7b89c16d
-- expected: error
-- expected_error_category: include_requires_ubtree
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_inc_bad_6d0d7b89 ON t_ci_astore USING btree (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_include_method_negative_5e07af67fe4a
-- expected: error
-- expected_error_category: include_requires_ubtree
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_inc_bad_5e07af67 ON t_ci_astore (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_create_index_include_method_negative_b39b01a52212
-- expected: error
-- expected_error_category: include_requires_ubtree
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_astore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_inc_bad_b39b01a5 ON t_ci_astore USING btree (id) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
