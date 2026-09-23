-- generated_from: manifest_impdp_recover_fresh_syntax
-- static_only: true
-- case_count: 2

-- case_id: manifest_impdp_recover_fresh_syntax_bffe0b9ade51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "impdp_recover_directory_path", "local": "impdp_recover_local_new_cluster", "owner": "impdp_recover_owner_dedicated"}
-- test_sql:
IMPDP DATABASE RECOVER SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner;

-- case_id: manifest_impdp_recover_fresh_syntax_423f9822943d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "impdp_recover_directory_path", "local": "impdp_recover_local_same_cluster", "owner": "impdp_recover_owner_dedicated"}
-- test_sql:
IMPDP DATABASE RECOVER SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner LOCAL;
