-- generated_from: manifest_update_cte_syntax_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_update_cte_syntax_positive_3682bd691bfe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte AS (SELECT id FROM t_update_target WHERE id = 3) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_cte_syntax_positive_2b825e1e9d8f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_recursive_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH RECURSIVE upd_cte(id) AS (VALUES (1) UNION ALL SELECT id + 1 FROM upd_cte WHERE id < 2) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_cte_syntax_positive_43673937278b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_materialized_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte AS MATERIALIZED (SELECT id FROM t_update_target) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_cte_syntax_positive_2a87b4b3f69d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_not_materialized_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte AS NOT MATERIALIZED (SELECT id FROM t_update_target) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_cte_syntax_positive_9e3b143e2b9b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_values"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte(id) AS (VALUES (1), (2)) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_cte_syntax_positive_35c1c493158b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_insert"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte AS (INSERT INTO t_update_aux (id, note) VALUES (90, 'cte') RETURNING id) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;
DROP TABLE IF EXISTS t_update_aux CASCADE;

-- case_id: manifest_update_cte_syntax_positive_78b558cee1d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_update"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte AS (UPDATE t_update_aux SET note = 'cte' WHERE id = 9 RETURNING id) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;
DROP TABLE IF EXISTS t_update_aux CASCADE;

-- case_id: manifest_update_cte_syntax_positive_2839d16e4e93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_delete"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_aux CASCADE;
CREATE TABLE t_update_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_update_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
WITH upd_cte AS (DELETE FROM t_update_aux WHERE id = 9 RETURNING id) UPDATE t_update_target SET note = 'changed' WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;
DROP TABLE IF EXISTS t_update_aux CASCADE;
