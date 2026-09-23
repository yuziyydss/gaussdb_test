-- generated_from: manifest_expdp_database_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_expdp_database_fresh_syntax_35dfe8ab1a64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"db_name": "expdp_database_db_name_dedicated", "directory": "expdp_database_directory_path"}
-- test_sql:
EXPDP DATABASE g_expdp_database LOCATION = '/tmp/gaussdb_static_export';
