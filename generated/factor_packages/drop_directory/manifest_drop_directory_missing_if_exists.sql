-- generated_from: manifest_drop_directory_missing_if_exists
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_directory_missing_if_exists_ea1d30f84afe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"directory_name": "drop_directory_directory_name_missing", "if_exists": "drop_directory_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_directory_fact_on_privilege"], "key": "directory_drop_authorized"}, {"allowed_values": ["false"], "fact_refs": ["drop_directory_fact_no_pdb"], "key": "pdb_context"}]
-- test_sql:
DROP DIRECTORY IF EXISTS dir_b7_missing;
