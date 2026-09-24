-- generated_from: manifest_m_set_transaction_combined_local
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_transaction_combined_local_9683bb2ff1fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "m_set_transaction_access_mode_read_only", "characteristic": "m_set_transaction_characteristic_committed", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}]
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;
