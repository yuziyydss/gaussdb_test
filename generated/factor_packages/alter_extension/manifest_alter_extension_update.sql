-- generated_from: manifest_alter_extension_update
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_extension_update_b326ee42dc3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_extension_form_update", "to_version": "alter_extension_to_version_default"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["alter_extension_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}, {"allowed_values": ["ext_b7:default_to_2.0"], "fact_refs": ["alter_extension_fact_update"], "key": "extension_update_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE TABLE ext_b7_member (col_1 INT, col_2 INT);
CREATE SCHEMA ext_b7_target;
-- test_sql:
ALTER EXTENSION ext_b7 UPDATE;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;

-- case_id: manifest_alter_extension_update_ffa3fad3e7ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_extension_form_update", "to_version": "alter_extension_to_version_specified"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["alter_extension_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}, {"allowed_values": ["ext_b7:default_to_2.0"], "fact_refs": ["alter_extension_fact_update"], "key": "extension_update_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE TABLE ext_b7_member (col_1 INT, col_2 INT);
CREATE SCHEMA ext_b7_target;
-- test_sql:
ALTER EXTENSION ext_b7 UPDATE TO '2.0';
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
