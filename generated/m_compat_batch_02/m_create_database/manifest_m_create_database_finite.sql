-- generated_from: manifest_m_create_database_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_database_finite_f19678e7ae77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_database_if_missing_none", "keyword": "m_create_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_database_fact_mode", "m_create_database_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_database_anchor;
USE m_create_database_anchor;
-- test_sql:
CREATE DATABASE m_create_database_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_database_new;
DROP SCHEMA m_create_database_anchor;

-- case_id: manifest_m_create_database_finite_96db9f395554
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_database_if_missing_yes", "keyword": "m_create_database_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_database_fact_mode", "m_create_database_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_database_anchor;
USE m_create_database_anchor;
-- test_sql:
CREATE DATABASE IF NOT EXISTS m_create_database_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_database_new;
DROP SCHEMA m_create_database_anchor;

-- case_id: manifest_m_create_database_finite_001b6e8d4fef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_database_if_missing_none", "keyword": "m_create_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_database_fact_mode", "m_create_database_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_database_anchor;
USE m_create_database_anchor;
-- test_sql:
CREATE SCHEMA m_create_database_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_database_new;
DROP SCHEMA m_create_database_anchor;

-- case_id: manifest_m_create_database_finite_fb7f0f470abd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_database_if_missing_yes", "keyword": "m_create_database_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_database_fact_mode", "m_create_database_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_database_anchor;
USE m_create_database_anchor;
-- test_sql:
CREATE SCHEMA IF NOT EXISTS m_create_database_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_database_new;
DROP SCHEMA m_create_database_anchor;
