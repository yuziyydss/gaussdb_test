-- generated_from: manifest_alter_server_rename
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_server_rename_be98e02a0695
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_server_form_rename", "version": "alter_server_version_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_server_fact_privilege"], "key": "server_alter_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
ALTER SERVER srv_b7 RENAME TO srv_b7_renamed;
-- fixture_teardown:
ROLLBACK;
