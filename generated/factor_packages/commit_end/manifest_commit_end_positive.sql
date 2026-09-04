-- generated_from: manifest_commit_end_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_commit_end_positive_53e926c4bbe7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command_keyword": "commit_end_command_commit", "compatibility_keyword": "commit_end_compat_absent"}
-- test_sql:
COMMIT;

-- case_id: manifest_commit_end_positive_858267d8cd75
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command_keyword": "commit_end_command_commit", "compatibility_keyword": "commit_end_compat_work"}
-- test_sql:
COMMIT WORK;

-- case_id: manifest_commit_end_positive_dc8bad1fe13a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command_keyword": "commit_end_command_commit", "compatibility_keyword": "commit_end_compat_transaction"}
-- test_sql:
COMMIT TRANSACTION;

-- case_id: manifest_commit_end_positive_a85f2e39d30c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command_keyword": "commit_end_command_end", "compatibility_keyword": "commit_end_compat_absent"}
-- test_sql:
END;

-- case_id: manifest_commit_end_positive_53e10f43cf72
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command_keyword": "commit_end_command_end", "compatibility_keyword": "commit_end_compat_work"}
-- test_sql:
END WORK;

-- case_id: manifest_commit_end_positive_d398414d9101
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command_keyword": "commit_end_command_end", "compatibility_keyword": "commit_end_compat_transaction"}
-- test_sql:
END TRANSACTION;
