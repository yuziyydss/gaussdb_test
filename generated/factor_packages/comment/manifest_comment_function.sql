-- generated_from: manifest_comment_function
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_function_09a811a3eb2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_function_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_function::create_function_fact_styles"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_function_in_user_schema"], "fact_refs": ["create_function::create_function_fact_create_any"], "key": "function_create_authority"}, {"allowed_values": ["exclusive_test_database_and_connection_no_other_users"], "fact_refs": ["create_function::create_function_fact_public_execute"], "key": "execution_isolation"}, {"allowed_values": ["actual_case_function_owner"], "fact_refs": ["drop_function::drop_function_fact_authority"], "key": "cleanup_function"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_function_ns;
CREATE FUNCTION g_comment_function_ns.identity_value(input_value INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1;';
-- test_sql:
COMMENT ON FUNCTION g_comment_function_ns.identity_value(INTEGER) IS 'factor note';
-- fixture_teardown:
DROP FUNCTION g_comment_function_ns.identity_value(INTEGER) RESTRICT;
DROP SCHEMA g_comment_function_ns RESTRICT;

-- case_id: manifest_comment_function_8ef0156497ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_function_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_function::create_function_fact_styles"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_function_in_user_schema"], "fact_refs": ["create_function::create_function_fact_create_any"], "key": "function_create_authority"}, {"allowed_values": ["exclusive_test_database_and_connection_no_other_users"], "fact_refs": ["create_function::create_function_fact_public_execute"], "key": "execution_isolation"}, {"allowed_values": ["actual_case_function_owner"], "fact_refs": ["drop_function::drop_function_fact_authority"], "key": "cleanup_function"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_function_ns;
CREATE FUNCTION g_comment_function_ns.identity_value(input_value INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1;';
-- test_sql:
COMMENT ON FUNCTION g_comment_function_ns.identity_value(INTEGER) IS '测试注释';
-- fixture_teardown:
DROP FUNCTION g_comment_function_ns.identity_value(INTEGER) RESTRICT;
DROP SCHEMA g_comment_function_ns RESTRICT;

-- case_id: manifest_comment_function_1e0573196c36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_function_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_function::create_function_fact_styles"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_function_in_user_schema"], "fact_refs": ["create_function::create_function_fact_create_any"], "key": "function_create_authority"}, {"allowed_values": ["exclusive_test_database_and_connection_no_other_users"], "fact_refs": ["create_function::create_function_fact_public_execute"], "key": "execution_isolation"}, {"allowed_values": ["actual_case_function_owner"], "fact_refs": ["drop_function::drop_function_fact_authority"], "key": "cleanup_function"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_function_ns;
CREATE FUNCTION g_comment_function_ns.identity_value(input_value INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1;';
-- test_sql:
COMMENT ON FUNCTION g_comment_function_ns.identity_value(INTEGER) IS 'owner''s note';
-- fixture_teardown:
DROP FUNCTION g_comment_function_ns.identity_value(INTEGER) RESTRICT;
DROP SCHEMA g_comment_function_ns RESTRICT;

-- case_id: manifest_comment_function_335654e04d9d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_function_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_function::create_function_fact_styles"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_function_in_user_schema"], "fact_refs": ["create_function::create_function_fact_create_any"], "key": "function_create_authority"}, {"allowed_values": ["exclusive_test_database_and_connection_no_other_users"], "fact_refs": ["create_function::create_function_fact_public_execute"], "key": "execution_isolation"}, {"allowed_values": ["actual_case_function_owner"], "fact_refs": ["drop_function::drop_function_fact_authority"], "key": "cleanup_function"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_function_ns;
CREATE FUNCTION g_comment_function_ns.identity_value(input_value INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1;';
-- test_sql:
COMMENT ON FUNCTION g_comment_function_ns.identity_value(INTEGER) IS NULL;
-- fixture_teardown:
DROP FUNCTION g_comment_function_ns.identity_value(INTEGER) RESTRICT;
DROP SCHEMA g_comment_function_ns RESTRICT;
