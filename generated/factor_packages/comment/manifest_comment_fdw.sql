-- generated_from: manifest_comment_fdw
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_fdw_e3ae6e418aff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_fdw_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_wrapper_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_fdw"}]
-- fixture_setup:
CREATE FOREIGN DATA WRAPPER g_comment_fdw NO HANDLER NO VALIDATOR;
-- test_sql:
COMMENT ON FOREIGN DATA WRAPPER g_comment_fdw IS 'factor note';
-- fixture_teardown:
DROP FOREIGN DATA WRAPPER g_comment_fdw RESTRICT;

-- case_id: manifest_comment_fdw_774cf92b8af0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_fdw_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_wrapper_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_fdw"}]
-- fixture_setup:
CREATE FOREIGN DATA WRAPPER g_comment_fdw NO HANDLER NO VALIDATOR;
-- test_sql:
COMMENT ON FOREIGN DATA WRAPPER g_comment_fdw IS '测试注释';
-- fixture_teardown:
DROP FOREIGN DATA WRAPPER g_comment_fdw RESTRICT;

-- case_id: manifest_comment_fdw_049696bf72d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_fdw_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_wrapper_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_fdw"}]
-- fixture_setup:
CREATE FOREIGN DATA WRAPPER g_comment_fdw NO HANDLER NO VALIDATOR;
-- test_sql:
COMMENT ON FOREIGN DATA WRAPPER g_comment_fdw IS 'owner''s note';
-- fixture_teardown:
DROP FOREIGN DATA WRAPPER g_comment_fdw RESTRICT;

-- case_id: manifest_comment_fdw_f8854729a83e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_fdw_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_create_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_wrapper_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_fdw"}]
-- fixture_setup:
CREATE FOREIGN DATA WRAPPER g_comment_fdw NO HANDLER NO VALIDATOR;
-- test_sql:
COMMENT ON FOREIGN DATA WRAPPER g_comment_fdw IS NULL;
-- fixture_teardown:
DROP FOREIGN DATA WRAPPER g_comment_fdw RESTRICT;
