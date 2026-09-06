-- generated_from: manifest_set_transaction_session_characteristics
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_transaction_session_characteristics_c97e5e6cec46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_set_transaction_session_characteristics_75ac2b1b7155
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_set_transaction_session_characteristics_06a1b77e0df3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_set_transaction_session_characteristics_35fc1edbfca4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_set_transaction_session_characteristics_76be531ee4c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;

-- case_id: manifest_set_transaction_session_characteristics_1b241bd5d362
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_session_characteristics"}
-- test_sql:
SET SESSION CHARACTERISTICS AS TRANSACTION READ ONLY;
