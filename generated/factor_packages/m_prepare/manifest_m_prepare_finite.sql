-- generated_from: manifest_m_prepare_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_prepare_finite_d375d9a9dc43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_select"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'SELECT id,qty FROM m_prepare_data WHERE id=1';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;

-- case_id: manifest_m_prepare_finite_89f2dd0304e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_insert"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'INSERT INTO m_prepare_data (id,qty) VALUES (3,30)';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;

-- case_id: manifest_m_prepare_finite_fd81ab7f22f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_update"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'UPDATE m_prepare_data SET qty=11 WHERE id=1';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;

-- case_id: manifest_m_prepare_finite_0bbb583f73a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"body": "m_prepare_body_delete"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_prepare_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_prepare_data (id INT,qty INT);
INSERT INTO m_prepare_data VALUES (1,10),(2,20);
-- test_sql:
PREPARE m_prepare_stmt FROM 'DELETE FROM m_prepare_data WHERE id=2';
-- fixture_teardown:
DEALLOCATE PREPARE m_prepare_stmt;
DROP TABLE m_prepare_data;
