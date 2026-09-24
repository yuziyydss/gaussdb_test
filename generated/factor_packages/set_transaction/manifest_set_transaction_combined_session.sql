-- generated_from: manifest_set_transaction_combined_session
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_transaction_combined_session_5dccb526467a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_read_only", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;
