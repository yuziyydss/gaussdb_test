-- generated_from: manifest_create_foreign_table_file_csv
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_foreign_table_file_csv_57699e5026b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_definitions": "create_foreign_table_file_columns", "format": "create_foreign_table_format_csv_file_fresh", "if_not_exists": "create_foreign_table_if_not_exists_file_fresh", "server_name": "create_foreign_table_file_server", "table_name": "create_foreign_table_file_target", "table_options": "create_foreign_table_file_options_csv"}
-- environment_requirements: [{"allowed_values": ["file_fdw"], "fact_refs": ["create_foreign_table_fact_validator"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}, {"allowed_values": ["deployed_hash_verified_and_allowlisted"], "fact_refs": ["create_foreign_table_fact_filename"], "key": "server_file_access"}]
-- file_assets: [{"cleanup": "remove_only_owned_deployed_file_after_hash_check", "column_count": 2, "deployed": false, "deployment": "manual_copy_and_verify", "deployment_required": true, "fact_refs": ["create_foreign_table_fact_filename"], "fixture_id": "fixture_create_foreign_table_file_csv", "format": "integer_csv", "id": "rows_csv", "repository_source_path": "specs/ddl/create_foreign_table/fixtures/assets/rows.csv", "row_count": 3, "sha256": "ee2cb0fb201933421baec24b0b77f4e871cbd2079038f463745519001a159062", "source_path": "assets/rows.csv", "target_path": "/tmp/factor_assets/general/create_foreign_table/rows.csv"}]
-- File deployment/hash/ownership checks are required BEFORE fixture setup; no deployment has occurred.
-- fixture_setup:
CREATE SERVER g_cft_file_server FOREIGN DATA WRAPPER file_fdw;
CREATE SCHEMA g_cft_file_ns;
-- test_sql:
CREATE FOREIGN TABLE g_cft_file_ns.rows (id INTEGER, qty INTEGER) SERVER g_cft_file_server OPTIONS (format 'csv', filename '/tmp/factor_assets/general/create_foreign_table/rows.csv', encoding 'UTF8', header 'false', delimiter ',', quote '"', escape '"', null '');
-- fixture_teardown:
DROP FOREIGN TABLE g_cft_file_ns.rows RESTRICT;
DROP SCHEMA g_cft_file_ns RESTRICT;
DROP SERVER g_cft_file_server RESTRICT;
