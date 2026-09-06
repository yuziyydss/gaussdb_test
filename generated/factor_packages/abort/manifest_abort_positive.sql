-- generated_from: manifest_abort_positive
-- static_only: true
-- case_count: 3

-- case_id: manifest_abort_positive_ddb6eedcfedd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "abort_compatibility_keyword_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_rollback_test CASCADE;
CREATE TABLE t_rollback_test (id INTEGER, name TEXT);
INSERT INTO t_rollback_test VALUES (1, 'original');
BEGIN;
UPDATE t_rollback_test SET name = 'pending' WHERE id = 1;
-- test_sql:
ABORT;
-- fixture_teardown:
ROLLBACK;
DELETE FROM t_rollback_test;
DROP TABLE IF EXISTS t_rollback_test CASCADE;

-- case_id: manifest_abort_positive_36561c80f0bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "abort_compatibility_keyword_work"}
-- fixture_setup:
DROP TABLE IF EXISTS t_rollback_test CASCADE;
CREATE TABLE t_rollback_test (id INTEGER, name TEXT);
INSERT INTO t_rollback_test VALUES (1, 'original');
BEGIN;
UPDATE t_rollback_test SET name = 'pending' WHERE id = 1;
-- test_sql:
ABORT WORK;
-- fixture_teardown:
ROLLBACK;
DELETE FROM t_rollback_test;
DROP TABLE IF EXISTS t_rollback_test CASCADE;

-- case_id: manifest_abort_positive_4548b5c6d32d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"compatibility_keyword": "abort_compatibility_keyword_transaction"}
-- fixture_setup:
DROP TABLE IF EXISTS t_rollback_test CASCADE;
CREATE TABLE t_rollback_test (id INTEGER, name TEXT);
INSERT INTO t_rollback_test VALUES (1, 'original');
BEGIN;
UPDATE t_rollback_test SET name = 'pending' WHERE id = 1;
-- test_sql:
ABORT TRANSACTION;
-- fixture_teardown:
ROLLBACK;
DELETE FROM t_rollback_test;
DROP TABLE IF EXISTS t_rollback_test CASCADE;
