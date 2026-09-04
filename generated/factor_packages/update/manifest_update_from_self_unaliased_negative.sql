-- generated_from: manifest_update_from_self_unaliased_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_update_from_self_unaliased_negative_ef9319198435
-- expected: error
-- expected_error_category: update_from_target_requires_alias
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_self_unaliased_invalid", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET note = 'changed' FROM t_update_target;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;
