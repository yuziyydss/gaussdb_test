-- generated_from: manifest_delete_self_using_b_fresh
-- static_only: true
-- case_count: 2

-- case_id: manifest_delete_self_using_b_fresh_f9f8ab95c5f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_self_b_fresh", "single_using_clause": "delete_using_self_b_fresh", "with_clause": "delete_with_none"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["delete_fact_single_using_b_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator_with_delete_select"], "fact_refs": ["delete_fact_permissions"], "key": "target_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_creation_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "namespace"}]
-- fixture_setup:
CREATE TABLE t_delete_self_b (id INTEGER, note VARCHAR(64));
INSERT INTO t_delete_self_b VALUES (1,'one'),(2,'two'),(3,'three');
-- test_sql:
DELETE FROM t_delete_self_b USING t_delete_self_b AS src;
-- fixture_teardown:
DROP TABLE t_delete_self_b;

-- case_id: manifest_delete_self_using_b_fresh_26c88d7f15c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"delete_form": "delete_form_single", "limit_clause": "delete_limit_none", "multi_from_clause": "delete_multi_source_none", "multi_from_keyword": "delete_multi_from", "multi_predicate": "delete_multi_predicate_none", "multi_target_profile": "delete_multi_targets_basic", "multi_using_clause": "delete_multi_using_none", "order_clause": "delete_order_none", "plan_hint": "delete_hint_none", "returning_clause": "delete_returning_none", "single_from_keyword": "delete_single_without_from", "single_predicate": "delete_predicate_none", "single_target_profile": "delete_target_self_b_fresh", "single_using_clause": "delete_using_self_b_fresh", "with_clause": "delete_with_none"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["delete_fact_single_using_b_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator_with_delete_select"], "fact_refs": ["delete_fact_permissions"], "key": "target_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_creation_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "namespace"}]
-- fixture_setup:
CREATE TABLE t_delete_self_b (id INTEGER, note VARCHAR(64));
INSERT INTO t_delete_self_b VALUES (1,'one'),(2,'two'),(3,'three');
-- test_sql:
DELETE t_delete_self_b USING t_delete_self_b AS src;
-- fixture_teardown:
DROP TABLE t_delete_self_b;
