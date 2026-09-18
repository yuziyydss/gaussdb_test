-- generated_from: manifest_comment_ts_dictionary
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_ts_dictionary_585efafb2dc6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_dictionary_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_dictionary_owner"], "fact_refs": ["drop_text_search_dictionary::drop_text_search_dictionary_fact_owner"], "key": "cleanup_dictionary"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsd_ns;
CREATE TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple (TEMPLATE=simple, ACCEPT=false);
-- test_sql:
COMMENT ON TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple IS 'factor note';
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsd_ns RESTRICT;

-- case_id: manifest_comment_ts_dictionary_d925d3f764a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_dictionary_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_dictionary_owner"], "fact_refs": ["drop_text_search_dictionary::drop_text_search_dictionary_fact_owner"], "key": "cleanup_dictionary"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsd_ns;
CREATE TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple (TEMPLATE=simple, ACCEPT=false);
-- test_sql:
COMMENT ON TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple IS '测试注释';
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsd_ns RESTRICT;

-- case_id: manifest_comment_ts_dictionary_1787fa462b31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_dictionary_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_dictionary_owner"], "fact_refs": ["drop_text_search_dictionary::drop_text_search_dictionary_fact_owner"], "key": "cleanup_dictionary"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsd_ns;
CREATE TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple (TEMPLATE=simple, ACCEPT=false);
-- test_sql:
COMMENT ON TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple IS 'owner''s note';
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsd_ns RESTRICT;

-- case_id: manifest_comment_ts_dictionary_cc522fd301d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_dictionary_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["approved"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_testing"}, {"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_sysadmin"], "key": "sysadmin"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_dictionary_owner"], "fact_refs": ["drop_text_search_dictionary::drop_text_search_dictionary_fact_owner"], "key": "cleanup_dictionary"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_tsd_ns;
CREATE TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple (TEMPLATE=simple, ACCEPT=false);
-- test_sql:
COMMENT ON TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple IS NULL;
-- fixture_teardown:
DROP TEXT SEARCH DICTIONARY g_comment_tsd_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsd_ns RESTRICT;
