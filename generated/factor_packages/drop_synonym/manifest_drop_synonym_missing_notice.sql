-- generated_from: manifest_drop_synonym_missing_notice
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_synonym_missing_notice_f7f41dbbab20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_default", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_absent"}
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_absent;

-- case_id: manifest_drop_synonym_missing_notice_cbdcdb2c43fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_restrict", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_absent"}
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_absent RESTRICT;

-- case_id: manifest_drop_synonym_missing_notice_1a9db9c66193
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_cascade", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_absent"}
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_absent CASCADE;
