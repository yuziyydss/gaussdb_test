-- generated_from: manifest_impdp_table_prepare_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_impdp_table_prepare_fresh_syntax_45f8e5f90814
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "impdp_table_prepare_directory_path", "owner": "impdp_table_prepare_owner_dedicated"}
-- test_sql:
IMPDP TABLE PREPARE SOURCE = '/tmp/gaussdb_static_import' OWNER = g_impdp_owner;
