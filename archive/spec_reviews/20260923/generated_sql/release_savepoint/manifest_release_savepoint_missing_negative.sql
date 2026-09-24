-- generated_from: manifest_release_savepoint_missing_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_release_savepoint_missing_negative_7b68d31801ac
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"savepoint_keyword": "release_savepoint_savepoint_keyword_absent", "savepoint_name": "release_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
RELEASE sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_release_savepoint_missing_negative_fbd31cf56cad
-- expected: error
-- expected_error_category: savepoint_missing
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"savepoint_keyword": "release_savepoint_savepoint_keyword_present", "savepoint_name": "release_savepoint_savepoint_name_missing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
RELEASE SAVEPOINT sp_missing;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
