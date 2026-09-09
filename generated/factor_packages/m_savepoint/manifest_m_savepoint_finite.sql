-- generated_from: manifest_m_savepoint_finite
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_savepoint_finite_f829390e3434
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_savepoint_name_first"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_savepoint_data (id INT);
INSERT INTO m_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_savepoint_data VALUES (1);
-- test_sql:
SAVEPOINT m_savepoint_sp1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_savepoint_data;

-- case_id: manifest_m_savepoint_finite_214bd7b016e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_savepoint_name_second"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_savepoint_data (id INT);
INSERT INTO m_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_savepoint_data VALUES (1);
-- test_sql:
SAVEPOINT m_savepoint_sp2;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_savepoint_data;
