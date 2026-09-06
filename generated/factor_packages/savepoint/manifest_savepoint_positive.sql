-- generated_from: manifest_savepoint_positive
-- static_only: true
-- case_count: 1

-- case_id: manifest_savepoint_positive_51d55c8321ac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"savepoint_name": "savepoint_savepoint_name_simple"}
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SAVEPOINT sp_test;
-- fixture_teardown:
ROLLBACK;
