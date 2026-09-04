-- generated_from: manifest_delete_cte_syntax_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_delete_cte_syntax_positive_0c9c4a328ff5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte AS (SELECT id FROM t_delete_target WHERE id = 3) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_e90437fa874e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_recursive_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH RECURSIVE del_cte(id) AS (VALUES (1) UNION ALL SELECT id + 1 FROM del_cte WHERE id < 2) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_65c48d208b21
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_materialized_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte AS MATERIALIZED (SELECT id FROM t_delete_target) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_f2d9e34294b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_not_materialized_select"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte AS NOT MATERIALIZED (SELECT id FROM t_delete_target) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_4259fc7ccd5a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_values"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte(id) AS (VALUES (1), (2)) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_315a03937c3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_insert"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte AS (INSERT INTO t_delete_aux (id, note) VALUES (90, 'cte') RETURNING id) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_e4cb1d08e646
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_update"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte AS (UPDATE t_delete_aux SET note = 'cte' WHERE id = 9 RETURNING id) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;

-- case_id: manifest_delete_cte_syntax_positive_bdb2427189ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_delete"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
WITH del_cte AS (DELETE FROM t_delete_aux WHERE id = 9 RETURNING id) DELETE FROM t_delete_target WHERE id = 2;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;
