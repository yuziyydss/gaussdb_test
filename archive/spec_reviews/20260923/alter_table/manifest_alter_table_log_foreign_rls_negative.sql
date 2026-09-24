-- generated_from: manifest_alter_table_log_foreign_rls_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_table_log_foreign_rls_negative_2d15861416d5
-- expected: error
-- expected_error_category: unsupported_rls_target
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action_profile": "at_action_enable_rls", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_log_foreign_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["log_fdw_catalog"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}, {"allowed_values": ["non_pdb"], "fact_refs": ["create_foreign_table::create_foreign_table_fact_pdb_admin"], "key": "database_scope"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}]
-- fixture_setup:
CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_a3_at_log_ns;
CREATE FOREIGN TABLE g_a3_at_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');
-- test_sql:
ALTER TABLE g_a3_at_log_ns.foreign_table ENABLE ROW LEVEL SECURITY;
-- fixture_teardown:
DROP FOREIGN TABLE g_a3_at_log_ns.foreign_table RESTRICT;
DROP SCHEMA g_a3_at_log_ns RESTRICT;
DROP SERVER g_a3_log_server RESTRICT;
