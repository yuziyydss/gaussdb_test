-- generated_from: manifest_m_prepare_alter_relation
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_alter_relation_87104a4e1b1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_alter_relation"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_alter_table::m_alter_table_fact_authority"], "key": "ddl_authority"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'ALTER TABLE m_prepare_data ADD COLUMN extra INTEGER';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;
