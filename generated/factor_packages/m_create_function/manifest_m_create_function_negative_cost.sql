-- generated_from: manifest_m_create_function_negative_cost
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_function_negative_cost_278db1fa47a9
-- expected: error
-- expected_error_category: nonnegative_cost
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_negative", "default_expr": "m_create_function_default_expr_none", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_immutable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER ) RETURNS INTEGER LANGUAGE plpgsql IMMUTABLE AUTHID CURRENT_USER COST -1 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;
