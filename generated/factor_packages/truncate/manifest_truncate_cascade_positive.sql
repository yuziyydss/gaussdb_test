-- generated_from: manifest_truncate_cascade_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_truncate_cascade_positive_d98a4e0ecbc1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE t_tr_fk_parent CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_cascade_positive_b5ad81dd971c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE TABLE ONLY t_tr_fk_parent CONTINUE IDENTITY CASCADE PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_cascade_positive_378484c9e765
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE t_tr_fk_parent CONTINUE IDENTITY CASCADE PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_cascade_positive_fc9300001757
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE TABLE ONLY t_tr_fk_parent CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_cascade_positive_e7aa5ecf2875
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE ONLY t_tr_fk_parent CASCADE PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;

-- case_id: manifest_truncate_cascade_positive_5073aab55c86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_fk_parent", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
CREATE TABLE t_tr_fk_parent (id INTEGER PRIMARY KEY);
CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));
INSERT INTO t_tr_fk_parent VALUES (1);
INSERT INTO t_tr_fk_child VALUES (1, 1);
-- test_sql:
TRUNCATE TABLE t_tr_fk_parent CONTINUE IDENTITY CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_fk_child CASCADE;
DROP TABLE IF EXISTS t_tr_fk_parent CASCADE;
