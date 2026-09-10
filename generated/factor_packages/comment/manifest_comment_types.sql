-- generated_from: manifest_comment_types
-- static_only: true
-- case_count: 8

-- case_id: manifest_comment_types_931a916ba93e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_enum_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.status_enum IS 'factor note';
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_618ff6756080
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_enum_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.status_enum IS '测试注释';
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_f0432e341766
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_enum_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.status_enum IS 'owner''s note';
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_16582d3e818b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_enum_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.status_enum IS NULL;
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_775038d405cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_composite_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.point_pair IS 'factor note';
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_a04159fd72ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_composite_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.point_pair IS '测试注释';
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_cde86b559dc8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_composite_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.point_pair IS 'owner''s note';
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;

-- case_id: manifest_comment_types_f8ef057a7c31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_composite_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_type_in_fresh_user_schema"], "fact_refs": ["create_type::create_type_fact_any_type"], "key": "type_create_authority"}, {"allowed_values": ["usage_on_builtin_integer_attributes"], "fact_refs": ["create_type::create_type_fact_composite_usage"], "key": "attribute_type_usage"}, {"allowed_values": ["actual_case_type_owner"], "fact_refs": ["drop_type::drop_type_fact_privilege"], "key": "cleanup_types"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_type_ns;
CREATE TYPE g_comment_type_ns.status_enum AS ENUM ('open','closed');
CREATE TYPE g_comment_type_ns.point_pair AS (x INTEGER, y INTEGER);
-- test_sql:
COMMENT ON TYPE g_comment_type_ns.point_pair IS NULL;
-- fixture_teardown:
DROP TYPE g_comment_type_ns.point_pair RESTRICT;
DROP TYPE g_comment_type_ns.status_enum RESTRICT;
DROP SCHEMA g_comment_type_ns RESTRICT;
