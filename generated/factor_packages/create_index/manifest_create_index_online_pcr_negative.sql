-- generated_from: manifest_create_index_online_pcr_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_online_pcr_negative_1968adfe47f1
-- expected: error
-- expected_error_category: online_pcr_ubtree_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_default", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_none", "statement_form": "ci_statement_regular", "storage_profile": "ci_index_txntype_pcr", "table_profile": "ci_table_ustore_regular", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
CREATE TABLE t_ci_ustore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6)) WITH (storage_type=ustore);
INSERT INTO t_ci_ustore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
-- test_sql:
CREATE INDEX CONCURRENTLY idx_ci_pcr_bad_1968adfe ON t_ci_ustore (id) WITH (index_txntype = 'pcr');
-- fixture_teardown:
DROP TABLE IF EXISTS t_ci_ustore CASCADE;
