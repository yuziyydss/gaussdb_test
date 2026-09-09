-- generated_from: manifest_m_commit_finite
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_commit_finite_5f8b5528f236
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"work": "m_commit_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_commit_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_commit_data (id INT);
INSERT INTO m_commit_data VALUES (0);
BEGIN;
INSERT INTO m_commit_data VALUES (1);
-- test_sql:
COMMIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_commit_data;

-- case_id: manifest_m_commit_finite_0e68416d1c49
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"work": "m_commit_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_commit_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_commit_data (id INT);
INSERT INTO m_commit_data VALUES (0);
BEGIN;
INSERT INTO m_commit_data VALUES (1);
-- test_sql:
COMMIT WORK;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_commit_data;

-- case_id: manifest_m_commit_finite_bfc348306f42
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"work": "m_commit_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_commit_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_commit_data (id INT);
INSERT INTO m_commit_data VALUES (0);
BEGIN;
INSERT INTO m_commit_data VALUES (1);
-- test_sql:
COMMIT TRANSACTION;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_commit_data;
