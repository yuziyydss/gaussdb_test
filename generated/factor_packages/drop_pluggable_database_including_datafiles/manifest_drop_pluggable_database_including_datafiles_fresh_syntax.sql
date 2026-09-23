-- generated_from: manifest_drop_pluggable_database_including_datafiles_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_pluggable_database_including_datafiles_fresh_syntax_43feccd86de4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"pdb_name": "drop_pluggable_database_including_datafiles_pdb_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_pluggable_database_including_datafiles_fact_mtd"], "key": "mtd"}, {"allowed_values": ["non_pdb_non_m"], "fact_refs": ["drop_pluggable_database_including_datafiles_fact_non_pdb_not_m"], "key": "database_scope"}, {"allowed_values": ["pdb_owner_or_sysadmin"], "fact_refs": ["drop_pluggable_database_including_datafiles_fact_privilege"], "key": "drop_pdb_privilege"}]
-- test_sql:
DROP PLUGGABLE DATABASE g_drop_pluggable_database INCLUDING DATAFILES;
