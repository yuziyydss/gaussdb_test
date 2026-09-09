-- generated_from: manifest_m_drop_database_finite
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_database_finite_047eb6909596
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_database_if_exists_none", "targets": "m_drop_database_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_database_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_drop_database_a;
CREATE SCHEMA m_drop_database_b;
-- test_sql:
DROP DATABASE m_drop_database_a;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_drop_database_a;
DROP SCHEMA IF EXISTS m_drop_database_b;

-- case_id: manifest_m_drop_database_finite_1b83764afee8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_database_if_exists_yes", "targets": "m_drop_database_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_database_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_drop_database_a;
CREATE SCHEMA m_drop_database_b;
-- test_sql:
DROP DATABASE IF EXISTS m_drop_database_a;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_drop_database_a;
DROP SCHEMA IF EXISTS m_drop_database_b;
