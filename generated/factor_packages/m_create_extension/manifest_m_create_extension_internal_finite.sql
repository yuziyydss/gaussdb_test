-- generated_from: manifest_m_create_extension_internal_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_extension_internal_finite_4a27818372c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_extension_if_not_exists_none", "with_keyword": "m_create_extension_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_extension_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_extension_tool_reviewed"], "fact_refs": ["m_create_extension_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["security_plugin_support_files_and_component_inventory_reviewed"], "fact_refs": ["m_create_extension_fact_files"], "key": "extension_asset"}, {"allowed_values": ["true"], "fact_refs": ["m_create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["security_plugin_installable_in_m_extension_namespace"], "fact_refs": ["m_create_extension_fact_schema"], "key": "extension_schema_contract"}, {"allowed_values": ["same_authorized_component_creator"], "fact_refs": ["m_create_extension_fact_authority"], "key": "extension_creator"}, {"allowed_values": ["disposable_database_security_plugin_absent_before_case"], "fact_refs": ["m_create_extension_fact_internal"], "key": "database_isolation"}]
-- fixture_setup:
CREATE SCHEMA m_extension_namespace;
-- test_sql:
CREATE EXTENSION security_plugin SCHEMA m_extension_namespace;
-- fixture_teardown:
DROP EXTENSION IF EXISTS security_plugin RESTRICT;
DROP SCHEMA m_extension_namespace;

-- case_id: manifest_m_create_extension_internal_finite_6e599f267d5c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_extension_if_not_exists_none", "with_keyword": "m_create_extension_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_extension_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_extension_tool_reviewed"], "fact_refs": ["m_create_extension_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["security_plugin_support_files_and_component_inventory_reviewed"], "fact_refs": ["m_create_extension_fact_files"], "key": "extension_asset"}, {"allowed_values": ["true"], "fact_refs": ["m_create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["security_plugin_installable_in_m_extension_namespace"], "fact_refs": ["m_create_extension_fact_schema"], "key": "extension_schema_contract"}, {"allowed_values": ["same_authorized_component_creator"], "fact_refs": ["m_create_extension_fact_authority"], "key": "extension_creator"}, {"allowed_values": ["disposable_database_security_plugin_absent_before_case"], "fact_refs": ["m_create_extension_fact_internal"], "key": "database_isolation"}]
-- fixture_setup:
CREATE SCHEMA m_extension_namespace;
-- test_sql:
CREATE EXTENSION security_plugin WITH SCHEMA m_extension_namespace;
-- fixture_teardown:
DROP EXTENSION IF EXISTS security_plugin RESTRICT;
DROP SCHEMA m_extension_namespace;

-- case_id: manifest_m_create_extension_internal_finite_4c035cd8b485
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_extension_if_not_exists_yes", "with_keyword": "m_create_extension_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_extension_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_extension_tool_reviewed"], "fact_refs": ["m_create_extension_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["security_plugin_support_files_and_component_inventory_reviewed"], "fact_refs": ["m_create_extension_fact_files"], "key": "extension_asset"}, {"allowed_values": ["true"], "fact_refs": ["m_create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["security_plugin_installable_in_m_extension_namespace"], "fact_refs": ["m_create_extension_fact_schema"], "key": "extension_schema_contract"}, {"allowed_values": ["same_authorized_component_creator"], "fact_refs": ["m_create_extension_fact_authority"], "key": "extension_creator"}, {"allowed_values": ["disposable_database_security_plugin_absent_before_case"], "fact_refs": ["m_create_extension_fact_internal"], "key": "database_isolation"}]
-- fixture_setup:
CREATE SCHEMA m_extension_namespace;
-- test_sql:
CREATE EXTENSION IF NOT EXISTS security_plugin SCHEMA m_extension_namespace;
-- fixture_teardown:
DROP EXTENSION IF EXISTS security_plugin RESTRICT;
DROP SCHEMA m_extension_namespace;

-- case_id: manifest_m_create_extension_internal_finite_a16face7b5e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "m_create_extension_if_not_exists_yes", "with_keyword": "m_create_extension_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_extension_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["m_internal_extension_tool_reviewed"], "fact_refs": ["m_create_extension_fact_internal"], "key": "command_applicability"}, {"allowed_values": ["security_plugin_support_files_and_component_inventory_reviewed"], "fact_refs": ["m_create_extension_fact_files"], "key": "extension_asset"}, {"allowed_values": ["true"], "fact_refs": ["m_create_extension_fact_enabled"], "key": "enable_extension"}, {"allowed_values": ["security_plugin_installable_in_m_extension_namespace"], "fact_refs": ["m_create_extension_fact_schema"], "key": "extension_schema_contract"}, {"allowed_values": ["same_authorized_component_creator"], "fact_refs": ["m_create_extension_fact_authority"], "key": "extension_creator"}, {"allowed_values": ["disposable_database_security_plugin_absent_before_case"], "fact_refs": ["m_create_extension_fact_internal"], "key": "database_isolation"}]
-- fixture_setup:
CREATE SCHEMA m_extension_namespace;
-- test_sql:
CREATE EXTENSION IF NOT EXISTS security_plugin WITH SCHEMA m_extension_namespace;
-- fixture_teardown:
DROP EXTENSION IF EXISTS security_plugin RESTRICT;
DROP SCHEMA m_extension_namespace;
