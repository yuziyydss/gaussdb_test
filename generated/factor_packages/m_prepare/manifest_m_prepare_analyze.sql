-- generated_from: manifest_m_prepare_analyze
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_analyze_31f04592e790
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_analyze"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze::m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["ordinary_analyze_prepare"], "fact_refs": ["m_analyze::m_analyze_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["row"], "fact_refs": ["m_analyze::m_analyze_fact_row_storage"], "key": "table_storage"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT) WITH (ORIENTATION = ROW);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'ANALYZE m_prepare_data';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;
