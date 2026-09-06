-- generated_from: manifest_alter_foreign_data_wrapper_options
-- static_only: true
-- case_count: 10

-- case_id: manifest_alter_foreign_data_wrapper_options_4c5818d16fed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_none", "options": "alter_foreign_data_wrapper_options_add", "validator": "alter_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (ADD foo '1');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_e2d572710ff3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_none", "options": "alter_foreign_data_wrapper_options_default_add", "validator": "alter_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 NO HANDLER OPTIONS (foo '1');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_8afecc89f51d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_absent", "options": "alter_foreign_data_wrapper_options_default_add", "validator": "alter_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 NO VALIDATOR OPTIONS (foo '1');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_44040e9d5d1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_absent", "options": "alter_foreign_data_wrapper_options_add", "validator": "alter_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 OPTIONS (ADD foo '1');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_fc607653e4dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_none", "options": "alter_foreign_data_wrapper_options_set", "validator": "alter_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (SET bar 'false');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_db1b48bf1de8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_none", "options": "alter_foreign_data_wrapper_options_drop", "validator": "alter_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (DROP bar);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_dac6ff01991a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_none", "options": "alter_foreign_data_wrapper_options_mixed", "validator": "alter_foreign_data_wrapper_validator_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (ADD foo '1', DROP bar);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_d964b49c2fba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_absent", "options": "alter_foreign_data_wrapper_options_set", "validator": "alter_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 OPTIONS (SET bar 'false');
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_28f5e3de83c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_absent", "options": "alter_foreign_data_wrapper_options_drop", "validator": "alter_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 OPTIONS (DROP bar);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_foreign_data_wrapper_options_942ab80b0809
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"handler": "alter_foreign_data_wrapper_handler_absent", "options": "alter_foreign_data_wrapper_options_mixed", "validator": "alter_foreign_data_wrapper_validator_absent"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}, {"allowed_values": ["on"], "fact_refs": ["alter_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
ALTER FOREIGN DATA WRAPPER fdw_b7 OPTIONS (ADD foo '1', DROP bar);
-- fixture_teardown:
ROLLBACK;
