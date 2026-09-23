-- generated_from: manifest_alter_operator_owner
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_operator_owner_d74bed4321fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_operator_action_owner", "signature": "alter_operator_signature_binary"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_operator_fact_owner_privilege"], "key": "operator_owner_authorized"}, {"allowed_values": ["current_session_user_is_member"], "fact_refs": ["alter_operator_fact_membership"], "key": "operator_owner_membership"}, {"allowed_values": ["true"], "fact_refs": ["alter_operator_fact_schema_privilege"], "key": "operator_owner_schema_privilege"}, {"allowed_values": ["dedicated_nologin_fixture_role"], "fact_refs": ["alter_operator_fact_owner_profile"], "key": "operator_owner_static_profile"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
CREATE SCHEMA op_b7_target;
CREATE ROLE b7_operator_owner NOLOGIN PASSWORD DISABLE;
GRANT b7_operator_owner TO CURRENT_USER;
-- test_sql:
ALTER OPERATOR @#@ (INTEGER, INTEGER) OWNER TO b7_operator_owner;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
