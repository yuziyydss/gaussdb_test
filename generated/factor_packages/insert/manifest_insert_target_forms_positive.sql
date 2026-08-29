-- generated_from: manifest_insert_target_forms_positive
-- static_only: true
-- case_count: 10

-- case_id: manifest_insert_target_forms_positive_6831c9ef6987
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_cd89eff5117b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_two", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_3fe60d727ad6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_partition", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER, note VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (1000), PARTITION p_high VALUES LESS THAN (MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION (p_low) (id, note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_target_forms_positive_3291c968e131
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_819f662a451e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (id, note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_40642f669075
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_two", "target_profile": "insert_target_alias_as", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target AS dst (dst.id, dst.note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_7a3fcb7d7915
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_alias_bare", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_target CASCADE;
CREATE TABLE t_insert_target (id INTEGER, note VARCHAR(64));
-- test_sql:
INSERT INTO t_insert_target dst (dst.id, dst.note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_target CASCADE;

-- case_id: manifest_insert_target_forms_positive_b59eab7a56eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_two", "target_profile": "insert_target_partition", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;
CREATE TABLE t_insert_partitioned (id INTEGER, note VARCHAR(64)) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (1000), PARTITION p_high VALUES LESS THAN (MAXVALUE));
-- test_sql:
INSERT INTO t_insert_partitioned PARTITION (p_low) (id, note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_partitioned CASCADE;

-- case_id: manifest_insert_target_forms_positive_70dd3ac857f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_two", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_target_forms_positive_72b9d9f8e820
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_two", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) AS sq (id, note) VALUES (102, 'beta'), (103, 'gamma');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
