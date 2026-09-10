-- generated_from: manifest_create_foreign_table_log_catalog
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_foreign_table_log_catalog_a44c69844e51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_definitions": "create_foreign_table_log_catalog_column", "format": "create_foreign_table_format_not_applicable", "if_not_exists": "create_foreign_table_if_not_exists_log_fresh", "server_name": "create_foreign_table_log_catalog_server", "table_name": "create_foreign_table_log_catalog_target", "table_options": "create_foreign_table_log_catalog_options"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table_fact_pdb_admin"], "key": "database_scope"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_log_ns;
-- test_sql:
CREATE FOREIGN TABLE g_a3_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
-- fixture_teardown:
DROP FOREIGN TABLE g_a3_log_ns.foreign_table RESTRICT;
DROP SCHEMA g_a3_log_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;
