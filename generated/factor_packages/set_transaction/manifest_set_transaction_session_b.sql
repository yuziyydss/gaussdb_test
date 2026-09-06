-- generated_from: manifest_set_transaction_session_b
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_transaction_session_b_87f6887701c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rc", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- case_id: manifest_set_transaction_session_b_4a35a62175d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ru", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- case_id: manifest_set_transaction_session_b_fd4aa9dad3d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rr", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- case_id: manifest_set_transaction_session_b_6509c8d82917
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_serializable", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- case_id: manifest_set_transaction_session_b_7de6b77864d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_rw", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION READ WRITE;

-- case_id: manifest_set_transaction_session_b_b627afc91a47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "set_transaction_characteristic_ro", "scope": "set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "compatibility_mode"}, {"allowed_values": ["set_session_transaction"], "fact_refs": ["set_transaction_fact_session_gate"], "key": "b_format_behavior_compat_options"}]
-- test_sql:
SET SESSION TRANSACTION READ ONLY;
