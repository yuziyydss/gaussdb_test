-- generated_from: manifest_update_core_positive
-- static_only: true
-- case_count: 24

-- case_id: manifest_update_core_positive_4eeecc406cb7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET note = 'changed';
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_ab254794e230
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_one", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_expression", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_all", "set_profile": "update_set_default", "single_target_profile": "update_target_only", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target SET note = DEFAULT WHERE id = 2 ORDER BY id LIMIT 1 RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_cb927366fec3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_one", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_asc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_expression", "set_profile": "update_set_tuple_literals", "single_target_profile": "update_target_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target * SET (note, qty) = ('tuple', 12) ORDER BY id ASC LIMIT 1 RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_d43ce0ee5b4f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_desc", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_expression", "set_profile": "update_set_multiple", "single_target_profile": "update_target_only_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target * SET note = 'multi', qty = qty + 1 WHERE id = 2 ORDER BY id DESC RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_b6f67c114ee6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_using", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_all", "set_profile": "update_set_tuple_literals", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET (note, qty) = ('tuple', 12) WHERE id = 2 ORDER BY id USING < RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_f406d3bc1c25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_one", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_using", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_multiple", "single_target_profile": "update_target_only", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target SET note = 'multi', qty = qty + 1 ORDER BY id USING < LIMIT 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_d0b1ccc1da38
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_asc", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_default", "single_target_profile": "update_target_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target * SET note = DEFAULT WHERE id = 2 ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_b14ae503b404
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_one", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_desc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_all", "set_profile": "update_set_literal", "single_target_profile": "update_target_only_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target * SET note = 'changed' ORDER BY id DESC LIMIT 1 RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_5a8d9fa5947b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_one", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_expression", "set_profile": "update_set_default", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET note = DEFAULT LIMIT 1 RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_4800e84b47ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_expression", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_expression", "set_profile": "update_set_literal", "single_target_profile": "update_target_only", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target SET note = 'changed' ORDER BY id RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_a28272b13a4c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_all", "set_profile": "update_set_multiple", "single_target_profile": "update_target_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target * SET note = 'multi', qty = qty + 1 WHERE id = 2 RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_d189f8ad3e8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_expression", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_tuple_literals", "single_target_profile": "update_target_only_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target * SET (note, qty) = ('tuple', 12) ORDER BY id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_dbfe26fabbf9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_using", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_expression", "set_profile": "update_set_literal", "single_target_profile": "update_target_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target * SET note = 'changed' WHERE id = 2 ORDER BY id USING < RETURNING id, note AS updated_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_22d28f856f39
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_asc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_all", "set_profile": "update_set_multiple", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET note = 'multi', qty = qty + 1 ORDER BY id ASC RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_d33cd6d560d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_desc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_tuple_literals", "single_target_profile": "update_target_only", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target SET (note, qty) = ('tuple', 12) ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_1121745b370b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_using", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_default", "single_target_profile": "update_target_only_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target * SET note = DEFAULT ORDER BY id USING <;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_e3854a265b6c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_desc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_default", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET note = DEFAULT ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_56c27e4e1d25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_expression", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_multiple", "single_target_profile": "update_target_table", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target SET note = 'multi', qty = qty + 1 ORDER BY id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_25f32eef9078
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_asc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_only", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target SET note = 'changed' ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_a98190fefeae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_tuple_literals", "single_target_profile": "update_target_only", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target SET (note, qty) = ('tuple', 12);
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_8c9b570cbf6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_expression", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target * SET note = 'changed' ORDER BY id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_277717713059
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_desc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE t_update_target * SET note = 'changed' ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_6447609f27e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_only_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target * SET note = 'changed';
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;

-- case_id: manifest_update_core_positive_7fe99f265c30
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_asc", "plan_hint": "update_hint_none", "predicate": "update_predicate_none", "returning_clause": "update_returning_none", "set_profile": "update_set_literal", "single_target_profile": "update_target_only_star", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_update_target CASCADE;
CREATE TABLE t_update_target (id INTEGER NOT NULL, note VARCHAR(64), qty INTEGER);
INSERT INTO t_update_target (id, note, qty) VALUES (1, 'keep', 10), (2, 'update_me', 20), (3, 'cte_source', 30);
-- test_sql:
UPDATE ONLY t_update_target * SET note = 'changed' ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_update_target CASCADE;
