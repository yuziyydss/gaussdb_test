-- generated_from: manifest_update_multi_view_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_update_multi_view_negative_207d5452a09c
-- expected: error
-- expected_error_category: multi_update_view_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_view_invalid", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_alias_qualified", "single_target_profile": "update_target_table", "update_form": "update_form_multi", "with_clause": "update_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;
CREATE TABLE t_update_view_base (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_view_base VALUES (1, 'keep', 10), (2, 'update_me', 20);
CREATE VIEW v_update_target AS SELECT id, note, qty FROM t_update_view_base;
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
UPDATE v_update_target AS u, t_update_aux AS a SET u.note = 'qualified';
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_aux CASCADE;
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;
