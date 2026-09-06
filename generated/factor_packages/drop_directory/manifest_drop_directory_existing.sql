-- generated_from: manifest_drop_directory_existing
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_directory_existing_d202312649e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_directory_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_directory_fact_on_privilege"], "key": "directory_drop_authorized"}, {"allowed_values": ["false"], "fact_refs": ["drop_directory_fact_no_pdb"], "key": "pdb_context"}, {"allowed_values": ["true"], "fact_refs": ["create_directory::create_directory_fact_privilege"], "key": "directory_creator_authorized"}, {"allowed_values": ["/tmp/gaussdb_b7_directory"], "fact_refs": ["create_directory::create_directory_fact_security"], "key": "approved_isolated_directory_path"}]
-- fixture_setup:
BEGIN;
CREATE DIRECTORY dir_b7 AS '/tmp/gaussdb_b7_directory';
-- test_sql:
DROP DIRECTORY dir_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_directory_existing_3ff410c6977a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_directory_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_directory_fact_on_privilege"], "key": "directory_drop_authorized"}, {"allowed_values": ["false"], "fact_refs": ["drop_directory_fact_no_pdb"], "key": "pdb_context"}, {"allowed_values": ["true"], "fact_refs": ["create_directory::create_directory_fact_privilege"], "key": "directory_creator_authorized"}, {"allowed_values": ["/tmp/gaussdb_b7_directory"], "fact_refs": ["create_directory::create_directory_fact_security"], "key": "approved_isolated_directory_path"}]
-- fixture_setup:
BEGIN;
CREATE DIRECTORY dir_b7 AS '/tmp/gaussdb_b7_directory';
-- test_sql:
DROP DIRECTORY IF EXISTS dir_b7;
-- fixture_teardown:
ROLLBACK;
