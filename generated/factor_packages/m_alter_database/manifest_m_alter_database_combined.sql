-- generated_from: manifest_m_alter_database_combined
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_database_combined_32431cda1295
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET utf8 COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_fa9b267f0776
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8mb4", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT CHARSET = utf8mb4 DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_e8d55ea5829b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_gbk", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_gbk", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET = gbk COLLATE = gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_962711daa220
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_gbk", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT CHARSET utf8 DEFAULT COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_3fbb6d31399f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8mb4", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET utf8mb4 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_d547fae63c67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_gbk", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT CHARSET gbk DEFAULT COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_d51d0146a0d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace DEFAULT CHARSET = utf8 DEFAULT COLLATE = utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_87ada25e11dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8mb4", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace CHARSET utf8 COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_1e66e0385865
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET utf8mb4 COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_ab31859112e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_gbk", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET utf8mb4 COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_combined_a335ccd1935b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_gbk", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8mb4", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET gbk COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;
