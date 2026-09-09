-- generated_from: manifest_m_prepare_set_timezone
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_set_timezone_8ec8926edf44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_set_timezone"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session", "m_set::m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
SHOW TimeZone;
-- test_sql:
PREPARE m_prepare_stmt FROM 'SET SESSION TIME ZONE ''PRC''';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
ROLLBACK;
