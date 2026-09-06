-- generated_from: manifest_create_user_mapping_non_secret
-- static_only: true
-- case_count: 6

-- case_id: manifest_create_user_mapping_non_secret_313da55e6a2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "create_user_mapping_mapped_user_user", "options": "create_user_mapping_options_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
-- test_sql:
CREATE USER MAPPING FOR USER SERVER srv_map_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_user_mapping_non_secret_963f012b2047
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "create_user_mapping_mapped_user_user", "options": "create_user_mapping_options_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
-- test_sql:
CREATE USER MAPPING FOR USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_user_mapping_non_secret_27d64e49597b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "create_user_mapping_mapped_user_current", "options": "create_user_mapping_options_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
-- test_sql:
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_user_mapping_non_secret_0fbc66386cfe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "create_user_mapping_mapped_user_current", "options": "create_user_mapping_options_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
-- test_sql:
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_user_mapping_non_secret_f6e0aea44f4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "create_user_mapping_mapped_user_public", "options": "create_user_mapping_options_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
-- test_sql:
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_user_mapping_non_secret_54dd12894ac3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "create_user_mapping_mapped_user_public", "options": "create_user_mapping_options_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
-- test_sql:
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- fixture_teardown:
ROLLBACK;
