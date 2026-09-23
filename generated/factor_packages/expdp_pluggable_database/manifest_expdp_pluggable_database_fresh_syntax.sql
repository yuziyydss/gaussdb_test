-- generated_from: manifest_expdp_pluggable_database_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_expdp_pluggable_database_fresh_syntax_e988a5724a48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "expdp_pluggable_database_directory_path"}
-- test_sql:
EXPDP PLUGGABLE DATABASE LOCATION = '/tmp/gaussdb_static_pdb_export';
