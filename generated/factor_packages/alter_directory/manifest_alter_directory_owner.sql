-- generated_from: manifest_alter_directory_owner
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_directory_owner_145bb7b13c40
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"new_owner": "alter_directory_new_owner_isolated"}
-- environment_requirements: [{"allowed_values": ["b7_directory_owner"], "fact_refs": ["alter_directory_fact_privilege"], "key": "directory_owner_member_ready"}, {"allowed_values": ["false"], "fact_refs": ["alter_directory_fact_no_pdb"], "key": "pdb_context"}, {"allowed_values": ["true"], "fact_refs": ["create_directory::create_directory_fact_privilege"], "key": "directory_creator_authorized"}, {"allowed_values": ["/tmp/gaussdb_b7_directory"], "fact_refs": ["create_directory::create_directory_fact_security"], "key": "approved_isolated_directory_path"}]
-- fixture_setup:
BEGIN;
CREATE DIRECTORY dir_b7 AS '/tmp/gaussdb_b7_directory';
CREATE ROLE b7_directory_owner NOLOGIN PASSWORD DISABLE;
GRANT b7_directory_owner TO CURRENT_USER;
-- test_sql:
ALTER DIRECTORY dir_b7 OWNER TO b7_directory_owner;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
