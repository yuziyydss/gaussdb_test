-- generated_from: manifest_delete_core_positive
-- static_only: true
-- case_count: 31

-- case_id: manifest_delete_core_positive_db4eb52a1f26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_d92ea7ac2220
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_one", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_expression", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_all", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_only", "single_using_clause": "delete_using_lookup", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE ONLY t_delete_target USING t_delete_lookup AS l WHERE id = 2 ORDER BY id LIMIT 1 RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_abb9229d4a72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_one", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_expression", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target * WHERE id = 2 ORDER BY id ASC LIMIT 1 RETURNING id, note AS deleted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_aab31d797e55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_desc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_expression", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only_star", "single_using_clause": "delete_using_lookup", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE ONLY t_delete_target * USING t_delete_lookup AS l ORDER BY id DESC RETURNING id, note AS deleted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_161a6a3635e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_using", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_all", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_as", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target AS d ORDER BY id USING < RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_fd3e006f480c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_one", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_using", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_alias_bare", "single_using_clause": "delete_using_lookup", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE t_delete_target d USING t_delete_lookup AS l WHERE id = 2 ORDER BY id USING < LIMIT 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_423c9e2b33e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_expression", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_expression", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_bare", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target d ORDER BY id RETURNING id, note AS deleted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_980118a930f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_one", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_expression", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_alias_as", "single_using_clause": "delete_using_lookup", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE t_delete_target AS d USING t_delete_lookup AS l WHERE id = 2 LIMIT 1 RETURNING id, note AS deleted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_b6ce2bf65903
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_one", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_desc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_all", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_lookup", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE FROM t_delete_target USING t_delete_lookup AS l WHERE id = 2 ORDER BY id DESC LIMIT 1 RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_4430341424e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE ONLY t_delete_target ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_0273797c0e4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_one", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_all", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target * LIMIT 1 RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_2f6a866589b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_desc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE t_delete_target * ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_846f704b49dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_using", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_expression", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_only", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target WHERE id = 2 ORDER BY id USING < RETURNING id, note AS deleted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_2fd3c728bdf5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_all", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_star", "single_using_clause": "delete_using_lookup", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
CREATE TABLE t_delete_lookup (lookup_id INTEGER NOT NULL, marker VARCHAR(32));
INSERT INTO t_delete_lookup (lookup_id, marker) VALUES (2, 'match');
-- test_sql:
DELETE FROM t_delete_target * USING t_delete_lookup AS l ORDER BY id ASC RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_lookup CASCADE;
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_1f90b834e4c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_expression", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_where", "single_target_profile": "delete_target_only_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target * WHERE id = 2 ORDER BY id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_732ad60a9804
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_expression", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_expression", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE t_delete_target ORDER BY id RETURNING id, note AS deleted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_cb2c7d5691ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_expression", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_as", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target AS d ORDER BY id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_d5c3a0cf25b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_all", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_bare", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target d RETURNING *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_a1cbaf48c0b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_0d40bc4dca77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_using", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_table", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target ORDER BY id USING <;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_009c466b2e47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_a785fafb77c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_desc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_53052e408050
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target *;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_545e2193fbdf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_expression", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target * ORDER BY id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_c28f059aa9d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_using", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target * ORDER BY id USING <;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_a51a699c9e29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target * ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_e5a25d34c92d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_using", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_only_star", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM ONLY t_delete_target * ORDER BY id USING <;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_6e0e5889065e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_as", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target AS d ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_6e78eba46b91
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_desc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_as", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target AS d ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_fce79a9188b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_asc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_bare", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target d ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;

-- case_id: manifest_delete_core_positive_5df6a881b3c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_desc", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_alias_bare", "single_using_clause": "delete_using_none", "with_clause": "delete_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_delete_target CASCADE;
CREATE TABLE t_delete_target (id INTEGER NOT NULL, note VARCHAR(64));
INSERT INTO t_delete_target (id, note) VALUES (1, 'keep'), (2, 'delete_me'), (3, 'cte_source');
-- test_sql:
DELETE FROM t_delete_target d ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_delete_target CASCADE;
