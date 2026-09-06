-- generated_from: manifest_drop_foreign_data_wrapper_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_foreign_data_wrapper_existing_ad9d3eef097b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_data_wrapper_behavior_default", "if_exists": "drop_foreign_data_wrapper_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
DROP FOREIGN DATA WRAPPER fdw_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_foreign_data_wrapper_existing_0225f4bcd485
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_data_wrapper_behavior_restrict", "if_exists": "drop_foreign_data_wrapper_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
DROP FOREIGN DATA WRAPPER fdw_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_foreign_data_wrapper_existing_8d78bfbcb758
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_data_wrapper_behavior_cascade", "if_exists": "drop_foreign_data_wrapper_if_exists_no"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
DROP FOREIGN DATA WRAPPER fdw_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_foreign_data_wrapper_existing_d2451ffe79fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_data_wrapper_behavior_default", "if_exists": "drop_foreign_data_wrapper_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
DROP FOREIGN DATA WRAPPER IF EXISTS fdw_b7;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_foreign_data_wrapper_existing_cd1d0f4a4e43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_data_wrapper_behavior_restrict", "if_exists": "drop_foreign_data_wrapper_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
DROP FOREIGN DATA WRAPPER IF EXISTS fdw_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_drop_foreign_data_wrapper_existing_1f4094956dde
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_foreign_data_wrapper_behavior_cascade", "if_exists": "drop_foreign_data_wrapper_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["drop_foreign_data_wrapper_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege"], "key": "fdw_creator_privilege"}]
-- fixture_setup:
BEGIN;
CREATE FOREIGN DATA WRAPPER fdw_b7 NO HANDLER NO VALIDATOR OPTIONS (bar 'true');
-- test_sql:
DROP FOREIGN DATA WRAPPER IF EXISTS fdw_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;
