-- generated_from: manifest_update_declared_default_positive
-- static_only: true
-- case_count: 3

-- case_id: manifest_update_declared_default_positive_58abd4bcb789
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_default", "single_target_profile": "update_target_declared_defaults", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_update_declared_defaults (id INTEGER NOT NULL, note VARCHAR(64) DEFAULT 'declared', qty INTEGER DEFAULT 7);
INSERT INTO t_update_declared_defaults (id, note, qty) VALUES (2, 'before', 99);
-- test_sql:
UPDATE t_update_declared_defaults SET note = DEFAULT WHERE id = 2;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_update_declared_default_positive_984db144bcef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_all", "set_profile": "update_set_default", "single_target_profile": "update_target_declared_defaults", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_update_declared_defaults (id INTEGER NOT NULL, note VARCHAR(64) DEFAULT 'declared', qty INTEGER DEFAULT 7);
INSERT INTO t_update_declared_defaults (id, note, qty) VALUES (2, 'before', 99);
-- test_sql:
UPDATE t_update_declared_defaults SET note = DEFAULT WHERE id = 2 RETURNING *;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_update_declared_default_positive_9c1a229e48da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_expression", "set_profile": "update_set_default", "single_target_profile": "update_target_declared_defaults", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
BEGIN;
CREATE TABLE t_update_declared_defaults (id INTEGER NOT NULL, note VARCHAR(64) DEFAULT 'declared', qty INTEGER DEFAULT 7);
INSERT INTO t_update_declared_defaults (id, note, qty) VALUES (2, 'before', 99);
-- test_sql:
UPDATE t_update_declared_defaults SET note = DEFAULT WHERE id = 2 RETURNING id, note AS updated_note;
-- fixture_teardown:
ROLLBACK;
