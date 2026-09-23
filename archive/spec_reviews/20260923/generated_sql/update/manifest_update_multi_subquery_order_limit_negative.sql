-- generated_from: manifest_update_multi_subquery_order_limit_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_update_multi_subquery_order_limit_negative_a7d417bf1ef9
-- expected: error
-- expected_error_category: multi_column_set_subquery_order_limit_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_tuple_subquery_order_limit_invalid", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
DROP TABLE IF EXISTS t_update_source CASCADE;
CREATE TABLE t_update_source (src_id INTEGER NOT NULL, label VARCHAR(64), amount INTEGER);
INSERT INTO t_update_source (src_id, label, amount) VALUES (1, 'source_one', 101), (2, 'source_two', 202);
-- test_sql:
UPDATE t_update_target SET (note, qty) = (SELECT label, amount FROM t_update_source ORDER BY src_id LIMIT 1) WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_source CASCADE;
DROP TABLE IF EXISTS t_update_target CASCADE;
