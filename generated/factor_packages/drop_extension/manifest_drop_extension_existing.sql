-- generated_from: manifest_drop_extension_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_extension_existing_57c9fa1b462f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_extension_behavior_default", "if_exists": "drop_extension_if_exists_no", "targets": "drop_extension_targets_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_privilege"], "key": "extension_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7,ext_b7_second:isolated"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7_second SCHEMA ext_b7_schema;
-- test_sql:
DROP EXTENSION ext_b7;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_drop_extension_existing_f0ae74046b4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_extension_behavior_restrict", "if_exists": "drop_extension_if_exists_no", "targets": "drop_extension_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_privilege"], "key": "extension_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7,ext_b7_second:isolated"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7_second SCHEMA ext_b7_schema;
-- test_sql:
DROP EXTENSION ext_b7, ext_b7_second RESTRICT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_drop_extension_existing_133dfd212ead
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_extension_behavior_default", "if_exists": "drop_extension_if_exists_yes", "targets": "drop_extension_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_privilege"], "key": "extension_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7,ext_b7_second:isolated"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7_second SCHEMA ext_b7_schema;
-- test_sql:
DROP EXTENSION IF EXISTS ext_b7, ext_b7_second;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_drop_extension_existing_75fcf81b310e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_extension_behavior_restrict", "if_exists": "drop_extension_if_exists_yes", "targets": "drop_extension_targets_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_privilege"], "key": "extension_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7,ext_b7_second:isolated"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7_second SCHEMA ext_b7_schema;
-- test_sql:
DROP EXTENSION IF EXISTS ext_b7 RESTRICT;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_drop_extension_existing_c1a93aba9902
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_extension_behavior_cascade", "if_exists": "drop_extension_if_exists_no", "targets": "drop_extension_targets_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_privilege"], "key": "extension_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7,ext_b7_second:isolated"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7_second SCHEMA ext_b7_schema;
-- test_sql:
DROP EXTENSION ext_b7 CASCADE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_drop_extension_existing_3eea03acd2f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_extension_behavior_cascade", "if_exists": "drop_extension_if_exists_yes", "targets": "drop_extension_targets_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["drop_extension_fact_privilege"], "key": "extension_owner_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7,ext_b7_second:isolated"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7_second SCHEMA ext_b7_schema;
-- test_sql:
DROP EXTENSION IF EXISTS ext_b7, ext_b7_second CASCADE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
