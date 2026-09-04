-- generated_from: manifest_truncate_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_truncate_restrict_negative_e02a45687549
-- expected: error
-- expected_error_category: truncate_foreign_key_restrict
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE t_tr_fk_parent;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_restrict_negative_dbfec4611ec5
-- expected: error
-- expected_error_category: truncate_foreign_key_restrict
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_restrict", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE TABLE t_tr_fk_parent RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_restrict_negative_4f3bb3dd780c
-- expected: error
-- expected_error_category: truncate_foreign_key_restrict
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_restrict", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE t_tr_fk_parent RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_restrict_negative_698725a7423d
-- expected: error
-- expected_error_category: truncate_foreign_key_restrict
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE TABLE t_tr_fk_parent;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
