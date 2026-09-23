-- generated_from: manifest_execute_rownum_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_execute_rownum_negative_7b18aa86edd9
-- expected: error
-- expected_error_category: unsupported_parameter_expression
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"name": "execute_name_one", "parameters": "execute_parameters_rownum"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["execute_fact_current_session"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
EXECUTE p_ps_one(ROWNUM);
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;
