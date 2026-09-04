-- generated_from: manifest_update_view_subquery_positive
-- static_only: true
-- case_count: 5

-- case_id: manifest_update_view_subquery_positive_374c6c2a6393
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_view", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;
CREATE TABLE t_update_view_base (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_view_base VALUES (1, 'keep', 10), (2, 'update_me', 20);
CREATE VIEW v_update_target AS SELECT id, note, qty FROM t_update_view_base;
-- test_sql:
UPDATE v_update_target SET note = 'changed';
-- fixture_teardown:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;

-- case_id: manifest_update_view_subquery_positive_3ed4581b5e9a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_default", "single_target_profile": "update_target_subquery", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_subquery_base CASCADE;
CREATE TABLE t_update_subquery_base (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_subquery_base (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20);
-- test_sql:
UPDATE (SELECT id, note, qty FROM t_update_subquery_base) SET note = DEFAULT WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_subquery_base CASCADE;

-- case_id: manifest_update_view_subquery_positive_dc1526915670
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_view", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;
CREATE TABLE t_update_view_base (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_view_base VALUES (1, 'keep', 10), (2, 'update_me', 20);
CREATE VIEW v_update_target AS SELECT id, note, qty FROM t_update_view_base;
-- test_sql:
UPDATE v_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;

-- case_id: manifest_update_view_subquery_positive_0fc4f3b80c31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_default", "single_target_profile": "update_target_view", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;
CREATE TABLE t_update_view_base (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_view_base VALUES (1, 'keep', 10), (2, 'update_me', 20);
CREATE VIEW v_update_target AS SELECT id, note, qty FROM t_update_view_base;
-- test_sql:
UPDATE v_update_target SET note = DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_update_target CASCADE;
DROP TABLE IF EXISTS t_update_view_base CASCADE;

-- case_id: manifest_update_view_subquery_positive_7ec725c7cddd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_subquery", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_subquery_base CASCADE;
CREATE TABLE t_update_subquery_base (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_subquery_base (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20);
-- test_sql:
UPDATE (SELECT id, note, qty FROM t_update_subquery_base) SET note = 'changed';
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_subquery_base CASCADE;
