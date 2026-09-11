-- generated_from: manifest_alter_foreign_table_log_set
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_foreign_table_log_set_9cc731fb71e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "aft_log_set", "option_value": "aft_log_five", "table_name": "aft_log_table"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["alter_foreign_table_fact_pdb_admin"], "key": "database_scope"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_aft_ns;
CREATE FOREIGN TABLE g_a3_aft_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
ALTER FOREIGN TABLE g_a3_aft_ns.foreign_table OPTIONS (ADD latest_files '2');
-- test_sql:
ALTER FOREIGN TABLE g_a3_aft_ns.foreign_table OPTIONS (SET latest_files '5');
-- fixture_teardown:
DROP FOREIGN TABLE g_a3_aft_ns.foreign_table RESTRICT;
DROP SCHEMA g_a3_aft_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;
