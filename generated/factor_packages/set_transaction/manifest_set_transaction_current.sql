-- generated_from: manifest_set_transaction_current
-- static_only: true
-- case_count: 12

-- case_id: manifest_set_transaction_current_c3e3bcbf2ee8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_5e80df5d94e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_d6666563bbe4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_645097bb9c6e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_42f22106d2dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_ec99c2606149
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_0104fe38c12b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_ac7e61837e10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_9103ed7d7e10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_b48d9c22f873
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_9b8e776b4789
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_db3420f05e2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;
