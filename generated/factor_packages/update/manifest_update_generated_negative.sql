-- generated_from: manifest_update_generated_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_update_generated_negative_01ee21260e61
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_finite_generated_literal", "single_target_profile": "update_target_finite_generated", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_referenced_select"], "fact_refs": ["update_fact_permissions"], "key": "update_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO g_generated_dst (id, qty) VALUES (2, 9), (3, 8);
-- test_sql:
UPDATE g_generated_dst SET total = 99 WHERE id = 2;
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;

-- case_id: manifest_update_generated_negative_747c58d0f440
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_none", "set_profile": "update_set_finite_generated_null", "single_target_profile": "update_target_finite_generated", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_referenced_select"], "fact_refs": ["update_fact_permissions"], "key": "update_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO g_generated_dst (id, qty) VALUES (2, 9), (3, 8);
-- test_sql:
UPDATE g_generated_dst SET total = NULL WHERE id = 2;
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;
