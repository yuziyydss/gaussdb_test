-- generated_from: manifest_m_prepare_commit
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_commit_b472ee7d0a0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_commit"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_authority"}]
-- fixture_setup:
CREATE TABLE m_commit_data (id INT);
INSERT INTO m_commit_data VALUES (0);
BEGIN;
INSERT INTO m_commit_data VALUES (1);
SELECT COUNT(*) FROM m_commit_data;
-- test_sql:
PREPARE m_prepare_stmt FROM 'COMMIT';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
ROLLBACK;
DROP TABLE m_commit_data;
