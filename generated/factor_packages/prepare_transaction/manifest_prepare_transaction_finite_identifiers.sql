-- generated_from: manifest_prepare_transaction_finite_identifiers
-- static_only: true
-- case_count: 2

-- case_id: manifest_prepare_transaction_finite_identifiers_c3a1cd9a0217
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"transaction_id": "prepare_transaction_transaction_id_short"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["prepare_transaction_fact_internal"], "key": "internal_two_phase_testing"}, {"allowed_values": ["true"], "fact_refs": ["prepare_transaction_fact_capacity"], "key": "prepared_transactions_capacity_ready"}]
-- fixture_setup:
BEGIN;
-- test_sql:
PREPARE TRANSACTION 'fp_pt_short';
-- fixture_teardown:
ROLLBACK PREPARED 'fp_pt_short';
ROLLBACK;

-- case_id: manifest_prepare_transaction_finite_identifiers_4357bab81c30
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"transaction_id": "prepare_transaction_transaction_id_max_valid"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["prepare_transaction_fact_internal"], "key": "internal_two_phase_testing"}, {"allowed_values": ["true"], "fact_refs": ["prepare_transaction_fact_capacity"], "key": "prepared_transactions_capacity_ready"}]
-- fixture_setup:
BEGIN;
-- test_sql:
PREPARE TRANSACTION 'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp';
-- fixture_teardown:
ROLLBACK PREPARED 'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp';
ROLLBACK;
