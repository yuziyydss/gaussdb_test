-- generated_from: manifest_m_alter_session_transaction
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_session_transaction_b714f9ce538e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_read", "form": "m_alter_session_form_transaction", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_alter_session_fact_transaction"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_alter_session_transaction_5f940cf842db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_write", "form": "m_alter_session_form_transaction", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_alter_session_fact_transaction"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_alter_session_transaction_4504a6ca37e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_committed", "form": "m_alter_session_form_transaction", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_alter_session_fact_transaction"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_alter_session_transaction_c94846a30c5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_uncommitted", "form": "m_alter_session_form_transaction", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_alter_session_fact_transaction"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_alter_session_transaction_6ba0e085ecaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_repeatable", "form": "m_alter_session_form_transaction", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_alter_session_fact_transaction"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_alter_session_transaction_a35047c061ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_serializable", "form": "m_alter_session_form_transaction", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["before_first_data_statement"], "fact_refs": ["m_alter_session_fact_transaction"], "key": "transaction_stage"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;
