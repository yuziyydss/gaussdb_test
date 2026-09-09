-- generated_from: manifest_m_drop_prepare_finite
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_prepare_finite_abf5a1620816
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"verb": "m_drop_prepare_verb_deallocate"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_drop_prepare_fact_session", "m_prepare::m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_drop_prepare_data (id INT);
PREPARE m_drop_prepare_stmt FROM 'SELECT id FROM m_drop_prepare_data';
-- test_sql:
DEALLOCATE PREPARE m_drop_prepare_stmt;
-- fixture_teardown:
DROP TABLE m_drop_prepare_data;

-- case_id: manifest_m_drop_prepare_finite_3fececc474d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"verb": "m_drop_prepare_verb_drop"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_drop_prepare_fact_session", "m_prepare::m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_drop_prepare_data (id INT);
PREPARE m_drop_prepare_stmt FROM 'SELECT id FROM m_drop_prepare_data';
-- test_sql:
DROP PREPARE m_drop_prepare_stmt;
-- fixture_teardown:
DROP TABLE m_drop_prepare_data;
