-- generated_from: manifest_m_prepare_create_view
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_create_view_ac6f8b91fc5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_create_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["create_any_table"], "fact_refs": ["m_create_view::m_create_view_fact_authority"], "key": "ddl_authority"}, {"allowed_values": ["isolated_public_or_user_schema"], "fact_refs": ["m_create_view::m_create_view_fact_authority"], "key": "namespace_scope"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'CREATE VIEW m_prepare_created_view AS SELECT id,qty FROM m_prepare_data';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;
