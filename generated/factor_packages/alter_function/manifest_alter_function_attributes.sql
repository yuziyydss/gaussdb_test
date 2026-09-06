-- generated_from: manifest_alter_function_attributes
-- static_only: true
-- case_count: 34

-- case_id: manifest_alter_function_attributes_6d4318c69d54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a0", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) CALLED ON NULL INPUT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_3e7cce2fbc08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a1", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) RETURNS NULL ON NULL INPUT RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_2b8f85494835
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a2", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) STRICT RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_cd11419f7261
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a3", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) IMMUTABLE;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_33aa6073b929
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a4", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) STABLE;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_983189969f32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a5", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) VOLATILE;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_47e0d498b855
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a6", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) SECURITY INVOKER;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_432360b9b7a3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a7", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) EXTERNAL SECURITY INVOKER;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_d3a8ddd257b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a8", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) AUTHID CURRENT_USER;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_5d8f56ed3b1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a9", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) COST 1;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_74848da81c77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a10", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) COST 10;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_fc3b74326684
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a11", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) SET work_mem TO '4MB';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_5728891f7be3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a12", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) SET work_mem = '4MB';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_9d394a60e81c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a13", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) SET work_mem FROM CURRENT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_b9dd35a229a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a14", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) RESET work_mem;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_b72ca8e69e04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a15", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) RESET ALL;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_e7dbd080f732
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a16", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) IMMUTABLE STRICT COST 1;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_fecc804b65a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a1", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) RETURNS NULL ON NULL INPUT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_4889c74e8745
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a3", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_types"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) IMMUTABLE RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_9f9bc5c18de9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a0", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) CALLED ON NULL INPUT RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_946dd7076992
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a2", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) STRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_cdc52fddc2a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a4", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) STABLE RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_4ce68fb0f2ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a5", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) VOLATILE RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_5cef26a10ee6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a6", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) SECURITY INVOKER RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_58f986d49e5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a7", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) EXTERNAL SECURITY INVOKER RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_9c459aa9410e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a8", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) AUTHID CURRENT_USER RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_d1bfed4ba2cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a9", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) COST 1 RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_cf1d8f83e38b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a10", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) COST 10 RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_705f9715ed41
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a11", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) SET work_mem TO '4MB' RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_df4de1d483fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a12", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) SET work_mem = '4MB' RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_7d055196aa66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a13", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) SET work_mem FROM CURRENT RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_60e6e8fb0776
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a14", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) RESET work_mem RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_1022f5ab40c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a15", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) RESET ALL RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_attributes_6c9f46db73ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a16", "form": "alter_function_form_attributes", "name": "alter_function_name_base", "restrict": "alter_function_restrict_yes", "signature": "alter_function_signature_named"}
-- environment_requirements: [{"allowed_values": ["permitted"], "fact_refs": ["alter_function_fact_danger_guc"], "key": "function_attribute_changes"}]
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) IMMUTABLE STRICT COST 1 RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
