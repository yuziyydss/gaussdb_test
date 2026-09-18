-- generated_from: manifest_comment_tsc
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_tsc_bbe95c479131
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_configuration_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_configuration_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_configuration"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsc_ns;
CREATE TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple (PARSER=default);
-- test_sql:
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple IS 'factor note';
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsc_ns RESTRICT;

-- case_id: manifest_comment_tsc_a68c75853702
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_configuration_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_configuration_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_configuration"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsc_ns;
CREATE TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple (PARSER=default);
-- test_sql:
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple IS '测试注释';
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsc_ns RESTRICT;

-- case_id: manifest_comment_tsc_b4c2cd1a181f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_configuration_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_configuration_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_configuration"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsc_ns;
CREATE TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple (PARSER=default);
-- test_sql:
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple IS 'owner''s note';
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsc_ns RESTRICT;

-- case_id: manifest_comment_tsc_1bc88f125e94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_configuration_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_configuration_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_configuration"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsc_ns;
CREATE TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple (PARSER=default);
-- test_sql:
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple IS NULL;
-- fixture_teardown:
DROP TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsc_ns RESTRICT;
