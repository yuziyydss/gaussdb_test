-- generated_from: manifest_truncate_partition_name_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_truncate_partition_name_positive_69d9d8b1633b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE t_tr_partitioned TRUNCATE PARTITION p_low;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_37837fdd8dee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_present", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_only_prefix", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_present"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE IF EXISTS ONLY t_tr_partitioned TRUNCATE PARTITION p_low UPDATE GLOBAL INDEX;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_cfea6389db5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_star", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_present"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE t_tr_partitioned * TRUNCATE PARTITION p_low UPDATE GLOBAL INDEX;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_96d3c18b0974
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_present", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_only_paren", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE IF EXISTS ONLY (t_tr_partitioned) TRUNCATE PARTITION p_low;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_4eb8281351fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_only_prefix", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE ONLY t_tr_partitioned TRUNCATE PARTITION p_low;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_ad4f1e6e31b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_only_paren", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_present"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE ONLY (t_tr_partitioned) TRUNCATE PARTITION p_low UPDATE GLOBAL INDEX;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_bed77374d980
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_present", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_plain", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_present"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE IF EXISTS t_tr_partitioned TRUNCATE PARTITION p_low UPDATE GLOBAL INDEX;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;

-- case_id: manifest_truncate_partition_name_positive_43c6230a7434
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_present", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_name", "partition_table_profile": "tr_partition_table_star", "partition_value_profile": "tr_partition_values_one", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));
INSERT INTO t_tr_partitioned VALUES (1, 'low'), (11, 'high');
-- test_sql:
ALTER TABLE IF EXISTS t_tr_partitioned * TRUNCATE PARTITION p_low;
-- fixture_teardown:
DROP TABLE IF EXISTS t_tr_partitioned CASCADE;
