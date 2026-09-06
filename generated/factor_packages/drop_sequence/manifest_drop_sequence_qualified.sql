-- generated_from: manifest_drop_sequence_qualified
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_sequence_qualified_ce0192552d72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_qualified"}
-- fixture_setup:
CREATE SCHEMA ds_batch03;
CREATE SEQUENCE ds_batch03.seq_qualified;
-- test_sql:
DROP SEQUENCE ds_batch03.seq_qualified;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
DROP SCHEMA ds_batch03;

-- case_id: manifest_drop_sequence_qualified_d73e87480218
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_qualified"}
-- fixture_setup:
CREATE SCHEMA ds_batch03;
CREATE SEQUENCE ds_batch03.seq_qualified;
-- test_sql:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified RESTRICT;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
DROP SCHEMA ds_batch03;

-- case_id: manifest_drop_sequence_qualified_c3e071ffab44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_cascade", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_qualified"}
-- fixture_setup:
CREATE SCHEMA ds_batch03;
CREATE SEQUENCE ds_batch03.seq_qualified;
-- test_sql:
DROP SEQUENCE ds_batch03.seq_qualified CASCADE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
DROP SCHEMA ds_batch03;

-- case_id: manifest_drop_sequence_qualified_d88eaff2cdcf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_restrict", "if_exists": "drop_sequence_if_exists_absent", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_qualified"}
-- fixture_setup:
CREATE SCHEMA ds_batch03;
CREATE SEQUENCE ds_batch03.seq_qualified;
-- test_sql:
DROP SEQUENCE ds_batch03.seq_qualified RESTRICT;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
DROP SCHEMA ds_batch03;

-- case_id: manifest_drop_sequence_qualified_ec32fe719df4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_default", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_qualified"}
-- fixture_setup:
CREATE SCHEMA ds_batch03;
CREATE SEQUENCE ds_batch03.seq_qualified;
-- test_sql:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
DROP SCHEMA ds_batch03;

-- case_id: manifest_drop_sequence_qualified_e6c5bfc14866
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_sequence_behavior_cascade", "if_exists": "drop_sequence_if_exists_present", "large": "drop_sequence_large_absent", "targets": "drop_sequence_targets_qualified"}
-- fixture_setup:
CREATE SCHEMA ds_batch03;
CREATE SEQUENCE ds_batch03.seq_qualified;
-- test_sql:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified CASCADE;
-- fixture_teardown:
DROP SEQUENCE IF EXISTS ds_batch03.seq_qualified;
DROP SCHEMA ds_batch03;
