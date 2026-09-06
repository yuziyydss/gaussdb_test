-- generated_from: manifest_clean_connection_scoped_only
-- static_only: true
-- case_count: 4

-- case_id: manifest_clean_connection_scoped_only_04c2350448be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "clean_connection_check_none", "force": "clean_connection_force_none", "target": "clean_connection_target_all"}
-- environment_requirements: [{"allowed_values": ["fp_cc_isolated"], "fact_refs": ["clean_connection_fact_database_exists"], "key": "dedicated_clean_connection_database"}, {"allowed_values": ["fp_cc_test_user"], "fact_refs": ["clean_connection_fact_user_exists"], "key": "dedicated_clean_connection_user"}]
-- test_sql:
CLEAN CONNECTION TO ALL FOR DATABASE fp_cc_isolated TO USER fp_cc_test_user;

-- case_id: manifest_clean_connection_scoped_only_1766238c5120
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "clean_connection_check_check", "force": "clean_connection_force_force", "target": "clean_connection_target_all"}
-- environment_requirements: [{"allowed_values": ["fp_cc_isolated"], "fact_refs": ["clean_connection_fact_database_exists"], "key": "dedicated_clean_connection_database"}, {"allowed_values": ["fp_cc_test_user"], "fact_refs": ["clean_connection_fact_user_exists"], "key": "dedicated_clean_connection_user"}]
-- test_sql:
CLEAN CONNECTION TO ALL CHECK FORCE FOR DATABASE fp_cc_isolated TO USER fp_cc_test_user;

-- case_id: manifest_clean_connection_scoped_only_345034c3a85c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "clean_connection_check_none", "force": "clean_connection_force_force", "target": "clean_connection_target_all"}
-- environment_requirements: [{"allowed_values": ["fp_cc_isolated"], "fact_refs": ["clean_connection_fact_database_exists"], "key": "dedicated_clean_connection_database"}, {"allowed_values": ["fp_cc_test_user"], "fact_refs": ["clean_connection_fact_user_exists"], "key": "dedicated_clean_connection_user"}]
-- test_sql:
CLEAN CONNECTION TO ALL FORCE FOR DATABASE fp_cc_isolated TO USER fp_cc_test_user;

-- case_id: manifest_clean_connection_scoped_only_cf6556473cfa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "clean_connection_check_check", "force": "clean_connection_force_none", "target": "clean_connection_target_all"}
-- environment_requirements: [{"allowed_values": ["fp_cc_isolated"], "fact_refs": ["clean_connection_fact_database_exists"], "key": "dedicated_clean_connection_database"}, {"allowed_values": ["fp_cc_test_user"], "fact_refs": ["clean_connection_fact_user_exists"], "key": "dedicated_clean_connection_user"}]
-- test_sql:
CLEAN CONNECTION TO ALL CHECK FOR DATABASE fp_cc_isolated TO USER fp_cc_test_user;
