-- generated_from: manifest_m_reset_all
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_reset_all_a962a3c8b362
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "m_reset_target_all"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_reset_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_reset_fact_rollback", "m_set::m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
SET LOCAL TIME ZONE 'PRC';
-- test_sql:
RESET ALL;
-- fixture_teardown:
ROLLBACK;
