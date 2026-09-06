-- generated_from: manifest_create_function_sql_options
-- static_only: true
-- case_count: 19

-- case_id: manifest_create_function_sql_options_130931bb7322
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n0", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v0"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_3750e876521a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_explicit", "cost": "create_function_cost_c1", "name": "create_function_name_new", "nulls": "create_function_nulls_n1", "replace": "create_function_replace_yes", "security": "create_function_security_s1", "volatility": "create_function_volatility_v1"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE OR REPLACE FUNCTION fp_cf_add (num1 IN INTEGER, num2 IN INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE CALLED ON NULL INPUT EXTERNAL SECURITY INVOKER COST 1 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_362f258e1c31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_explicit", "cost": "create_function_cost_c2", "name": "create_function_name_new", "nulls": "create_function_nulls_n2", "replace": "create_function_replace_none", "security": "create_function_security_s2", "volatility": "create_function_volatility_v2"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 IN INTEGER, num2 IN INTEGER) RETURNS INTEGER LANGUAGE SQL STABLE RETURNS NULL ON NULL INPUT AUTHID CURRENT_USER COST 10 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_1f02d71792bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c2", "name": "create_function_name_new", "nulls": "create_function_nulls_n3", "replace": "create_function_replace_yes", "security": "create_function_security_s0", "volatility": "create_function_volatility_v3"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE OR REPLACE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL VOLATILE STRICT SECURITY INVOKER COST 10 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_5eef4117b3f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c1", "name": "create_function_name_new", "nulls": "create_function_nulls_n3", "replace": "create_function_replace_none", "security": "create_function_security_s2", "volatility": "create_function_volatility_v1"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE STRICT AUTHID CURRENT_USER COST 1 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_943833fc4cd4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n2", "replace": "create_function_replace_yes", "security": "create_function_security_s1", "volatility": "create_function_volatility_v2"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE OR REPLACE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL STABLE RETURNS NULL ON NULL INPUT EXTERNAL SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_656d221d7ac1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_explicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n1", "replace": "create_function_replace_none", "security": "create_function_security_s2", "volatility": "create_function_volatility_v3"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 IN INTEGER, num2 IN INTEGER) RETURNS INTEGER LANGUAGE SQL VOLATILE CALLED ON NULL INPUT AUTHID CURRENT_USER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_f62effac404b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_explicit", "cost": "create_function_cost_c2", "name": "create_function_name_new", "nulls": "create_function_nulls_n0", "replace": "create_function_replace_yes", "security": "create_function_security_s1", "volatility": "create_function_volatility_v0"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE OR REPLACE FUNCTION fp_cf_add (num1 IN INTEGER, num2 IN INTEGER) RETURNS INTEGER LANGUAGE SQL EXTERNAL SECURITY INVOKER COST 10 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_0a9060a53631
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c1", "name": "create_function_name_new", "nulls": "create_function_nulls_n1", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v2"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL STABLE CALLED ON NULL INPUT SECURITY INVOKER COST 1 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_1513c4a55ee2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c1", "name": "create_function_name_new", "nulls": "create_function_nulls_n0", "replace": "create_function_replace_none", "security": "create_function_security_s1", "volatility": "create_function_volatility_v3"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL VOLATILE EXTERNAL SECURITY INVOKER COST 1 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_794e0347e5ea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_explicit", "cost": "create_function_cost_c1", "name": "create_function_name_new", "nulls": "create_function_nulls_n2", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v0"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 IN INTEGER, num2 IN INTEGER) RETURNS INTEGER LANGUAGE SQL RETURNS NULL ON NULL INPUT SECURITY INVOKER COST 1 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_8ac4b3a95f91
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_explicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n3", "replace": "create_function_replace_yes", "security": "create_function_security_s2", "volatility": "create_function_volatility_v0"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE OR REPLACE FUNCTION fp_cf_add (num1 IN INTEGER, num2 IN INTEGER) RETURNS INTEGER LANGUAGE SQL STRICT AUTHID CURRENT_USER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_c0800cbdebca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n0", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v1"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_caaf6d1fe9c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c2", "name": "create_function_name_new", "nulls": "create_function_nulls_n1", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v0"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL CALLED ON NULL INPUT SECURITY INVOKER COST 10 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_c70605e5958e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c2", "name": "create_function_name_new", "nulls": "create_function_nulls_n0", "replace": "create_function_replace_none", "security": "create_function_security_s2", "volatility": "create_function_volatility_v1"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AUTHID CURRENT_USER COST 10 AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_65d26a9c67f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n3", "replace": "create_function_replace_none", "security": "create_function_security_s1", "volatility": "create_function_volatility_v2"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL STABLE STRICT EXTERNAL SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_69e6140efa98
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n2", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v1"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_05b6b6230a2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n0", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v2"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL STABLE SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_function_sql_options_1598853fe04f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_new", "nulls": "create_function_nulls_n2", "replace": "create_function_replace_none", "security": "create_function_security_s0", "volatility": "create_function_volatility_v3"}
-- fixture_setup:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
-- test_sql:
CREATE FUNCTION fp_cf_add (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL VOLATILE RETURNS NULL ON NULL INPUT SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_add(INTEGER, INTEGER) CASCADE;
