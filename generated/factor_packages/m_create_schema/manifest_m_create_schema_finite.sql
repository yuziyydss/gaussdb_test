-- generated_from: manifest_m_create_schema_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_schema_finite_1a278329aa47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_schema_if_missing_none", "keyword": "m_create_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_schema_fact_mode", "m_create_schema_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_schema_anchor;
USE m_create_schema_anchor;
-- test_sql:
CREATE DATABASE m_create_schema_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_schema_new;
DROP SCHEMA m_create_schema_anchor;

-- case_id: manifest_m_create_schema_finite_fe748966efd3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_schema_if_missing_yes", "keyword": "m_create_schema_keyword_database"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_schema_fact_mode", "m_create_schema_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_schema_anchor;
USE m_create_schema_anchor;
-- test_sql:
CREATE DATABASE IF NOT EXISTS m_create_schema_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_schema_new;
DROP SCHEMA m_create_schema_anchor;

-- case_id: manifest_m_create_schema_finite_5ba4033b3d80
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_schema_if_missing_none", "keyword": "m_create_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_schema_fact_mode", "m_create_schema_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_schema_anchor;
USE m_create_schema_anchor;
-- test_sql:
CREATE SCHEMA m_create_schema_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_schema_new;
DROP SCHEMA m_create_schema_anchor;

-- case_id: manifest_m_create_schema_finite_abd1ae27c87d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_missing": "m_create_schema_if_missing_yes", "keyword": "m_create_schema_keyword_schema"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_schema_fact_mode", "m_create_schema_fact_namespace"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_create_schema_anchor;
USE m_create_schema_anchor;
-- test_sql:
CREATE SCHEMA IF NOT EXISTS m_create_schema_new;
-- fixture_teardown:
USE public;
DROP SCHEMA IF EXISTS m_create_schema_new;
DROP SCHEMA m_create_schema_anchor;
