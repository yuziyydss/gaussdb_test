-- generated_from: manifest_m_alter_schema_collation
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_schema_collation_268a0c1d716c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_collation_f75a7c5853ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8mb4", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_collation_43d89b8943ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_gbk", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace COLLATE = gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_collation_f0eb55ff8afb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_gbk", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_collation_944bc970cb50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8mb4", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_collation_e6b2e68625d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace DEFAULT COLLATE = utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_collation_9f656ff9cae4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_collation", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;
