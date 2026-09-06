-- generated_from: manifest_commit_prepared_owned_transaction
-- static_only: true
-- case_count: 1

-- case_id: manifest_commit_prepared_owned_transaction_5bb9b59d09bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"transaction_id": "commit_prepared_transaction_id_owned"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["commit_prepared_fact_internal"], "key": "internal_two_phase_testing"}, {"allowed_values": ["true"], "fact_refs": ["prepare_transaction::prepare_transaction_fact_capacity"], "key": "prepared_transactions_capacity_ready"}, {"allowed_values": ["true"], "fact_refs": ["commit_prepared_fact_permission"], "key": "prepared_owner_or_sysadmin"}]
-- fixture_setup:
BEGIN;
PREPARE TRANSACTION 'fp_commit_prepared_owned';
-- test_sql:
COMMIT PREPARED 'fp_commit_prepared_owned';
-- fixture_teardown:
ROLLBACK;
