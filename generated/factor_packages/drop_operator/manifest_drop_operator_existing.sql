-- generated_from: manifest_drop_operator_existing
-- static_only: true
-- case_count: 9

-- case_id: manifest_drop_operator_existing_cf3d25998fe0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_default", "if_exists": "drop_operator_if_exists_no", "signature": "drop_operator_signature_binary"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR @#@ (INTEGER, INTEGER);
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_5c0f5572c348
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_cascade", "if_exists": "drop_operator_if_exists_yes", "signature": "drop_operator_signature_binary"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR IF EXISTS @#@ (INTEGER, INTEGER) CASCADE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_76ee2253ee9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_cascade", "if_exists": "drop_operator_if_exists_no", "signature": "drop_operator_signature_prefix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR @#@ (NONE, INTEGER) CASCADE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_3e51b71619d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_default", "if_exists": "drop_operator_if_exists_yes", "signature": "drop_operator_signature_prefix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR IF EXISTS @#@ (NONE, INTEGER);
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_2c33373a16bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_restrict", "if_exists": "drop_operator_if_exists_no", "signature": "drop_operator_signature_postfix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR @#@ (INTEGER, NONE) RESTRICT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_09b325aef115
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_restrict", "if_exists": "drop_operator_if_exists_yes", "signature": "drop_operator_signature_binary"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR IF EXISTS @#@ (INTEGER, INTEGER) RESTRICT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_e9a6ea813e2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_default", "if_exists": "drop_operator_if_exists_yes", "signature": "drop_operator_signature_postfix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR IF EXISTS @#@ (INTEGER, NONE);
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_f570416dc100
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_restrict", "if_exists": "drop_operator_if_exists_no", "signature": "drop_operator_signature_prefix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR @#@ (NONE, INTEGER) RESTRICT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_operator_existing_6785b3a1cc43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_operator_behavior_cascade", "if_exists": "drop_operator_if_exists_no", "signature": "drop_operator_signature_postfix"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator::create_operator_fact_privilege"], "key": "operator_creator_authorized"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
BEGIN;
CREATE FUNCTION op_b7_unary(INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1;';
CREATE OPERATOR @#@ (PROCEDURE = fp_cf_callable, LEFTARG = INTEGER, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, RIGHTARG = INTEGER);
CREATE OPERATOR @#@ (PROCEDURE = op_b7_unary, LEFTARG = INTEGER);
-- test_sql:
DROP OPERATOR @#@ (INTEGER, NONE) CASCADE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
