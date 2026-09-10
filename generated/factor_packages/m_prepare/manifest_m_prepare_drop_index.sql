-- generated_from: manifest_m_prepare_drop_index
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_drop_index_18e113298493
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_drop_index"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["database_create_non_user_named_fresh_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority", "m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["m_create_table::m_create_table_fact_authority"], "key": "ddl_authority"}, {"allowed_values": ["fixture_object_creator"], "fact_refs": ["m_drop_index::m_drop_index_fact_authority"], "key": "drop_authority"}, {"allowed_values": ["fixture_table_and_namespace_creator"], "fact_refs": ["m_drop_table::m_drop_table_fact_authority", "m_drop_schema::m_drop_schema_fact_authority"], "key": "cleanup_authority"}, {"allowed_values": ["fresh_owned_objects_no_external_dependencies"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "asset_scope"}, {"allowed_values": ["create_any_index"], "fact_refs": ["m_create_index::m_create_index_fact_authority"], "key": "nested_object_create_authority"}]
-- fixture_setup:
CREATE SCHEMA m_prepare_drop_index_ns;
CREATE TABLE m_prepare_drop_index_ns.base_table (id INTEGER, qty INTEGER);
INSERT INTO m_prepare_drop_index_ns.base_table VALUES (1,10),(2,20);
CREATE INDEX m_prepare_drop_index_ns.target_index USING BTREE ON m_prepare_drop_index_ns.base_table (id);
-- test_sql:
PREPARE m_prepare_stmt FROM 'DROP INDEX m_prepare_drop_index_ns.target_index';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP INDEX IF EXISTS m_prepare_drop_index_ns.target_index;
DROP TABLE IF EXISTS m_prepare_drop_index_ns.base_table PURGE;
DROP SCHEMA m_prepare_drop_index_ns;
