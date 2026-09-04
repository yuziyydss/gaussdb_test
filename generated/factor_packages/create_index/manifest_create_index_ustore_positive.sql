-- generated_from: manifest_create_index_ustore_positive
-- static_only: true
-- case_count: 26

-- case_id: manifest_create_index_ustore_positive_aeb794bfe7cf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_aeb794bf ON t_ci_ustore (id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_92885f8044a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_ust_92885f80 ON t_ci_ustore USING btree (name ASC NULLS LAST) INCLUDE (note) WITH (fillfactor = 70) WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_5c704f33989c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_prefix_name_8", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_type_ustore", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_5c704f33 ON t_ci_ustore USING ubtree (name (8)) INCLUDE (note, postcode) WITH (storage_type = USTORE) WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_ba4a736ae8b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_indexsplit_default", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_ust_ba4a736a ON t_ci_ustore USING ubtree (id, note) WITH (indexsplit = default);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_084fcfac3154
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_index_txntype_pcr", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_084fcfac ON t_ci_ustore USING btree (name ASC NULLS LAST) INCLUDE (note, postcode) WITH (index_txntype = 'pcr');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_5942467e4b3e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_stat_state_locked", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_ust_5942467e ON t_ci_ustore (id) INCLUDE (note, postcode) WITH (stat_state = locked) WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_a64dcbcb1d4f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_prefix_name_8", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_a64dcbcb ON t_ci_ustore (name (8)) INCLUDE (note) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_1fbcf0f4c97f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_btree", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_stat_state_locked", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_1fbcf0f4 ON t_ci_ustore USING btree (id, note) WITH (stat_state = locked) WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_c01ee65c6e76
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_index_txntype_pcr", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_ust_c01ee65c ON t_ci_ustore USING ubtree (id) INCLUDE (note) WITH (index_txntype = 'pcr') WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_faec4ae27022
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_type_ustore", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_ust_faec4ae2 ON t_ci_ustore (name ASC NULLS LAST) WITH (storage_type = USTORE);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_fde2207217b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_prefix_name_8", "method": "ci_method_btree", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE UNIQUE INDEX idx_ci_ust_fde22072 ON t_ci_ustore USING btree (name (8)) WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_340935613faa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_id_not_null", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_indexsplit_default", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_34093561 ON t_ci_ustore USING btree (id) INCLUDE (note) WITH (indexsplit = default) WHERE id IS NOT NULL;
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_97f0756fb8fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_stat_state_locked", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_97f0756f ON t_ci_ustore USING ubtree (name ASC NULLS LAST) INCLUDE (note) WITH (stat_state = locked);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_080821eb24e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_index_txntype_pcr", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_080821eb ON t_ci_ustore (id, note) WITH (index_txntype = 'pcr');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_6bbc8235899c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_indexsplit_default", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_6bbc8235 ON t_ci_ustore (name ASC NULLS LAST) INCLUDE (note, postcode) WITH (indexsplit = default);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_dc36c6f40778
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_btree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_type_ustore", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_dc36c6f4 ON t_ci_ustore USING btree (id) INCLUDE (note) WITH (storage_type = USTORE);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_c03c06b15616
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_c03c06b1 ON t_ci_ustore USING ubtree (id) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_0e94dc419229
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_name_asc_nulls_last", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_0e94dc41 ON t_ci_ustore USING ubtree (name ASC NULLS LAST) INCLUDE (note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_91d839b96657
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_91d839b9 ON t_ci_ustore (id) INCLUDE (note, postcode);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_0c9ad11e2068
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_note_postcode", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_0c9ad11e ON t_ci_ustore (id) INCLUDE (note, postcode) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_80aafaa3ff25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_none", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_80aafaa3 ON t_ci_ustore (id, note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_6379d9593cfb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_fillfactor_70", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_6379d959 ON t_ci_ustore (id, note) WITH (fillfactor = 70);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_98983c32664f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id_note", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_storage_type_ustore", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_98983c32 ON t_ci_ustore (id, note) WITH (storage_type = USTORE);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_a2c40fadd14b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_prefix_name_8", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_indexsplit_default", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_a2c40fad ON t_ci_ustore (name (8)) WITH (indexsplit = default);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_a92dac017fd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_prefix_name_8", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_index_txntype_pcr", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_a92dac01 ON t_ci_ustore (name (8)) WITH (index_txntype = 'pcr');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;

-- case_id: manifest_create_index_ustore_positive_267ca671112a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_prefix_name_8", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_stat_state_locked", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX idx_ci_ust_267ca671 ON t_ci_ustore (name (8)) WITH (stat_state = locked);
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
