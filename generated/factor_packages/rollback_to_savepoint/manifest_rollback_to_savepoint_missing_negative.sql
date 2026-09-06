-- generated_from: manifest_rollback_to_savepoint_missing_negative
-- static_only: true
-- case_count: 6

-- case_id: manifest_rollback_to_savepoint_missing_negative_59ea87c0d51e
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_absent", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_absent", "savepoint_name": "rollback_to_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TO sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_missing_negative_8e5c4ef01433
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_work", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_present", "savepoint_name": "rollback_to_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK WORK TO SAVEPOINT sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_missing_negative_c6bcbf2256e8
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_transaction", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_absent", "savepoint_name": "rollback_to_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TRANSACTION TO sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_missing_negative_cd3c686ca911
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_absent", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_present", "savepoint_name": "rollback_to_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TO SAVEPOINT sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_missing_negative_c9dfbb33ca62
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_work", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_absent", "savepoint_name": "rollback_to_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK WORK TO sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_missing_negative_f3dff3773d5d
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_transaction", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_present", "savepoint_name": "rollback_to_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TRANSACTION TO SAVEPOINT sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
