-- generated_from: manifest_drop_materialized_view_missing
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_materialized_view_missing_a97e74f0590a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_default", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_missing"}
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_absent;

-- case_id: manifest_drop_materialized_view_missing_003c4e9adc52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_restrict", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_missing"}
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_absent RESTRICT;

-- case_id: manifest_drop_materialized_view_missing_79bfea92c358
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_cascade", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_missing"}
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_absent CASCADE;
