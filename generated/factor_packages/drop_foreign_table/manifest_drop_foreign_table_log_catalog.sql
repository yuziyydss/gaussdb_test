-- generated_from: manifest_drop_foreign_table_log_catalog
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_foreign_table_log_catalog_8aa95be25426
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_table_restrict_log_fresh", "if_exists": "drop_foreign_table_if_exists_log_fresh", "table_names": "drop_foreign_table_log_catalog_target"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["drop_foreign_table_fact_pdb_admin"], "key": "database_scope"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_log_ns;
CREATE FOREIGN TABLE g_a3_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
-- test_sql:
DROP FOREIGN TABLE g_a3_log_ns.foreign_table RESTRICT;
-- fixture_teardown:
DROP SCHEMA g_a3_log_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;

-- case_id: manifest_drop_foreign_table_log_catalog_9a918cbf333c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_table_behavior_implicit_fresh", "if_exists": "drop_foreign_table_if_exists_yes_log_fresh", "table_names": "drop_foreign_table_log_catalog_target"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["drop_foreign_table_fact_pdb_admin"], "key": "database_scope"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_log_ns;
CREATE FOREIGN TABLE g_a3_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
-- test_sql:
DROP FOREIGN TABLE IF EXISTS g_a3_log_ns.foreign_table;
-- fixture_teardown:
DROP SCHEMA g_a3_log_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;

-- case_id: manifest_drop_foreign_table_log_catalog_87c75b4d512f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_table_behavior_implicit_fresh", "if_exists": "drop_foreign_table_if_exists_log_fresh", "table_names": "drop_foreign_table_log_catalog_target"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["drop_foreign_table_fact_pdb_admin"], "key": "database_scope"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_log_ns;
CREATE FOREIGN TABLE g_a3_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
-- test_sql:
DROP FOREIGN TABLE g_a3_log_ns.foreign_table;
-- fixture_teardown:
DROP SCHEMA g_a3_log_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;

-- case_id: manifest_drop_foreign_table_log_catalog_f4b8cc177944
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_table_restrict_log_fresh", "if_exists": "drop_foreign_table_if_exists_yes_log_fresh", "table_names": "drop_foreign_table_log_catalog_target"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["drop_foreign_table_fact_pdb_admin"], "key": "database_scope"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_log_ns;
CREATE FOREIGN TABLE g_a3_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
-- test_sql:
DROP FOREIGN TABLE IF EXISTS g_a3_log_ns.foreign_table RESTRICT;
-- fixture_teardown:
DROP SCHEMA g_a3_log_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;
