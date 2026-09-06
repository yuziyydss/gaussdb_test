-- generated_from: manifest_alter_extension_drop_member
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_extension_drop_member_2953e8361b8c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "alter_extension_form_drop", "to_version": "alter_extension_to_version_default"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_extension_fact_internal"], "key": "isolated_internal_test"}, {"allowed_values": ["true"], "fact_refs": ["alter_extension_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["true"], "fact_refs": ["create_extension::create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["ext_b7:default,1.0,b7_version"], "fact_refs": ["create_extension::create_extension_fact_support_files"], "key": "extension_support_contract"}]
-- fixture_setup:
BEGIN;
CREATE SCHEMA ext_b7_schema;
CREATE EXTENSION ext_b7 SCHEMA ext_b7_schema;
CREATE TABLE ext_b7_member (col_1 INT, col_2 INT);
CREATE SCHEMA ext_b7_target;
ALTER EXTENSION ext_b7 ADD TABLE ext_b7_member;
-- test_sql:
ALTER EXTENSION ext_b7 DROP TABLE ext_b7_member;
-- fixture_teardown:
ROLLBACK;
ROLLBACK;
ROLLBACK;
