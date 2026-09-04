-- generated_from: manifest_merge_regular_positive
-- static_only: true
-- case_count: 28

-- case_id: manifest_merge_regular_positive_bce850b8b545
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_update_then_insert", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name, category = src.category WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_3d94d33fb9ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_insert_then_update", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target dst USING t_merge_source src ON (dst.id = src.id AND src.id > 0) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_1a9662a51ea2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_matched_only", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target AS dst USING v_merge_source AS src ON (dst.id = src.id AND src.id > 0) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_05c55ec2ae1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_not_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_0c520511fe5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_tuple_update", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET (name, category) = (src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_9a1e67b81028
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_with_where", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id AND src.id > 0) WHEN MATCHED THEN UPDATE SET name = src.name WHERE src.id > 0 WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHERE src.id > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_c37f129f4fd0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_default_values", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target dst USING t_merge_source AS src ON (dst.id = src.id AND src.id > 0) WHEN NOT MATCHED THEN INSERT DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_6435d1c70629
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_with_where", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target dst USING v_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name WHERE src.id > 0 WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHERE src.id > 0;
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_d29023c8d001
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_insert_then_update", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_33fe6fdfeb05
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_not_matched_only", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source AS src ON (dst.id = src.id AND src.id > 0) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_44630bd67383
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_default_values", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_b34b3c46f785
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target dst USING t_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_5e8a2fe0d09d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_tuple_update", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target dst USING t_merge_source AS src ON (dst.id = src.id AND src.id > 0) WHEN MATCHED THEN UPDATE SET (name, category) = (src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_491a09b6c3b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_update_then_insert", "on_condition": "merge_on_id_equal_positive", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_bare_alias"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target dst USING t_merge_source src ON (dst.id = src.id AND src.id > 0) WHEN MATCHED THEN UPDATE SET name = src.name, category = src.category WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_cae9d95aac7e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_with_where", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_as", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name WHERE src.id > 0 WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHERE src.id > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_94b360feb760
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_6857c5916898
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_not_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_f1eafc7a2f25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_with_where", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_table_bare_alias", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING t_merge_source src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name WHERE src.id > 0 WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHERE src.id > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_00b6e21ee739
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_update_then_insert", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target AS dst USING v_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name, category = src.category WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_ab62d8bc9e3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_insert_then_update", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target AS dst USING v_merge_source AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_7c5f153bc59f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_not_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target AS dst USING v_merge_source AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_88f3320b2f70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_tuple_update", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target AS dst USING v_merge_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET (name, category) = (src.name, src.category);
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_58445c29efc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_default_values", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_view", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
CREATE TABLE t_merge_view_base (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_view_base (id, name, category) VALUES (1, 'view-one', 'updated'), (2, 'view-two', 'inserted');
CREATE VIEW v_merge_source AS SELECT id, name, category FROM t_merge_view_base;
-- test_sql:
MERGE INTO t_merge_target AS dst USING v_merge_source AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT DEFAULT VALUES;
-- fixture_teardown:
DROP VIEW IF EXISTS v_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_view_base CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_7ea324b42a63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_update_then_insert", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name, category = src.category WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_5115fd60b8eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_both_insert_then_update", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_26d429395db3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_matched_only", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_d131a3b094bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_tuple_update", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET (name, category) = (src.name, src.category);
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;

-- case_id: manifest_merge_regular_positive_a3020be6fedb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "merge_action_default_values", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_subquery", "target_profile": "merge_target_regular_as"}
-- fixture_setup:
DROP TABLE IF EXISTS t_merge_target CASCADE;
CREATE TABLE t_merge_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
DROP TABLE IF EXISTS t_merge_source CASCADE;
CREATE TABLE t_merge_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO t_merge_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO t_merge_target AS dst USING (SELECT id, name, category FROM t_merge_source) AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_merge_source CASCADE;
DROP TABLE IF EXISTS t_merge_target CASCADE;
