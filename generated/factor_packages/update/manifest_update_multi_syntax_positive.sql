-- generated_from: manifest_update_multi_syntax_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_update_multi_syntax_positive_2d8faead8525
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_table", "update_form": "update_form_multi", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
UPDATE t_update_target AS u, t_update_aux AS a SET u.note = 'qualified';
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_aux CASCADE;
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_multi_syntax_positive_07f6ce88a2fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_source", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_modified", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_table", "update_form": "update_form_multi", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_source CASCADE;
CREATE TABLE t_update_source (src_id INTEGER NOT NULL, label VARCHAR(64), amount INTEGER);
INSERT INTO t_update_source (src_id, label, amount) VALUES (1, 'source_one', 101), (2, 'source_two', 202);
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
UPDATE ONLY t_update_target * AS u, (SELECT id, note FROM t_update_aux) AS a SET u.note = 'qualified' FROM t_update_source AS s;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_aux CASCADE;
DROP TABLE IF EXISTS t_update_target CASCADE;
DROP TABLE IF EXISTS t_update_source CASCADE;

-- case_id: manifest_update_multi_syntax_positive_d9578a392d1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_modified", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_table", "update_form": "update_form_multi", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
UPDATE ONLY t_update_target * AS u, (SELECT id, note FROM t_update_aux) AS a SET u.note = 'qualified';
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_aux CASCADE;
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_multi_syntax_positive_39a73c3bf1ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_source", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_table", "update_form": "update_form_multi", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_source CASCADE;
CREATE TABLE t_update_source (src_id INTEGER NOT NULL, label VARCHAR(64), amount INTEGER);
INSERT INTO t_update_source (src_id, label, amount) VALUES (1, 'source_one', 101), (2, 'source_two', 202);
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
UPDATE t_update_target AS u, t_update_aux AS a SET u.note = 'qualified' FROM t_update_source AS s;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_aux CASCADE;
DROP TABLE IF EXISTS t_update_target CASCADE;
DROP TABLE IF EXISTS t_update_source CASCADE;
