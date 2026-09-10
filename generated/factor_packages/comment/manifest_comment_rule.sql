-- generated_from: manifest_comment_rule
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_rule_37f9bedec8ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_rule_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["actual_case_table_owner"], "fact_refs": ["create_rule::create_rule_fact_owner"], "key": "rule_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_rule_ns;
CREATE TABLE g_comment_rule_ns.base_table (id INTEGER, qty INTEGER);
CREATE RULE ignore_insert AS ON INSERT TO g_comment_rule_ns.base_table DO INSTEAD NOTHING;
-- test_sql:
COMMENT ON RULE ignore_insert ON g_comment_rule_ns.base_table IS 'factor note';
-- fixture_teardown:
DROP RULE ignore_insert ON g_comment_rule_ns.base_table RESTRICT;
DROP TABLE g_comment_rule_ns.base_table PURGE;
DROP SCHEMA g_comment_rule_ns RESTRICT;

-- case_id: manifest_comment_rule_8ee9b2fe1f60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_rule_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["actual_case_table_owner"], "fact_refs": ["create_rule::create_rule_fact_owner"], "key": "rule_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_rule_ns;
CREATE TABLE g_comment_rule_ns.base_table (id INTEGER, qty INTEGER);
CREATE RULE ignore_insert AS ON INSERT TO g_comment_rule_ns.base_table DO INSTEAD NOTHING;
-- test_sql:
COMMENT ON RULE ignore_insert ON g_comment_rule_ns.base_table IS '测试注释';
-- fixture_teardown:
DROP RULE ignore_insert ON g_comment_rule_ns.base_table RESTRICT;
DROP TABLE g_comment_rule_ns.base_table PURGE;
DROP SCHEMA g_comment_rule_ns RESTRICT;

-- case_id: manifest_comment_rule_5b063c63f438
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_rule_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["actual_case_table_owner"], "fact_refs": ["create_rule::create_rule_fact_owner"], "key": "rule_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_rule_ns;
CREATE TABLE g_comment_rule_ns.base_table (id INTEGER, qty INTEGER);
CREATE RULE ignore_insert AS ON INSERT TO g_comment_rule_ns.base_table DO INSTEAD NOTHING;
-- test_sql:
COMMENT ON RULE ignore_insert ON g_comment_rule_ns.base_table IS 'owner''s note';
-- fixture_teardown:
DROP RULE ignore_insert ON g_comment_rule_ns.base_table RESTRICT;
DROP TABLE g_comment_rule_ns.base_table PURGE;
DROP SCHEMA g_comment_rule_ns RESTRICT;

-- case_id: manifest_comment_rule_2c84c4430f33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_rule_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["actual_case_table_owner"], "fact_refs": ["create_rule::create_rule_fact_owner"], "key": "rule_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_rule_ns;
CREATE TABLE g_comment_rule_ns.base_table (id INTEGER, qty INTEGER);
CREATE RULE ignore_insert AS ON INSERT TO g_comment_rule_ns.base_table DO INSTEAD NOTHING;
-- test_sql:
COMMENT ON RULE ignore_insert ON g_comment_rule_ns.base_table IS NULL;
-- fixture_teardown:
DROP RULE ignore_insert ON g_comment_rule_ns.base_table RESTRICT;
DROP TABLE g_comment_rule_ns.base_table PURGE;
DROP SCHEMA g_comment_rule_ns RESTRICT;
