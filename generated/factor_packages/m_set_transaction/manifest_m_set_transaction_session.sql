-- generated_from: manifest_m_set_transaction_session
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_transaction_session_76794ef9fcc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_committed", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_7ecc98c77ce7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_uncommitted", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_6c411fe2a6b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_serializable", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_64b48b97dfa8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_repeatable", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_46258240138f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_write", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_6eb58b4663cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_read", "scope": "m_set_transaction_scope_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_be8f20ba686f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_committed", "scope": "m_set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_c61921b3eba4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_uncommitted", "scope": "m_set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_380c0a54a03b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_serializable", "scope": "m_set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_2f74bb7bf151
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_repeatable", "scope": "m_set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_41ad90c3b148
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_write", "scope": "m_set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_transaction_session_8b4026f45ac7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_set_transaction_characteristic_read", "scope": "m_set_transaction_scope_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_transaction_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_transaction_fact_local_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_set_transaction_fact_before_data"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;
