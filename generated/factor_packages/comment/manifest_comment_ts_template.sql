-- generated_from: manifest_comment_ts_template
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_ts_template_e652e6cd231f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_template_builtin", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS 'factor note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_ts_template_397ff6f59b62
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_template_builtin", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS '测试注释';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_ts_template_f5aa4d0fd51a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_template_builtin", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS 'owner''s note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_ts_template_42afb9ab7b69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_template_builtin", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_dictionary::create_text_search_dictionary_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS NULL;
-- fixture_teardown:
ROLLBACK;
