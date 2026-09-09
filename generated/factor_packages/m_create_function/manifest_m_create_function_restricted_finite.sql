-- generated_from: manifest_m_create_function_restricted_finite
-- static_only: true
-- case_count: 13

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_function_restricted_finite_8cbf5050dcff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_default", "default_expr": "m_create_function_default_expr_none", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_immutable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER ) RETURNS INTEGER LANGUAGE plpgsql IMMUTABLE AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_97bb939af573
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_zero", "default_expr": "m_create_function_default_expr_default", "strict": "m_create_function_strict_yes", "volatility": "m_create_function_volatility_stable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER DEFAULT 1) RETURNS INTEGER LANGUAGE plpgsql STABLE STRICT AUTHID CURRENT_USER COST 0 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_0105c1bef3af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_in", "cost": "m_create_function_cost_one", "default_expr": "m_create_function_default_expr_none", "strict": "m_create_function_strict_yes", "volatility": "m_create_function_volatility_volatile"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i IN INTEGER ) RETURNS INTEGER LANGUAGE plpgsql VOLATILE STRICT AUTHID CURRENT_USER COST 1 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_4a59ddeba77c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_in", "cost": "m_create_function_cost_zero", "default_expr": "m_create_function_default_expr_assign", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_immutable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i IN INTEGER := 1) RETURNS INTEGER LANGUAGE plpgsql IMMUTABLE AUTHID CURRENT_USER COST 0 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_ea7b7ae0eb34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_one", "default_expr": "m_create_function_default_expr_equals", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_stable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER = 1) RETURNS INTEGER LANGUAGE plpgsql STABLE AUTHID CURRENT_USER COST 1 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_0ac5358b5889
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_default", "default_expr": "m_create_function_default_expr_assign", "strict": "m_create_function_strict_yes", "volatility": "m_create_function_volatility_volatile"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER := 1) RETURNS INTEGER LANGUAGE plpgsql VOLATILE STRICT AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_e4dad4e22d4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_in", "cost": "m_create_function_cost_default", "default_expr": "m_create_function_default_expr_default", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_stable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i IN INTEGER DEFAULT 1) RETURNS INTEGER LANGUAGE plpgsql STABLE AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_1252f0426b94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_in", "cost": "m_create_function_cost_default", "default_expr": "m_create_function_default_expr_equals", "strict": "m_create_function_strict_yes", "volatility": "m_create_function_volatility_immutable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i IN INTEGER = 1) RETURNS INTEGER LANGUAGE plpgsql IMMUTABLE STRICT AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_9c291dc49b66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_zero", "default_expr": "m_create_function_default_expr_equals", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_volatile"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER = 1) RETURNS INTEGER LANGUAGE plpgsql VOLATILE AUTHID CURRENT_USER COST 0 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_5055f2fc5960
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_one", "default_expr": "m_create_function_default_expr_default", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_immutable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER DEFAULT 1) RETURNS INTEGER LANGUAGE plpgsql IMMUTABLE AUTHID CURRENT_USER COST 1 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_ce665c9b2aa7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_zero", "default_expr": "m_create_function_default_expr_none", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_stable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER ) RETURNS INTEGER LANGUAGE plpgsql STABLE AUTHID CURRENT_USER COST 0 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_d1e8e9d8c818
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_one", "default_expr": "m_create_function_default_expr_assign", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_stable"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER := 1) RETURNS INTEGER LANGUAGE plpgsql STABLE AUTHID CURRENT_USER COST 1 AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;

-- case_id: manifest_m_create_function_restricted_finite_f7d458166b6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"argmode": "m_create_function_argmode_default", "cost": "m_create_function_cost_default", "default_expr": "m_create_function_default_expr_default", "strict": "m_create_function_strict_none", "volatility": "m_create_function_volatility_volatile"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_create_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_create_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["isolated_schema_no_public_usage"], "fact_refs": ["m_create_function_fact_public"], "key": "function_visibility"}]
-- fixture_setup:
CREATE SCHEMA m_create_function_namespace;
-- test_sql:
CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i INTEGER DEFAULT 1) RETURNS INTEGER LANGUAGE plpgsql VOLATILE AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_create_function_namespace;
