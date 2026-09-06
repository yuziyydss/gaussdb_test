-- generated_from: manifest_rollback_to_savepoint_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_rollback_to_savepoint_positive_e5128ee14b13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_absent", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_absent", "savepoint_name": "rollback_to_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TO sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_positive_ce8291a45c14
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_work", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_present", "savepoint_name": "rollback_to_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK WORK TO SAVEPOINT sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_positive_244f28f2b541
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_transaction", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_absent", "savepoint_name": "rollback_to_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TRANSACTION TO sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_positive_f10a11a8d5fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_absent", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_present", "savepoint_name": "rollback_to_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TO SAVEPOINT sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_positive_5c16d302d407
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_work", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_absent", "savepoint_name": "rollback_to_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK WORK TO sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_rollback_to_savepoint_positive_faf5207e1fd0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "rollback_to_savepoint_compatibility_keyword_transaction", "savepoint_keyword": "rollback_to_savepoint_savepoint_keyword_present", "savepoint_name": "rollback_to_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
ROLLBACK TRANSACTION TO SAVEPOINT sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
