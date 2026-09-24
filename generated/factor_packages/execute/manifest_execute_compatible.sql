-- generated_from: manifest_execute_compatible
-- static_only: true
-- case_count: 11

-- case_id: manifest_execute_compatible_bce63fe8881b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_absent"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_587d565052c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_integer"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero(52);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_348616266734
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_expression"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero(1 + 1);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_fd8c0640e311
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_null"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero(CAST(NULL AS INTEGER));
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_6d564119840a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_three"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero(52, 'AAAAAAAADD', 'reason 52');
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_e7a887d4726a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_text"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero('not_integer');
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_81493666afff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_zero", "parameters": "execute_parameters_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_zero(1, 2);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_bd7795115f0a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_integer"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one(52);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_30bcb6164a4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_expression"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one(1 + 1);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_9c43a1af1f14
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_null"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one(CAST(NULL AS INTEGER));
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_compatible_d239281345c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_three"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three(52, 'AAAAAAAADD', 'reason 52');
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;
