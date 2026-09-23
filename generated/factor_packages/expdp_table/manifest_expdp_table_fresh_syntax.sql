-- generated_from: manifest_expdp_table_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_expdp_table_fresh_syntax_8d0297d88644
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "expdp_table_directory_path", "table_name": "expdp_table_table_name_dedicated"}
-- test_sql:
EXPDP TABLE g_expdp_table LOCATION = '/tmp/gaussdb_static_export';
