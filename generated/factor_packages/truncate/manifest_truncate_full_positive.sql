-- generated_from: manifest_truncate_full_positive
-- static_only: true
-- case_count: 12

-- case_id: manifest_truncate_full_positive_b38263bc10ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_regular CASCADE;
CREATE TABLE t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE t_tr_regular;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_regular CASCADE;

-- case_id: manifest_truncate_full_positive_14b9bbe929ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_restrict", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_schema_qualified", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;
CREATE SCHEMA tr_fixture_schema;
CREATE TABLE tr_fixture_schema.t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO tr_fixture_schema.t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE TABLE ONLY tr_fixture_schema.t_tr_regular CONTINUE IDENTITY RESTRICT PURGE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;

-- case_id: manifest_truncate_full_positive_21858e15e5c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_two", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_one CASCADE;
DROP TABLE IF EXISTS t_tr_two CASCADE;
CREATE TABLE t_tr_one (id INTEGER NOT NULL);
CREATE TABLE t_tr_two (id INTEGER NOT NULL);
INSERT INTO t_tr_one VALUES (1);
INSERT INTO t_tr_two VALUES (2);
-- test_sql:
TRUNCATE t_tr_one, t_tr_two CONTINUE IDENTITY CASCADE PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_two CASCADE;
DROP TABLE IF EXISTS t_tr_one CASCADE;

-- case_id: manifest_truncate_full_positive_44531df34c3e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_two", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_one CASCADE;
DROP TABLE IF EXISTS t_tr_two CASCADE;
CREATE TABLE t_tr_one (id INTEGER NOT NULL);
CREATE TABLE t_tr_two (id INTEGER NOT NULL);
INSERT INTO t_tr_one VALUES (1);
INSERT INTO t_tr_two VALUES (2);
-- test_sql:
TRUNCATE TABLE ONLY t_tr_one, t_tr_two CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_two CASCADE;
DROP TABLE IF EXISTS t_tr_one CASCADE;

-- case_id: manifest_truncate_full_positive_426b9acb558d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_restrict", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_schema_qualified", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;
CREATE SCHEMA tr_fixture_schema;
CREATE TABLE tr_fixture_schema.t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO tr_fixture_schema.t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE tr_fixture_schema.t_tr_regular RESTRICT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;

-- case_id: manifest_truncate_full_positive_5b9408290bba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_regular CASCADE;
CREATE TABLE t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE TABLE ONLY t_tr_regular CONTINUE IDENTITY PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_regular CASCADE;

-- case_id: manifest_truncate_full_positive_777bdcc8dc4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_restrict", "full_scope": "tr_scope_only", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_present", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_regular CASCADE;
CREATE TABLE t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE ONLY t_tr_regular RESTRICT PURGE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_regular CASCADE;

-- case_id: manifest_truncate_full_positive_c074a19f23d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_continue", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_present", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_regular CASCADE;
CREATE TABLE t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE TABLE t_tr_regular CONTINUE IDENTITY CASCADE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_regular CASCADE;

-- case_id: manifest_truncate_full_positive_c1a56fe1c4b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_schema_qualified", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;
CREATE SCHEMA tr_fixture_schema;
CREATE TABLE tr_fixture_schema.t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO tr_fixture_schema.t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE tr_fixture_schema.t_tr_regular;
-- fixture_teardown:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;

-- case_id: manifest_truncate_full_positive_8c192cc8876a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_cascade", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_schema_qualified", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;
CREATE SCHEMA tr_fixture_schema;
CREATE TABLE tr_fixture_schema.t_tr_regular (id INTEGER NOT NULL, note VARCHAR(32));
INSERT INTO tr_fixture_schema.t_tr_regular (id, note) VALUES (1, 'one'), (2, 'two');
-- test_sql:
TRUNCATE tr_fixture_schema.t_tr_regular CASCADE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS tr_fixture_schema CASCADE;

-- case_id: manifest_truncate_full_positive_2ba6e7e96cf8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_two", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_one CASCADE;
DROP TABLE IF EXISTS t_tr_two CASCADE;
CREATE TABLE t_tr_one (id INTEGER NOT NULL);
CREATE TABLE t_tr_two (id INTEGER NOT NULL);
INSERT INTO t_tr_one VALUES (1);
INSERT INTO t_tr_two VALUES (2);
-- test_sql:
TRUNCATE t_tr_one, t_tr_two;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_two CASCADE;
DROP TABLE IF EXISTS t_tr_one CASCADE;

-- case_id: manifest_truncate_full_positive_afe78732edaf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_restrict", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_two", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_full", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_one CASCADE;
DROP TABLE IF EXISTS t_tr_two CASCADE;
CREATE TABLE t_tr_one (id INTEGER NOT NULL);
CREATE TABLE t_tr_two (id INTEGER NOT NULL);
INSERT INTO t_tr_one VALUES (1);
INSERT INTO t_tr_two VALUES (2);
-- test_sql:
TRUNCATE t_tr_one, t_tr_two RESTRICT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_two CASCADE;
DROP TABLE IF EXISTS t_tr_one CASCADE;
