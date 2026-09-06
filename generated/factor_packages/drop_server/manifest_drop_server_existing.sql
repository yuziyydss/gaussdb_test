-- generated_from: manifest_drop_server_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_server_existing_e4cf28e4a6e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_server_behavior_default", "if_exists": "drop_server_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_server_fact_privilege"], "key": "server_drop_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
DROP SERVER srv_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_server_existing_2d8067fd9009
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_server_behavior_restrict", "if_exists": "drop_server_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_server_fact_privilege"], "key": "server_drop_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
DROP SERVER srv_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_server_existing_f65211473e19
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_server_behavior_cascade", "if_exists": "drop_server_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_server_fact_privilege"], "key": "server_drop_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
DROP SERVER srv_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_server_existing_5f1e6eb063a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_server_behavior_default", "if_exists": "drop_server_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_server_fact_privilege"], "key": "server_drop_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
DROP SERVER IF EXISTS srv_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_server_existing_7a902f7d1324
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_server_behavior_restrict", "if_exists": "drop_server_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_server_fact_privilege"], "key": "server_drop_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
DROP SERVER IF EXISTS srv_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_server_existing_deda00812b3f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_server_behavior_cascade", "if_exists": "drop_server_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_server_fact_privilege"], "key": "server_drop_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_b7 FOREIGN DATA WRAPPER file_fdw;
-- test_sql:
DROP SERVER IF EXISTS srv_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;
