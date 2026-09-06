-- generated_from: manifest_create_operator_arity
-- static_only: true
-- case_count: 6

-- case_id: manifest_create_operator_arity_f4245ba17967
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arity": "create_operator_arity_binary", "operator_name": "create_operator_operator_name_at"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
-- test_sql:
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
-- fixture_teardown:
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_operator_arity_a2d5f2bad17f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arity": "create_operator_arity_binary", "operator_name": "create_operator_operator_name_question"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
-- test_sql:
CREATE OPERATOR ?#? (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
-- fixture_teardown:
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_operator_arity_ace91869bd70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arity": "create_operator_arity_prefix", "operator_name": "create_operator_operator_name_at"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
-- test_sql:
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
-- fixture_teardown:
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_operator_arity_76ee3db24080
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arity": "create_operator_arity_prefix", "operator_name": "create_operator_operator_name_question"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
-- test_sql:
CREATE OPERATOR ?#? (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
-- fixture_teardown:
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_operator_arity_81f76c12f776
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arity": "create_operator_arity_postfix", "operator_name": "create_operator_operator_name_at"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
-- test_sql:
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- fixture_teardown:
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_operator_arity_786a9e4bb4a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arity": "create_operator_arity_postfix", "operator_name": "create_operator_operator_name_question"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
-- test_sql:
CREATE OPERATOR ?#? (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- fixture_teardown:
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
