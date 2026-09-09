-- generated_from: manifest_m_alter_database_mismatch
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_database_mismatch_8e05c6f60cd3
-- expected: error
-- expected_error_category: charset_pair
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"charset": "m_alter_database_charset_utf8", "charset_keyword": "m_alter_database_charset_keyword_short", "collation": "m_alter_database_collation_gbk", "default": "m_alter_database_default_none", "equals": "m_alter_database_equals_none", "form": "m_alter_database_form_combined", "keyword": "m_alter_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_database_fact_mode", "m_alter_database_fact_namespace"], "key": "compatibility_mode"}, {"allowed_values": ["case_namespace_owner_with_create"], "fact_refs": ["m_alter_database_fact_authority"], "key": "object_authority"}, {"allowed_values": ["UTF8"], "fact_refs": ["m_alter_database_fact_encoding"], "key": "server_encoding"}]
-- fixture_setup:
CREATE SCHEMA m_alter_database_namespace CHARSET utf8;
-- test_sql:
ALTER DATABASE m_alter_database_namespace CHARSET utf8 COLLATE gbk_chinese_ci;
-- fixture_teardown:
DROP SCHEMA m_alter_database_namespace;
