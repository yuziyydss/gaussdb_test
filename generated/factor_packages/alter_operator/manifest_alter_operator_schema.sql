-- generated_from: manifest_alter_operator_schema
-- static_only: true
-- case_count: 3

-- case_id: manifest_alter_operator_schema_628e2a5c52c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_operator_action_schema", "signature": "alter_operator_signature_binary"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_operator_fact_owner_privilege"], "key": "operator_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
CREATE SCHEMA op_b7_target;
-- test_sql:
ALTER OPERATOR @#@ (INTEGER, INTEGER) SET SCHEMA op_b7_target;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_operator_schema_7214ffd09562
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_operator_action_schema", "signature": "alter_operator_signature_prefix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_operator_fact_owner_privilege"], "key": "operator_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
CREATE SCHEMA op_b7_target;
-- test_sql:
ALTER OPERATOR @#@ (NONE, INTEGER) SET SCHEMA op_b7_target;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_operator_schema_3d152cefb254
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_operator_action_schema", "signature": "alter_operator_signature_postfix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_operator_fact_owner_privilege"], "key": "operator_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
CREATE SCHEMA op_b7_target;
-- test_sql:
ALTER OPERATOR @#@ (INTEGER, NONE) SET SCHEMA op_b7_target;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
