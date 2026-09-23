-- generated_from: manifest_set_transaction_combined_local
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_transaction_combined_local_1629dd585273
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_read_only", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
