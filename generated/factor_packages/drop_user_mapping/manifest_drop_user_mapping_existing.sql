-- generated_from: manifest_drop_user_mapping_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_user_mapping_existing_2d3154abb526
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_user_mapping_if_exists_no", "mapped_user": "drop_user_mapping_mapped_user_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping::create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
DROP USER MAPPING FOR USER SERVER srv_map_b7;
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_drop_user_mapping_existing_a107b3d000b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_user_mapping_if_exists_yes", "mapped_user": "drop_user_mapping_mapped_user_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping::create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
DROP USER MAPPING IF EXISTS FOR USER SERVER srv_map_b7;
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_drop_user_mapping_existing_4e875d00a395
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_user_mapping_if_exists_no", "mapped_user": "drop_user_mapping_mapped_user_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping::create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
DROP USER MAPPING FOR CURRENT_USER SERVER srv_map_b7;
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_drop_user_mapping_existing_63147e2d2c82
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_user_mapping_if_exists_yes", "mapped_user": "drop_user_mapping_mapped_user_current"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping::create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_drop_user_mapping_existing_e20651b3cd8e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_user_mapping_if_exists_no", "mapped_user": "drop_user_mapping_mapped_user_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping::create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
DROP USER MAPPING FOR PUBLIC SERVER srv_map_b7;
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_drop_user_mapping_existing_fd163546d7db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_user_mapping_if_exists_yes", "mapped_user": "drop_user_mapping_mapped_user_public"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_user_mapping::create_user_mapping_fact_server_owner"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;
