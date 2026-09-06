-- generated_from: manifest_rollback_positive
-- static_only: true
-- case_count: 3

-- case_id: manifest_rollback_positive_efa0ac559d69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"compatibility_keyword": "rollback_compat_absent"}
-- test_sql:
ROLLBACK;

-- case_id: manifest_rollback_positive_049abb0dfc93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"compatibility_keyword": "rollback_compat_work"}
-- test_sql:
ROLLBACK WORK;

-- case_id: manifest_rollback_positive_2a7fbf2e6792
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"compatibility_keyword": "rollback_compat_transaction"}
-- test_sql:
ROLLBACK TRANSACTION;
