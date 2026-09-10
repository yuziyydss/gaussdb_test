-- generated_from: manifest_comment_namespace_constraint
-- static_only: true
-- case_count: 8

-- case_id: manifest_comment_namespace_constraint_e8006be5f8f3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_schema_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON SCHEMA g_comment_contract_ns IS 'factor note';
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_33dc866de372
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_schema_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON SCHEMA g_comment_contract_ns IS '测试注释';
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_e30581680e20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_schema_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON SCHEMA g_comment_contract_ns IS 'owner''s note';
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_a304efad6344
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_schema_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON SCHEMA g_comment_contract_ns IS NULL;
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_0cddd6a8d744
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_constraint_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON CONSTRAINT g_comment_pk ON g_comment_contract_ns.base_table IS 'factor note';
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_a39712b67a2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_constraint_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON CONSTRAINT g_comment_pk ON g_comment_contract_ns.base_table IS '测试注释';
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_e37f3a6b6ac1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_constraint_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON CONSTRAINT g_comment_pk ON g_comment_contract_ns.base_table IS 'owner''s note';
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;

-- case_id: manifest_comment_namespace_constraint_b8e66a1c0d42
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_constraint_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_comment_contract_ns;
CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));
-- test_sql:
COMMENT ON CONSTRAINT g_comment_pk ON g_comment_contract_ns.base_table IS NULL;
-- fixture_teardown:
DROP TABLE g_comment_contract_ns.base_table PURGE;
DROP SCHEMA g_comment_contract_ns RESTRICT;
