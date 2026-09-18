-- generated_from: manifest_comment_cast
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_cast_fcf0a4589344
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_cast_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["comment_fact_authority"], "key": "cast_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["true"], "fact_refs": ["drop_cast::drop_cast_fact_permission"], "key": "cleanup_cast"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_cast_ns;
CREATE FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision) RETURNS timestamp with time zone LANGUAGE SQL STRICT AS 'SELECT to_timestamp($1);';
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
-- test_sql:
COMMENT ON CAST (double precision AS timestamp with time zone) IS 'factor note';
-- fixture_teardown:
DROP CAST (double precision AS timestamp with time zone) RESTRICT;
DROP FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
DROP SCHEMA g_comment_cast_ns RESTRICT;

-- case_id: manifest_comment_cast_53cca789342b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_cast_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["comment_fact_authority"], "key": "cast_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["true"], "fact_refs": ["drop_cast::drop_cast_fact_permission"], "key": "cleanup_cast"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_cast_ns;
CREATE FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision) RETURNS timestamp with time zone LANGUAGE SQL STRICT AS 'SELECT to_timestamp($1);';
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
-- test_sql:
COMMENT ON CAST (double precision AS timestamp with time zone) IS '测试注释';
-- fixture_teardown:
DROP CAST (double precision AS timestamp with time zone) RESTRICT;
DROP FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
DROP SCHEMA g_comment_cast_ns RESTRICT;

-- case_id: manifest_comment_cast_6c76bc6ed27e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_cast_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["comment_fact_authority"], "key": "cast_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["true"], "fact_refs": ["drop_cast::drop_cast_fact_permission"], "key": "cleanup_cast"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_cast_ns;
CREATE FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision) RETURNS timestamp with time zone LANGUAGE SQL STRICT AS 'SELECT to_timestamp($1);';
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
-- test_sql:
COMMENT ON CAST (double precision AS timestamp with time zone) IS 'owner''s note';
-- fixture_teardown:
DROP CAST (double precision AS timestamp with time zone) RESTRICT;
DROP FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
DROP SCHEMA g_comment_cast_ns RESTRICT;

-- case_id: manifest_comment_cast_15298606bc95
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_cast_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["comment_fact_authority"], "key": "cast_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["true"], "fact_refs": ["drop_cast::drop_cast_fact_permission"], "key": "cleanup_cast"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_cast_ns;
CREATE FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision) RETURNS timestamp with time zone LANGUAGE SQL STRICT AS 'SELECT to_timestamp($1);';
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
-- test_sql:
COMMENT ON CAST (double precision AS timestamp with time zone) IS NULL;
-- fixture_teardown:
DROP CAST (double precision AS timestamp with time zone) RESTRICT;
DROP FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
DROP SCHEMA g_comment_cast_ns RESTRICT;
