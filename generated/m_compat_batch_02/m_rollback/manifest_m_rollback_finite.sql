-- generated_from: manifest_m_rollback_finite
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_rollback_finite_fee64f5324dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"work": "m_rollback_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_data (id INT);
INSERT INTO m_rollback_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_data VALUES (1);
-- test_sql:
ROLLBACK;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_data;

-- case_id: manifest_m_rollback_finite_35928f8cdd6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"work": "m_rollback_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_data (id INT);
INSERT INTO m_rollback_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_data VALUES (1);
-- test_sql:
ROLLBACK WORK;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_data;

-- case_id: manifest_m_rollback_finite_22032779cbcd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"work": "m_rollback_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_data (id INT);
INSERT INTO m_rollback_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_data VALUES (1);
-- test_sql:
ROLLBACK TRANSACTION;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_data;
