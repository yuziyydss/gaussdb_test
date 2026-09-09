-- generated_from: manifest_m_rollback_to_savepoint_finite
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_rollback_to_savepoint_finite_f459d8828d10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_rollback_to_savepoint_name_first", "savepoint_word": "m_rollback_to_savepoint_savepoint_word_none", "work": "m_rollback_to_savepoint_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_to_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_to_savepoint_data (id INT);
INSERT INTO m_rollback_to_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
-- test_sql:
ROLLBACK TO m_rollback_to_savepoint_sp1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_to_savepoint_data;

-- case_id: manifest_m_rollback_to_savepoint_finite_ee07f0cee155
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_rollback_to_savepoint_name_first", "savepoint_word": "m_rollback_to_savepoint_savepoint_word_yes", "work": "m_rollback_to_savepoint_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_to_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_to_savepoint_data (id INT);
INSERT INTO m_rollback_to_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
-- test_sql:
ROLLBACK WORK TO SAVEPOINT m_rollback_to_savepoint_sp1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_to_savepoint_data;

-- case_id: manifest_m_rollback_to_savepoint_finite_cf64daee9389
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_rollback_to_savepoint_name_second", "savepoint_word": "m_rollback_to_savepoint_savepoint_word_none", "work": "m_rollback_to_savepoint_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_to_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_to_savepoint_data (id INT);
INSERT INTO m_rollback_to_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
-- test_sql:
ROLLBACK WORK TO m_rollback_to_savepoint_sp2;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_to_savepoint_data;

-- case_id: manifest_m_rollback_to_savepoint_finite_79aa18d0ca93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_rollback_to_savepoint_name_second", "savepoint_word": "m_rollback_to_savepoint_savepoint_word_yes", "work": "m_rollback_to_savepoint_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_to_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_to_savepoint_data (id INT);
INSERT INTO m_rollback_to_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
-- test_sql:
ROLLBACK TO SAVEPOINT m_rollback_to_savepoint_sp2;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_to_savepoint_data;

-- case_id: manifest_m_rollback_to_savepoint_finite_56e9e728e8de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_rollback_to_savepoint_name_first", "savepoint_word": "m_rollback_to_savepoint_savepoint_word_none", "work": "m_rollback_to_savepoint_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_to_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_to_savepoint_data (id INT);
INSERT INTO m_rollback_to_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
-- test_sql:
ROLLBACK TRANSACTION TO m_rollback_to_savepoint_sp1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_to_savepoint_data;

-- case_id: manifest_m_rollback_to_savepoint_finite_858da9a8fdd6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_rollback_to_savepoint_name_second", "savepoint_word": "m_rollback_to_savepoint_savepoint_word_yes", "work": "m_rollback_to_savepoint_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rollback_to_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rollback_to_savepoint_data (id INT);
INSERT INTO m_rollback_to_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
-- test_sql:
ROLLBACK TRANSACTION TO SAVEPOINT m_rollback_to_savepoint_sp2;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_rollback_to_savepoint_data;
