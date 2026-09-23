-- generated_from: manifest_impdp_pluggable_database_create_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_impdp_pluggable_database_create_fresh_syntax_2e5351976a7d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory": "impdp_pluggable_database_create_directory_dedicated", "owner": "impdp_pluggable_database_create_owner_dedicated", "pdb_name": "impdp_pluggable_database_create_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["authoritative"], "fact_refs": ["impdp_pluggable_database_create_fact_tool_only"], "key": "backup_tool_context"}]
-- test_sql:
IMPDP PLUGGABLE DATABASE b8_import_pdb CREATE SOURCE = '/tmp/gaussdb_b8/export_pdb' OWNER = b8_import_owner;
