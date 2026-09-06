-- generated_from: manifest_prepare_duplicate_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_prepare_duplicate_negative_cffcdcdd8491
-- expected: error
-- expected_error_category: duplicate_prepared_statement
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_duplicate", "signature": "prepare_signature_one", "statement_form": "prepare_statement_form_select"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
CREATE TABLE t_prepare_source (id INTEGER NOT NULL, note VARCHAR(10), detail VARCHAR(10));
INSERT INTO t_prepare_source VALUES (1, 'seed', 'seed');
PREPARE p_ps_zero AS SELECT 1 AS a;
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10)) AS INSERT INTO t_prepare_source VALUES ($1, $2, $3);
-- test_sql:
PREPARE p_ps_one(INTEGER) AS SELECT CAST($1 AS INTEGER) AS a;
-- fixture_teardown:
DEALLOCATE ALL;
DROP TABLE t_prepare_source;
DEALLOCATE ALL;
