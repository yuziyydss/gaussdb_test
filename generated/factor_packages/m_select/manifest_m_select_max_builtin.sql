-- generated_from: manifest_m_select_max_builtin
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_select_max_builtin_fc0d52c02651
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_max_id", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_builtin_max"], "fact_refs": ["m_select_fact_max_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT MAX(id) AS result FROM m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_select_max_builtin_181997b304e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_table", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_max_qty", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_builtin_max"], "fact_refs": ["m_select_fact_max_identity"], "key": "function_resolution"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
SELECT MAX(qty) AS result FROM m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;
