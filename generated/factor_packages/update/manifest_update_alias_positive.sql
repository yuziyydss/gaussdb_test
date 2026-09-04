-- generated_from: manifest_update_alias_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_update_alias_positive_5155e1ab3da1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_alias", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_alias_as", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target AS u SET u.note = 'qualified' WHERE u.id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_alias_positive_e23a8c30b226
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_alias", "returning_clause": "update_returning_expression", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_alias_bare", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target u SET u.note = 'qualified' WHERE u.id = 2 RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_alias_positive_100ecc83161d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_alias", "returning_clause": "update_returning_expression", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_alias_as", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target AS u SET u.note = 'qualified' WHERE u.id = 2 RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_alias_positive_d5c41e9e975a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_alias", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_alias_bare", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target u SET u.note = 'qualified' WHERE u.id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;
