-- generated_from: manifest_create_foreign_data_wrapper_no_handler
-- static_only: true
-- case_count: 6

-- case_id: manifest_create_foreign_data_wrapper_no_handler_46a84a03b472
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "create_foreign_data_wrapper_handler_absent", "options": "create_foreign_data_wrapper_options_empty", "validator": "create_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE FOREIGN DATA WRAPPER fdw_b7_new_46a84a03;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_foreign_data_wrapper_no_handler_3883da09865e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "create_foreign_data_wrapper_handler_absent", "options": "create_foreign_data_wrapper_options_debug", "validator": "create_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE FOREIGN DATA WRAPPER fdw_b7_new_3883da09 NO VALIDATOR OPTIONS (debug 'true');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_foreign_data_wrapper_no_handler_4ff81a5b2bbe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "create_foreign_data_wrapper_handler_none", "options": "create_foreign_data_wrapper_options_debug", "validator": "create_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE FOREIGN DATA WRAPPER fdw_b7_new_4ff81a5b NO HANDLER OPTIONS (debug 'true');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_foreign_data_wrapper_no_handler_8e5fb3639316
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "create_foreign_data_wrapper_handler_none", "options": "create_foreign_data_wrapper_options_empty", "validator": "create_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE FOREIGN DATA WRAPPER fdw_b7_new_8e5fb363 NO HANDLER NO VALIDATOR;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_foreign_data_wrapper_no_handler_583c4bc8fdad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "create_foreign_data_wrapper_handler_absent", "options": "create_foreign_data_wrapper_options_two", "validator": "create_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE FOREIGN DATA WRAPPER fdw_b7_new_583c4bc8 OPTIONS (debug 'true', bar 'false');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_foreign_data_wrapper_no_handler_375712d2f60a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "create_foreign_data_wrapper_handler_none", "options": "create_foreign_data_wrapper_options_two", "validator": "create_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE FOREIGN DATA WRAPPER fdw_b7_new_375712d2 NO HANDLER NO VALIDATOR OPTIONS (debug 'true', bar 'false');
-- fixture_teardown:
ROLLBACK;
