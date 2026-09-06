-- generated_from: manifest_set_transaction_current
-- static_only: true
-- case_count: 12

-- case_id: manifest_set_transaction_current_c0f9ff28f527
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_b38962786a1d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_212481ca105d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_13ef3d75e0d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_99f74f70c1d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_36d7dce44e88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_implicit"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_f9341ea632cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_e70951142abb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_5d4e390ccb37
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_05265898bc63
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_537f5c4aca7d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_transaction_current_e394c1538c7f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_local"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;
