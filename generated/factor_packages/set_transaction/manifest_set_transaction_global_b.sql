-- generated_from: manifest_set_transaction_global_b
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_transaction_global_b_e800a5c49b36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_set_transaction_global_b_25719cb4857d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_set_transaction_global_b_2d92984c973c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_set_transaction_global_b_e937a8cadfa3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_set_transaction_global_b_4b3a18808732
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION READ WRITE;

-- case_id: manifest_set_transaction_global_b_e449f6ce4dc8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_global"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_global_gate"], "key": "compatibility_mode"}]
-- test_sql:
SET GLOBAL TRANSACTION READ ONLY;
