-- generated_from: manifest_create_directory_new
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_directory_new_89511eb2536d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"replace": "create_directory_replace_new"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_directory_fact_privilege"], "key": "directory_creator_authorized"}, {"allowed_values": ["false"], "fact_refs": ["create_directory_fact_no_pdb"], "key": "pdb_context"}, {"allowed_values": ["/tmp/gaussdb_b7_directory"], "fact_refs": ["create_directory_fact_security"], "key": "approved_isolated_directory_path"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE DIRECTORY dir_b7 AS '/tmp/gaussdb_b7_directory';
-- fixture_teardown:
ROLLBACK;
