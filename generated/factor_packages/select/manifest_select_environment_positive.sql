-- generated_from: manifest_select_environment_positive
-- static_only: true
-- case_count: 22

-- case_id: manifest_select_environment_positive_9bbc6b173a81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_tablesample_system", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM t_select_source TABLESAMPLE SYSTEM (50) REPEATABLE (1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_7bb36d326796
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_tablesample_bernoulli", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM t_select_source TABLESAMPLE BERNOULLI (50);
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_81ef5bfc4cab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_tablesample_hybrid", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM t_select_source TABLESAMPLE HYBRID (50, 50);
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_8b930083db6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_flashback_timestamp", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_flashback CASCADE;
CREATE TABLE t_select_flashback (col_1 INTEGER NOT NULL, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_select_flashback (col_1, col_2) VALUES (1, 10);
-- test_sql:
SELECT col_1, col_2 FROM t_select_flashback TIMECAPSULE TIMESTAMP (CURRENT_TIMESTAMP - INTERVAL '1 minute');
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_flashback CASCADE;

-- case_id: manifest_select_environment_positive_f64298f12411
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_flashback_csn", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_flashback CASCADE;
CREATE TABLE t_select_flashback (col_1 INTEGER NOT NULL, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_select_flashback (col_1, col_2) VALUES (1, 10);
-- test_sql:
SELECT col_1, col_2 FROM t_select_flashback TIMECAPSULE CSN 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_flashback CASCADE;

-- case_id: manifest_select_environment_positive_e39e12767c3e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_partition_name", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_partitioned CASCADE;
CREATE TABLE t_select_partitioned (col_1 INTEGER NOT NULL, col_2 INTEGER) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (100)
 (SUBPARTITION sp1 VALUES LESS THAN (1000),
  SUBPARTITION sp1_max VALUES LESS THAN (MAXVALUE)),
 PARTITION pmax VALUES LESS THAN (MAXVALUE)
 (SUBPARTITION spmax VALUES LESS THAN (MAXVALUE)));
INSERT INTO t_select_partitioned (col_1, col_2) VALUES (1, 10), (101, 20);
-- test_sql:
SELECT col_1, col_2 FROM t_select_partitioned PARTITION (p1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_partitioned CASCADE;

-- case_id: manifest_select_environment_positive_44d6a5db8e21
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_partition_for", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_partitioned CASCADE;
CREATE TABLE t_select_partitioned (col_1 INTEGER NOT NULL, col_2 INTEGER) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (100)
 (SUBPARTITION sp1 VALUES LESS THAN (1000),
  SUBPARTITION sp1_max VALUES LESS THAN (MAXVALUE)),
 PARTITION pmax VALUES LESS THAN (MAXVALUE)
 (SUBPARTITION spmax VALUES LESS THAN (MAXVALUE)));
INSERT INTO t_select_partitioned (col_1, col_2) VALUES (1, 10), (101, 20);
-- test_sql:
SELECT col_1, col_2 FROM t_select_partitioned PARTITION FOR (1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_partitioned CASCADE;

-- case_id: manifest_select_environment_positive_a44ec3feda94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_subpartition", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_partitioned CASCADE;
CREATE TABLE t_select_partitioned (col_1 INTEGER NOT NULL, col_2 INTEGER) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (100)
 (SUBPARTITION sp1 VALUES LESS THAN (1000),
  SUBPARTITION sp1_max VALUES LESS THAN (MAXVALUE)),
 PARTITION pmax VALUES LESS THAN (MAXVALUE)
 (SUBPARTITION spmax VALUES LESS THAN (MAXVALUE)));
INSERT INTO t_select_partitioned (col_1, col_2) VALUES (1, 10), (101, 20);
-- test_sql:
SELECT col_1, col_2 FROM t_select_partitioned SUBPARTITION (sp1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_partitioned CASCADE;

-- case_id: manifest_select_environment_positive_34e0a6626b50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_unpivot", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT metric_name, metric_value FROM t_select_source UNPIVOT (metric_value FOR metric_name IN (col_1 AS 'COL_1', col_2 AS 'COL_2'));
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_f390e935dfc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_pivot", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT * FROM t_select_source PIVOT (SUM(col_2) FOR col_1 IN (1 AS one, 2 AS two));
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_8ee266e8897d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_xmltable_a_sequence", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- test_sql:
SELECT * FROM XMLTABLE('1, 2, <a>12</a>');

-- case_id: manifest_select_environment_positive_1faea1dbb33a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_legacy_outer_join", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
DROP TABLE IF EXISTS t_select_right CASCADE;
CREATE TABLE t_select_right (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_right (col_1, col_2, name) VALUES (1, 100, 'one'), (4, 400, 'four');
-- test_sql:
SELECT a.col_1, b.col_1 FROM t_select_source AS a, t_select_right AS b WHERE a.col_1(+) = b.col_1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_right CASCADE;
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_f7fe90ab9e57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_hierarchy", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_hierarchy CASCADE;
CREATE TABLE t_select_hierarchy (name VARCHAR(64) NOT NULL, id INTEGER NOT NULL, parent_id INTEGER);
INSERT INTO t_select_hierarchy (name, id, parent_id) VALUES ('root', 1, 0), ('child_a', 2, 1), ('child_b', 3, 1);
-- test_sql:
SELECT name, id, parent_id, LEVEL FROM t_select_hierarchy START WITH id = 1 CONNECT BY PRIOR id = parent_id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_hierarchy CASCADE;

-- case_id: manifest_select_environment_positive_b69830f0e1fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_hierarchy_nocycle_siblings", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_hierarchy CASCADE;
CREATE TABLE t_select_hierarchy (name VARCHAR(64) NOT NULL, id INTEGER NOT NULL, parent_id INTEGER);
INSERT INTO t_select_hierarchy (name, id, parent_id) VALUES ('root', 1, 0), ('child_a', 2, 1), ('child_b', 3, 1);
-- test_sql:
SELECT name, id, parent_id FROM t_select_hierarchy START WITH id = 1 CONNECT BY NOCYCLE PRIOR id = parent_id ORDER SIBLINGS BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_hierarchy CASCADE;

-- case_id: manifest_select_environment_positive_2e0bed3042b5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_nls_sort", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT name FROM t_select_source ORDER BY NLSSORT(name, ' NLS_SORT = generic_m_ci ');
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_fc4c5892c71d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_for_update", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_fc1633baaec5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_for_no_key_update", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR NO KEY UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_daf4b9114111
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_for_share", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR SHARE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_ce1eb597b0df
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_for_key_share", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR KEY SHARE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_43a36e45633b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_lock_nowait", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR UPDATE NOWAIT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_f824a1f72c7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_lock_wait", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR UPDATE WAIT 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_environment_positive_24ef425371a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_lock_skip_locked", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source FOR UPDATE SKIP LOCKED;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;
