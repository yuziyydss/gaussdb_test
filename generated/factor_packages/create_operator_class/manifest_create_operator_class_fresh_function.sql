-- generated_from: manifest_create_operator_class_fresh_function
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_operator_class_fresh_function_d6d3973c5d6f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"class_name": "create_operator_class_class_name_fresh", "data_type": "create_operator_class_data_type_integer", "default_modifier": "create_operator_class_default_modifier_nondefault", "family": "create_operator_class_family_implicit", "members": "create_operator_class_members_fresh_function", "method": "create_operator_class_method_btree_fresh"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_operator_class_fact_internal"], "key": "internal_operator_class_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["create_operator_class_fact_privilege"], "key": "operator_class_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_function::create_function_fact_create_any"], "key": "create_function_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_create_opclass_ns;
CREATE FUNCTION g_create_opclass_ns.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
-- test_sql:
CREATE OPERATOR CLASS g_create_opclass_ns.g_create_opclass FOR TYPE INTEGER USING btree AS FUNCTION 1 g_create_opclass_ns.compare_integer(INTEGER, INTEGER);
-- fixture_teardown:
ROLLBACK;
