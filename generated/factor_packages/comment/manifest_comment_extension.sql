-- generated_from: manifest_comment_extension
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_extension_201b2a319062
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_extension_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_extension_ns;
CREATE EXTENSION ext_b7 SCHEMA g_comment_extension_ns;
-- test_sql:
COMMENT ON EXTENSION ext_b7 IS 'factor note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_extension_82d41341d30d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_extension_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_extension_ns;
CREATE EXTENSION ext_b7 SCHEMA g_comment_extension_ns;
-- test_sql:
COMMENT ON EXTENSION ext_b7 IS '测试注释';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_extension_23fd3a065bdd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_extension_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_extension_ns;
CREATE EXTENSION ext_b7 SCHEMA g_comment_extension_ns;
-- test_sql:
COMMENT ON EXTENSION ext_b7 IS 'owner''s note';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_comment_extension_ecf2e924f2bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_extension_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA g_comment_extension_ns;
CREATE EXTENSION ext_b7 SCHEMA g_comment_extension_ns;
-- test_sql:
COMMENT ON EXTENSION ext_b7 IS NULL;
-- fixture_teardown:
ROLLBACK;
