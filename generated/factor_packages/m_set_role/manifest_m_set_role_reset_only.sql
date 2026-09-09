-- generated_from: manifest_m_set_role_reset_only
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_role_reset_only_36d74bc74065
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "m_set_role_reset_form_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_new_connection"], "fact_refs": ["m_set_role_fact_mode"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET ROLE = DEFAULT;
-- fixture_teardown:
ROLLBACK;
