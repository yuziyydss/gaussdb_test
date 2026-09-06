-- generated_from: manifest_execute_parameters_negative
-- static_only: true
-- case_count: 10

-- case_id: manifest_execute_parameters_negative_d27289fb082e
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_absent"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_ab6481ee061b
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_three"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one(52, 'AAAAAAAADD', 'reason 52');
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_861aed757fbc
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_text"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one('not_integer');
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_f1ca21f7f69f
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one(1, 2);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_67fd0dda11ea
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_absent"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_d3aa26d12626
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_integer"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three(52);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_87a0bfe70e7e
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_expression"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three(1 + 1);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_0357bb9dac85
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_null"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three(CAST(NULL AS INTEGER));
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_d49665ef9129
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_text"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three('not_integer');
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;

-- case_id: manifest_execute_parameters_negative_75b4730bd8ae
-- expected: error
-- expected_error_category: incompatible_prepared_parameters
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_three", "parameters": "execute_parameters_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_three(1, 2);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;
