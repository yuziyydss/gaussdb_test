-- generated_from: manifest_comment_tablespace
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_tablespace_16725fa3bc85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_tablespace_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_tablespace::create_tablespace_fact_body_8"], "key": "tablespace_create_privilege"}, {"allowed_values": ["actual_case_tablespace_owner"], "fact_refs": ["drop_tablespace::drop_tablespace_fact_body_8"], "key": "tablespace_drop_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
CREATE TABLESPACE g_comment_tbspc RELATIVE LOCATION 'g_comment_tbspc';
-- test_sql:
COMMENT ON TABLESPACE g_comment_tbspc IS 'factor note';
-- fixture_teardown:
DROP TABLESPACE g_comment_tbspc;

-- case_id: manifest_comment_tablespace_0cbb1dc0e118
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_tablespace_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_tablespace::create_tablespace_fact_body_8"], "key": "tablespace_create_privilege"}, {"allowed_values": ["actual_case_tablespace_owner"], "fact_refs": ["drop_tablespace::drop_tablespace_fact_body_8"], "key": "tablespace_drop_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
CREATE TABLESPACE g_comment_tbspc RELATIVE LOCATION 'g_comment_tbspc';
-- test_sql:
COMMENT ON TABLESPACE g_comment_tbspc IS '测试注释';
-- fixture_teardown:
DROP TABLESPACE g_comment_tbspc;

-- case_id: manifest_comment_tablespace_c535146e227b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_tablespace_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_tablespace::create_tablespace_fact_body_8"], "key": "tablespace_create_privilege"}, {"allowed_values": ["actual_case_tablespace_owner"], "fact_refs": ["drop_tablespace::drop_tablespace_fact_body_8"], "key": "tablespace_drop_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
CREATE TABLESPACE g_comment_tbspc RELATIVE LOCATION 'g_comment_tbspc';
-- test_sql:
COMMENT ON TABLESPACE g_comment_tbspc IS 'owner''s note';
-- fixture_teardown:
DROP TABLESPACE g_comment_tbspc;

-- case_id: manifest_comment_tablespace_f436d84f5235
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_tablespace_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_tablespace::create_tablespace_fact_body_8"], "key": "tablespace_create_privilege"}, {"allowed_values": ["actual_case_tablespace_owner"], "fact_refs": ["drop_tablespace::drop_tablespace_fact_body_8"], "key": "tablespace_drop_privilege"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
CREATE TABLESPACE g_comment_tbspc RELATIVE LOCATION 'g_comment_tbspc';
-- test_sql:
COMMENT ON TABLESPACE g_comment_tbspc IS NULL;
-- fixture_teardown:
DROP TABLESPACE g_comment_tbspc;
