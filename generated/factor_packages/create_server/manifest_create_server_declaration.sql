-- generated_from: manifest_create_server_declaration
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_server_declaration_732c477ed894
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"fdw": "create_server_fdw_dist"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SERVER srv_b7_new_732c477e FOREIGN DATA WRAPPER dist_fdw;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_server_declaration_ccdf6ddd0dc5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"fdw": "create_server_fdw_log"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SERVER srv_b7_new_ccdf6ddd FOREIGN DATA WRAPPER log_fdw;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_server_declaration_3c01998aa68f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"fdw": "create_server_fdw_file"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SERVER srv_b7_new_3c01998a FOREIGN DATA WRAPPER file_fdw;
-- fixture_teardown:
ROLLBACK;
