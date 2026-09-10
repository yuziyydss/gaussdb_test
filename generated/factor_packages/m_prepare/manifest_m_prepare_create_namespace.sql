-- generated_from: manifest_m_prepare_create_namespace
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_create_namespace_8cfa46a2d381
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_create_namespace"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["database_create_non_user_named_fresh_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority", "m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_authority"}, {"allowed_values": ["fresh_non_system_non_user_namespace_outside_search_path"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "asset_scope"}]
-- fixture_setup:
SHOW search_path;
-- test_sql:
PREPARE m_prepare_stmt FROM 'CREATE SCHEMA m_prepare_created_namespace';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
