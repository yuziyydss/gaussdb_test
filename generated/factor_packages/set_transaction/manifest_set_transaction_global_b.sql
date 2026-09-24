-- generated_from: manifest_set_transaction_global_b
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_transaction_global_b_7e65b326739a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_set_transaction_global_b_5ea12a3f923c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_set_transaction_global_b_9bc18dbdadcf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_set_transaction_global_b_c189eee405c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_set_transaction_global_b_3716ca4fe913
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION READ WRITE;

-- case_id: manifest_set_transaction_global_b_27f3cffc14d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access_mode": "set_transaction_access_mode_none", "characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION READ ONLY;
