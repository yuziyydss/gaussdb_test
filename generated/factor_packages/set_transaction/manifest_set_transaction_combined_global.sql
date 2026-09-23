-- generated_from: manifest_set_transaction_combined_global
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_transaction_combined_global_d1bc27344dae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_read_only", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;
