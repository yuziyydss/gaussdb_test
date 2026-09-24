-- generated_from: manifest_m_alter_schema_combined
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_schema_combined_3c9009c72e46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET utf8 COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_5cbecb905635
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8mb4", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT CHARSET = utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_1787fb6764e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_gbk", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_gbk", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET = gbk COLLATE = gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_17b7140dfcb9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_gbk", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT CHARSET utf8 DEFAULT COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_a7b607936ba5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8mb4", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_c6119f0548ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_gbk", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT CHARSET gbk DEFAULT COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_ad054f6c36d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace DEFAULT CHARSET = utf8 DEFAULT COLLATE = utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_4c529d260110
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8mb4", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace CHARSET utf8 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_b7a77e1b8a8d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET utf8mb4 COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_d9531ce02756
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_gbk", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET utf8mb4 COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_combined_9f498eb93ca1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_gbk", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8mb4", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_combined", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET gbk COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;
