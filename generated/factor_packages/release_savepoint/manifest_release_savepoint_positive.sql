-- generated_from: manifest_release_savepoint_positive
-- static_only: true
-- case_count: 2

-- case_id: manifest_release_savepoint_positive_38f17d36af6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"savepoint_keyword": "release_savepoint_savepoint_keyword_absent", "savepoint_name": "release_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
RELEASE sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_release_savepoint_positive_3be35374080b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"savepoint_keyword": "release_savepoint_savepoint_keyword_present", "savepoint_name": "release_savepoint_savepoint_name_existing"}
-- fixture_setup:
START TRANSACTION;
SAVEPOINT sp_test;
-- test_sql:
RELEASE SAVEPOINT sp_test;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
