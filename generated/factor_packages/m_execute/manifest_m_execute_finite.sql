-- generated_from: manifest_m_execute_finite
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_execute_finite_e09c0ae3aada
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_execute_name_read"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_execute_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_execute_fact_same_session", "m_prepare::m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_execute_data (id INT,qty INT);
INSERT INTO m_execute_data VALUES (1,10),(2,20);
PREPARE m_execute_read FROM 'SELECT id,qty FROM m_execute_data ORDER BY id';
PREPARE m_execute_write FROM 'UPDATE m_execute_data SET qty=99 WHERE id=1';
-- test_sql:
EXECUTE m_execute_read;
-- fixture_teardown:
DEALLOCATE PREPARE m_execute_read;
DEALLOCATE PREPARE m_execute_write;
DROP TABLE m_execute_data;

-- case_id: manifest_m_execute_finite_07135736a5fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "m_execute_name_write"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_execute_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_execute_fact_same_session", "m_prepare::m_prepare_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE TABLE m_execute_data (id INT,qty INT);
INSERT INTO m_execute_data VALUES (1,10),(2,20);
PREPARE m_execute_read FROM 'SELECT id,qty FROM m_execute_data ORDER BY id';
PREPARE m_execute_write FROM 'UPDATE m_execute_data SET qty=99 WHERE id=1';
-- test_sql:
EXECUTE m_execute_write;
-- fixture_teardown:
DEALLOCATE PREPARE m_execute_read;
DEALLOCATE PREPARE m_execute_write;
DROP TABLE m_execute_data;
