-- generated_from: manifest_comment_fdw_objects
-- static_only: true
-- case_count: 8

-- case_id: manifest_comment_fdw_objects_0f60106d076d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_foreign_table_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON FOREIGN TABLE g_comment_fdw_ns.foreign_table IS 'factor note';
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_244eb9f73fd1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_foreign_table_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON FOREIGN TABLE g_comment_fdw_ns.foreign_table IS '测试注释';
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_4c991285698d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_foreign_table_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON FOREIGN TABLE g_comment_fdw_ns.foreign_table IS 'owner''s note';
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_0676150ec1b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_foreign_table_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON FOREIGN TABLE g_comment_fdw_ns.foreign_table IS NULL;
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_4bf36251e5c4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_server_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON SERVER g_comment_fdw_server IS 'factor note';
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_f8e2c68ac986
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_server_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON SERVER g_comment_fdw_server IS '测试注释';
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_ae2d7d56cdc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_server_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON SERVER g_comment_fdw_server IS 'owner''s note';
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;

-- case_id: manifest_comment_fdw_objects_4fa9822ed4e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_server_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table (col1 TEXT) SERVER g_comment_fdw_server OPTIONS (logtype 'gs_log');
-- test_sql:
COMMENT ON SERVER g_comment_fdw_server IS NULL;
-- fixture_teardown:
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;
