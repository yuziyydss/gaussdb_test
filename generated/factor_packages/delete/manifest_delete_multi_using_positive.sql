-- generated_from: manifest_delete_multi_using_positive
-- static_only: true
-- case_count: 7

-- case_id: manifest_delete_multi_using_positive_f242dc3c2561
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
DELETE FROM t_delete_target, t_delete_aux AS a;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_multi_using_positive_ffc4e65879f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_without_from", "multi_predicate": "delete_multi_predicate_where", "multi_target_profile": "delete_multi_targets_modified", "multi_using_clause": "delete_multi_using_lookup", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE ONLY t_delete_target *, t_delete_aux AS a USING t_delete_lookup AS l WHERE t_delete_target.id = a.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_multi_using_positive_6f0f3bc12654
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_where", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_target", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
DELETE FROM t_delete_target, t_delete_aux AS a USING t_delete_target AS src WHERE t_delete_target.id = a.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_multi_using_positive_efa46528f6fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_without_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_modified", "multi_using_clause": "delete_multi_using_target", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
DELETE ONLY t_delete_target *, t_delete_aux AS a USING t_delete_target AS src;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_multi_using_positive_997682b2464f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_lookup", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE FROM t_delete_target, t_delete_aux AS a USING t_delete_lookup AS l;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_multi_using_positive_8a475748bc2a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_where", "multi_target_profile": "delete_multi_targets_modified", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
-- test_sql:
DELETE FROM ONLY t_delete_target *, t_delete_aux AS a WHERE t_delete_target.id = a.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_multi_using_positive_316c86359141
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_multi_using", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_without_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_lookup", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_aux CASCADE;
CREATE TABLE t_delete_aux (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_aux (id, note) VALUES (2, 'paired'), (9, 'cte_row');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE t_delete_target, t_delete_aux AS a USING t_delete_lookup AS l;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_aux CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;
