-- generated_from: manifest_comment_ts_parser
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_ts_parser_7eda4d506f67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_parser_builtin", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS 'factor note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_ts_parser_4b1a3ca636fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_parser_builtin", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS '测试注释';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_ts_parser_3ca6092e00b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_parser_builtin", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS 'owner''s note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_ts_parser_888176074cc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_text_search_parser_builtin", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_text_search_configuration::create_text_search_configuration_fact_internal"], "key": "internal_text_search_test"}, {"allowed_values": ["sysadmin"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
-- test_sql:
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS NULL;
-- fixture_teardown:
ROLLBACK;
