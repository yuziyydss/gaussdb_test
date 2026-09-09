-- generated_from: manifest_m_prepare_create_table
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_create_table_fbcbe1521196
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_create_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["database_create_non_user_named_fresh_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority", "m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "ddl_authority"}]
-- fixture_setup:
CREATE SCHEMA m_prepare_ct_namespace;
-- test_sql:
PREPARE m_prepare_stmt FROM 'CREATE TABLE m_prepare_ct_namespace.created_table (id INTEGER, qty INTEGER)';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP SCHEMA m_prepare_ct_namespace;
