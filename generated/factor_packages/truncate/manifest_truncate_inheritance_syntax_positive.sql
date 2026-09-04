-- generated_from: manifest_truncate_inheritance_syntax_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_truncate_inheritance_syntax_positive_adf9d4aa6867
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_inheritance_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
CREATE TABLE t_tr_parent (id INTEGER NOT NULL);
CREATE TABLE t_tr_child () INHERITS (t_tr_parent);
INSERT INTO t_tr_parent VALUES (1);
INSERT INTO t_tr_child VALUES (2);
-- test_sql:
TRUNCATE t_tr_parent;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;

-- case_id: manifest_truncate_inheritance_syntax_positive_eb8ff79be382
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_inheritance_star", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
CREATE TABLE t_tr_parent (id INTEGER NOT NULL);
CREATE TABLE t_tr_child () INHERITS (t_tr_parent);
INSERT INTO t_tr_parent VALUES (1);
INSERT INTO t_tr_child VALUES (2);
-- test_sql:
TRUNCATE TABLE ONLY t_tr_parent * CONTINUE IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;

-- case_id: manifest_truncate_inheritance_syntax_positive_94a1d86380a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_inheritance_star", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
CREATE TABLE t_tr_parent (id INTEGER NOT NULL);
CREATE TABLE t_tr_child () INHERITS (t_tr_parent);
INSERT INTO t_tr_parent VALUES (1);
INSERT INTO t_tr_child VALUES (2);
-- test_sql:
TRUNCATE t_tr_parent * CONTINUE IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;

-- case_id: manifest_truncate_inheritance_syntax_positive_258622ea33a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_inheritance_parent", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
CREATE TABLE t_tr_parent (id INTEGER NOT NULL);
CREATE TABLE t_tr_child () INHERITS (t_tr_parent);
INSERT INTO t_tr_parent VALUES (1);
INSERT INTO t_tr_child VALUES (2);
-- test_sql:
TRUNCATE TABLE ONLY t_tr_parent;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;

-- case_id: manifest_truncate_inheritance_syntax_positive_9736a613f4e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_inheritance_parent", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
CREATE TABLE t_tr_parent (id INTEGER NOT NULL);
CREATE TABLE t_tr_child () INHERITS (t_tr_parent);
INSERT INTO t_tr_parent VALUES (1);
INSERT INTO t_tr_child VALUES (2);
-- test_sql:
TRUNCATE ONLY t_tr_parent CONTINUE IDENTITY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;

-- case_id: manifest_truncate_inheritance_syntax_positive_2b9b1c02f7fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_inheritance_star", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
CREATE TABLE t_tr_parent (id INTEGER NOT NULL);
CREATE TABLE t_tr_child () INHERITS (t_tr_parent);
INSERT INTO t_tr_parent VALUES (1);
INSERT INTO t_tr_child VALUES (2);
-- test_sql:
TRUNCATE TABLE t_tr_parent *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_child CASCADE;
DROP TABLE IF EXISTS t_tr_parent CASCADE;
