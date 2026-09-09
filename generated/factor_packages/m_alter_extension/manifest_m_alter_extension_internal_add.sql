-- generated_from: manifest_m_alter_extension_internal_add
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_extension_internal_add_a34201624e7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_extension_action_add"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_extension_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["true"], "fact_refs": ["m_alter_extension_fact_enabled"], "key": "support_extended_features"}, {"allowed_values": ["m_internal_extension_tool_reviewed"], "fact_refs": ["m_alter_extension_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["security_plugin_support_files_and_component_inventory_reviewed"], "fact_refs": ["m_create_extension::m_create_extension_fact_files"], "key": "extension_asset"}, {"allowed_values": ["true"], "fact_refs": ["m_create_extension::m_create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["security_plugin_installable_in_m_extension_namespace"], "fact_refs": ["m_create_extension::m_create_extension_fact_schema"], "key": "extension_schema_contract"}, {"allowed_values": ["same_authorized_component_creator"], "fact_refs": ["m_create_extension::m_create_extension_fact_authority"], "key": "extension_creator"}, {"allowed_values": ["disposable_database_security_plugin_absent_before_case"], "fact_refs": ["m_alter_extension_fact_internal"], "key": "database_isolation"}, {"allowed_values": ["fixture_creator"], "fact_refs": ["m_alter_extension_fact_authority"], "key": "extension_owner"}]
-- fixture_setup:
CREATE SCHEMA m_extension_namespace;
CREATE EXTENSION security_plugin SCHEMA m_extension_namespace;
CREATE TABLE m_extension_namespace.member_table (id INTEGER);
-- test_sql:
ALTER EXTENSION security_plugin ADD TABLE m_extension_namespace.member_table;
-- fixture_teardown:
DROP EXTENSION IF EXISTS security_plugin RESTRICT;
DROP TABLE IF EXISTS m_extension_namespace.member_table;
DROP EXTENSION IF EXISTS security_plugin RESTRICT;
DROP SCHEMA m_extension_namespace;
