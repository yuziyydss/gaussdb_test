-- generated_from: manifest_m_alter_schema_charset
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_schema_charset_0aecfa5156a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARACTER SET utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_f39d8aa7bcec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_split", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT CHAR SET = utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_736e7a285910
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_gbk", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET = gbk;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_92b743d84af1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_gbk", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT CHARACTER SET gbk;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_3731d26bfd79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_split", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHAR SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_30b454aa8b4a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace DEFAULT CHARSET utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_26315976be85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_yes", "equals": "m_alter_schema_equals_yes", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace DEFAULT CHARACTER SET = utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_e5d28e6cce85
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_long", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_schema_namespace CHARACTER SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_e62bec5aa250
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8", "charset_keyword": "m_alter_schema_charset_keyword_split", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHAR SET utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_3b8fe553e1f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_gbk", "charset_keyword": "m_alter_schema_charset_keyword_split", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHAR SET gbk;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;

-- case_id: manifest_m_alter_schema_charset_2585c8258ab8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_schema_charset_utf8mb4", "charset_keyword": "m_alter_schema_charset_keyword_short", "collation": "m_alter_schema_collation_utf8", "default": "m_alter_schema_default_none", "equals": "m_alter_schema_equals_none", "form": "m_alter_schema_form_charset", "keyword": "m_alter_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_schema_fact_mode", "m_alter_schema_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_schema_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database::m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_schema_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_schema_namespace CHARSET utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_schema_namespace;
