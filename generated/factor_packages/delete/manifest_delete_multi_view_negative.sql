-- generated_from: manifest_delete_multi_view_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_delete_multi_view_negative_f44562088992
-- expected: error
-- expected_error_category: multi_delete_view_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_view_invalid", "multi_using_clause": "delete_multi_using_lookup", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_view_base CASCADE;
CREATE TABLE t_delete_view_base (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_view_base VALUES (1, 'keep'), (2, 'delete_me');
CREATE VIEW v_delete_target AS SELECT id, note FROM t_delete_view_base;
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE FROM v_delete_target, t_delete_aux USING t_delete_lookup AS l;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP VIEW IF EXISTS v_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_view_base CASCADE;
