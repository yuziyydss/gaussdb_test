-- generated_from: manifest_delete_view_subquery_positive
-- static_only: true
-- case_count: 2

-- case_id: manifest_delete_view_subquery_positive_70c7f2ac9381
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_view", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_view_base CASCADE;
CREATE TABLE t_delete_view_base (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_view_base VALUES (1, 'keep'), (2, 'delete_me');
CREATE VIEW v_delete_target AS SELECT id, note FROM t_delete_view_base;
-- test_sql:
DELETE FROM v_delete_target WHERE id = 2;
-- fixture_teardown:
DROP VIEW IF EXISTS v_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_view_base CASCADE;

-- case_id: manifest_delete_view_subquery_positive_8cd0933957c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_subquery", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_subquery_base CASCADE;
CREATE TABLE t_delete_subquery_base (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_subquery_base (id, note) VALUES (1, 'keep'), (2, 'delete_me');
-- test_sql:
DELETE FROM (SELECT id, note FROM t_delete_subquery_base) WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_subquery_base CASCADE;
