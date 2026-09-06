-- generated_from: manifest_alter_server_version
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_server_version_0bb870ed3bfe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_server_form_version", "version": "alter_server_version_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_server_fact_privilege"], "key": "server_alter_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
ALTER SERVER srv_b7 VERSION '1.0';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_server_version_4f5586131a85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_server_form_version", "version": "alter_server_version_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_server_fact_privilege"], "key": "server_alter_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
ALTER SERVER srv_b7 VERSION '2.0';
-- fixture_teardown:
ROLLBACK;
