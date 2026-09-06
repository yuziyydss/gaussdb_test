-- generated_from: manifest_alter_user_mapping_non_secret
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_user_mapping_non_secret_3968588899f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "alter_user_mapping_mapped_user_user", "options": "alter_user_mapping_options_set_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_user_mapping_fact_privilege"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
ALTER USER MAPPING FOR USER SERVER srv_map_b7 OPTIONS (SET user 'b7_changed_user');
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_alter_user_mapping_non_secret_ef1ef1487383
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "alter_user_mapping_mapped_user_user", "options": "alter_user_mapping_options_drop_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_user_mapping_fact_privilege"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
ALTER USER MAPPING FOR USER SERVER srv_map_b7 OPTIONS (DROP user);
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_alter_user_mapping_non_secret_9366475895e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "alter_user_mapping_mapped_user_current", "options": "alter_user_mapping_options_set_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_user_mapping_fact_privilege"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
ALTER USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (SET user 'b7_changed_user');
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_alter_user_mapping_non_secret_4a11f2a5280d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "alter_user_mapping_mapped_user_current", "options": "alter_user_mapping_options_drop_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_user_mapping_fact_privilege"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
ALTER USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (DROP user);
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_alter_user_mapping_non_secret_556fb61fe5bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "alter_user_mapping_mapped_user_public", "options": "alter_user_mapping_options_set_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_user_mapping_fact_privilege"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
ALTER USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (SET user 'b7_changed_user');
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;

-- case_id: manifest_alter_user_mapping_non_secret_701aed93e788
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mapped_user": "alter_user_mapping_mapped_user_public", "options": "alter_user_mapping_options_drop_user"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_user_mapping_fact_privilege"], "key": "mapping_target_server_owned"}, {"allowed_values": ["true"], "fact_refs": ["create_server::create_server_fact_fdw_environment"], "key": "documented_fdw_available"}]
-- fixture_setup:
BEGIN;
CREATE SERVER srv_map_b7 FOREIGN DATA WRAPPER log_fdw;
CREATE USER MAPPING FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
CREATE USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (user 'b7_remote_user');
-- test_sql:
ALTER USER MAPPING FOR PUBLIC SERVER srv_map_b7 OPTIONS (DROP user);
-- fixture_teardown:
DROP USER MAPPING IF EXISTS FOR PUBLIC SERVER srv_map_b7;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER srv_map_b7;
ROLLBACK;
