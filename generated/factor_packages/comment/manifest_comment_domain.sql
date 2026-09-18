-- generated_from: manifest_comment_domain
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_domain_b9a9a2802d9b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_domain_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_domain_ns;
CREATE DOMAIN g_comment_domain_ns.positive_integer AS INTEGER CHECK (VALUE > 0);
-- test_sql:
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS 'factor note';
-- fixture_teardown:
DROP DOMAIN g_comment_domain_ns.positive_integer RESTRICT;
DROP SCHEMA g_comment_domain_ns RESTRICT;

-- case_id: manifest_comment_domain_a611d24dc7b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_domain_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_domain_ns;
CREATE DOMAIN g_comment_domain_ns.positive_integer AS INTEGER CHECK (VALUE > 0);
-- test_sql:
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS '测试注释';
-- fixture_teardown:
DROP DOMAIN g_comment_domain_ns.positive_integer RESTRICT;
DROP SCHEMA g_comment_domain_ns RESTRICT;

-- case_id: manifest_comment_domain_f9e04ee54346
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_domain_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_domain_ns;
CREATE DOMAIN g_comment_domain_ns.positive_integer AS INTEGER CHECK (VALUE > 0);
-- test_sql:
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS 'owner''s note';
-- fixture_teardown:
DROP DOMAIN g_comment_domain_ns.positive_integer RESTRICT;
DROP SCHEMA g_comment_domain_ns RESTRICT;

-- case_id: manifest_comment_domain_8dc06ad2b6aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_domain_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_domain_ns;
CREATE DOMAIN g_comment_domain_ns.positive_integer AS INTEGER CHECK (VALUE > 0);
-- test_sql:
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS NULL;
-- fixture_teardown:
DROP DOMAIN g_comment_domain_ns.positive_integer RESTRICT;
DROP SCHEMA g_comment_domain_ns RESTRICT;
