-- generated_from: manifest_insert_core_positive
-- static_only: true
-- case_count: 24

-- case_id: manifest_insert_core_positive_4b4821baf6c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_default_values", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_8c6ea0937cf8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_one", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (id, note) VALUES (101, 'alpha') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_9779e0f50e55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_note", "target_profile": "insert_target_table_note", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (note) VALUES ('note only') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_308e51aa513c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_many", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (102, 'beta'), (103, 'gamma') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_7cd00dad248b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_value_many", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUE (104, 'delta'), (105, DEFAULT) RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_2e96d2337421
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_with_default", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (id, note) VALUES (DEFAULT, 'uses default');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_5e0c4194308e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_query", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target (id, note) SELECT col_1, name FROM t_insert_source RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_f2722b6f7c94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_id", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (106);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_85845ea0676a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_default_values", "target_profile": "insert_target_table_note", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (note) DEFAULT VALUES RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_208ce39b6521
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_c6a19de232bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_with_default", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (DEFAULT, 'uses default') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_a6a36f29c54b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target SELECT col_1, name FROM t_insert_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_4312a78eb5e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_default_values", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (id, note) DEFAULT VALUES RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_b6ae5d917f01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (id, note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_6bbb955fcaa2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_value_many", "target_profile": "insert_target_table_two_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (id, note) VALUE (104, 'delta'), (105, DEFAULT);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_e97d3edd6d9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_note", "target_profile": "insert_target_table_note", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (note) VALUES ('note only');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_0e4c69f50e2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_one", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (101, 'alpha') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_f93d47be2279
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_many", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (102, 'beta'), (103, 'gamma') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_63c8231de55f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_value_many", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUE (104, 'delta'), (105, DEFAULT) RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_76bd97b25645
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_id", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (106) RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_104ea65d7af7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_id", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (106) RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_5e36967a61f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_with_default", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target VALUES (DEFAULT, 'uses default') RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_0aec0201f9a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_query", "target_profile": "insert_target_table_implicit", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_target SELECT col_1, name FROM t_insert_source RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_core_positive_d4127c665eac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_all", "source_profile": "insert_source_values_note", "target_profile": "insert_target_table_note", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target (note) VALUES ('note only') RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;
