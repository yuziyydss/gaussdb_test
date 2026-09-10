-- generated_from: manifest_update_generated_returning
-- static_only: true
-- case_count: 2

-- case_id: manifest_update_generated_returning_31f8c804e988
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_generated_total", "set_profile": "update_set_finite_generated_default", "single_target_profile": "update_target_finite_generated", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_returning_select"], "fact_refs": ["update_fact_permissions"], "key": "update_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO g_generated_dst (id, qty) VALUES (2, 9), (3, 8);
-- test_sql:
UPDATE g_generated_dst SET total = DEFAULT WHERE id = 2 RETURNING total AS computed;
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;

-- case_id: manifest_update_generated_returning_11efdc2dfd56
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"from_clause": "update_from_none", "limit_clause": "update_limit_none", "multi_target_profile": "update_multi_targets_basic", "order_clause": "update_order_none", "plan_hint": "update_hint_none", "predicate": "update_predicate_where", "returning_clause": "update_returning_all", "set_profile": "update_set_finite_generated_default", "single_target_profile": "update_target_finite_generated", "update_form": "update_form_single", "with_clause": "update_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_returning_select"], "fact_refs": ["update_fact_permissions"], "key": "update_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO g_generated_dst (id, qty) VALUES (2, 9), (3, 8);
-- test_sql:
UPDATE g_generated_dst SET total = DEFAULT WHERE id = 2 RETURNING *;
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;
