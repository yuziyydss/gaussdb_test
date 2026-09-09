-- generated_from: manifest_m_release_savepoint_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_release_savepoint_finite_addb799a7ad7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_release_savepoint_name_first", "savepoint_word": "m_release_savepoint_savepoint_word_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_release_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_release_savepoint_data (id INT);
INSERT INTO m_release_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_release_savepoint_data VALUES (1);
SAVEPOINT m_release_savepoint_sp1;
INSERT INTO m_release_savepoint_data VALUES (2);
SAVEPOINT m_release_savepoint_sp2;
INSERT INTO m_release_savepoint_data VALUES (3);
-- test_sql:
RELEASE m_release_savepoint_sp1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_release_savepoint_data;

-- case_id: manifest_m_release_savepoint_finite_f124bc2ea806
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_release_savepoint_name_first", "savepoint_word": "m_release_savepoint_savepoint_word_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_release_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_release_savepoint_data (id INT);
INSERT INTO m_release_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_release_savepoint_data VALUES (1);
SAVEPOINT m_release_savepoint_sp1;
INSERT INTO m_release_savepoint_data VALUES (2);
SAVEPOINT m_release_savepoint_sp2;
INSERT INTO m_release_savepoint_data VALUES (3);
-- test_sql:
RELEASE SAVEPOINT m_release_savepoint_sp1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_release_savepoint_data;

-- case_id: manifest_m_release_savepoint_finite_99c7cfd72c67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_release_savepoint_name_second", "savepoint_word": "m_release_savepoint_savepoint_word_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_release_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_release_savepoint_data (id INT);
INSERT INTO m_release_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_release_savepoint_data VALUES (1);
SAVEPOINT m_release_savepoint_sp1;
INSERT INTO m_release_savepoint_data VALUES (2);
SAVEPOINT m_release_savepoint_sp2;
INSERT INTO m_release_savepoint_data VALUES (3);
-- test_sql:
RELEASE m_release_savepoint_sp2;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_release_savepoint_data;

-- case_id: manifest_m_release_savepoint_finite_2672b3b048b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_release_savepoint_name_second", "savepoint_word": "m_release_savepoint_savepoint_word_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_release_savepoint_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_release_savepoint_data (id INT);
INSERT INTO m_release_savepoint_data VALUES (0);
BEGIN;
INSERT INTO m_release_savepoint_data VALUES (1);
SAVEPOINT m_release_savepoint_sp1;
INSERT INTO m_release_savepoint_data VALUES (2);
SAVEPOINT m_release_savepoint_sp2;
INSERT INTO m_release_savepoint_data VALUES (3);
-- test_sql:
RELEASE SAVEPOINT m_release_savepoint_sp2;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_release_savepoint_data;
