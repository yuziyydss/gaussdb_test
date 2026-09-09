-- generated_from: manifest_m_drop_function_restricted_finite
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_function_restricted_finite_1ad231369096
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_default", "if_exists": "m_drop_function_if_exists_none", "signature": "m_drop_function_signature_omitted"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION m_function_existing_namespace.increment_value;
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_3fe9ae3755a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_restrict", "if_exists": "m_drop_function_if_exists_none", "signature": "m_drop_function_signature_type"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION m_function_existing_namespace.increment_value (INTEGER) RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_a5d0cfa2c8e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_default", "if_exists": "m_drop_function_if_exists_yes", "signature": "m_drop_function_signature_type"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value (INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_4a12dcd7ef4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_restrict", "if_exists": "m_drop_function_if_exists_yes", "signature": "m_drop_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value (i INTEGER) RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_18704d783c95
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_default", "if_exists": "m_drop_function_if_exists_none", "signature": "m_drop_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION m_function_existing_namespace.increment_value (i INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_50205989c428
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_default", "if_exists": "m_drop_function_if_exists_none", "signature": "m_drop_function_signature_explicit_in"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION m_function_existing_namespace.increment_value (i IN INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_a981b1f16a20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_restrict", "if_exists": "m_drop_function_if_exists_yes", "signature": "m_drop_function_signature_explicit_in"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value (i IN INTEGER) RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;

-- case_id: manifest_m_drop_function_restricted_finite_2176e11ca9bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_function_behavior_default", "if_exists": "m_drop_function_if_exists_yes", "signature": "m_drop_function_signature_omitted"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_function_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_tool_reviewed"], "fact_refs": ["m_drop_function_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["dedicated_database_no_other_users"], "fact_refs": ["m_drop_function_fact_internal"], "key": "test_isolation"}, {"allowed_values": ["fixture_function_creator"], "fact_refs": ["m_drop_function_fact_owner"], "key": "function_authority"}]
-- fixture_setup:
CREATE SCHEMA m_function_existing_namespace;
CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';
-- test_sql:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value;
-- fixture_teardown:
DROP FUNCTION IF EXISTS m_function_existing_namespace.increment_value(INTEGER) RESTRICT;
DROP SCHEMA m_function_existing_namespace;
