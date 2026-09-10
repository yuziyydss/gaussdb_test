-- generated_from: manifest_m_select_min_double
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_select_min_double_29c4a6add747
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache": "m_select_cache_none", "group_by_list": "m_select_group_by_list_none", "limit": "m_select_limit_none", "lock_clause": "m_select_lock_clause_none", "order_by_list": "m_select_order_by_list_none", "right_target_list": "m_select_right_target_list_id", "select_modifier": "m_select_select_modifier_none", "set_operator": "m_select_set_operator_none", "source_form": "m_select_source_form_double", "statement_form": "m_select_statement_form_select", "target_list": "m_select_target_list_min_double", "where_clause": "m_select_where_clause_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_select_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_builtin_min"], "fact_refs": ["m_select_fact_min_identity"], "key": "function_resolution"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table_in_owned_schema"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "table_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_owned_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}]
-- fixture_setup:
CREATE SCHEMA m_select_approximate_ns;
CREATE TABLE m_select_approximate_ns.double_source (qty DOUBLE);
INSERT INTO m_select_approximate_ns.double_source (qty) VALUES (1.5),(2.5);
-- test_sql:
SELECT MIN(qty) AS result FROM m_select_approximate_ns.double_source;
-- fixture_teardown:
DROP TABLE m_select_approximate_ns.double_source RESTRICT;
DROP SCHEMA m_select_approximate_ns;
