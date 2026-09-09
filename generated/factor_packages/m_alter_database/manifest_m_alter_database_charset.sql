-- generated_from: manifest_m_alter_database_charset
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_database_charset_d878b05162a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARACTER SET utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_44301bf3b895
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_split", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT CHAR SET = utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_46ceea54f75a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_gbk", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET = gbk;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_33a52c223fa2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_gbk", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT CHARACTER SET gbk;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_04940942e1e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_split", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHAR SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_242d0f800c1d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace DEFAULT CHARSET utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_f73504a49aa8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_yes", "equals": "m_alter_database_equals_yes", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace DEFAULT CHARACTER SET = utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_e189d0e08a67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_long", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER SCHEMA m_alter_database_namespace CHARACTER SET utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_2bd893b21dcc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_split", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHAR SET utf8;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_f2dc0c5072a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_gbk", "charset_keyword": "m_alter_database_charset_keyword_split", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHAR SET gbk;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;

-- case_id: manifest_m_alter_database_charset_a8cc70719d92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"charset": "m_alter_database_charset_utf8mb4", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_utf8", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_charset", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET utf8mb4;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;
