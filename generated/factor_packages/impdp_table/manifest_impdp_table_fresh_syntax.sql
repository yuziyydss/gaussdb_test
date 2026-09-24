-- generated_from: manifest_impdp_table_fresh_syntax
-- static_only: true
-- case_count: 2

-- case_id: manifest_impdp_table_fresh_syntax_13b89ccfa417
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "impdp_table_directory_path", "owner": "impdp_table_owner_dedicated", "target": "impdp_table_target_keep"}
-- test_sql:
IMPDP TABLE SOURCE = '/tmp/gaussdb_static_import' OWNER = g_impdp_owner;

-- case_id: manifest_impdp_table_fresh_syntax_dfc9075c4e69
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "impdp_table_directory_path", "owner": "impdp_table_owner_dedicated", "target": "impdp_table_target_rename"}
-- test_sql:
IMPDP TABLE AS g_impdp_table SOURCE = '/tmp/gaussdb_static_import' OWNER = g_impdp_owner;
