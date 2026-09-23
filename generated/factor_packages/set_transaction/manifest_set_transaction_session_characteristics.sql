-- generated_from: manifest_set_transaction_session_characteristics
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_transaction_session_characteristics_38a0819aebec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_set_transaction_session_characteristics_951dfa2f3f23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_set_transaction_session_characteristics_2ccb105ae18a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_set_transaction_session_characteristics_1fd667dc107c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_set_transaction_session_characteristics_ecf901b0e014
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;

-- case_id: manifest_set_transaction_session_characteristics_668453fcb1f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION READ ONLY;
