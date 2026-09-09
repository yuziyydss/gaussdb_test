-- generated_from: manifest_m_alter_database_collation
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_database_collation_f048ad277247
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_collation_596a412ff114
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8mb4", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT COLLATE = utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_collation_23240250a59f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_gbk", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace COLLATE = gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_collation_ede8e03baa39
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_gbk", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_collation_f6ffa70b60b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8mb4", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace COLLATE utf8mb4_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_collation_6cb03928dfa8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace DEFAULT COLLATE = utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_collation_da3873040614
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_collation", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace COLLATE utf8_bin;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;
