-- generated_from: manifest_m_drop_schema_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_schema_finite_c937fc98477d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_schema_if_exists_none", "targets": "m_drop_schema_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_schema_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_drop_schema_a;
CREATE SCHEMA m_drop_schema_b;
-- test_sql:
DROP SCHEMA m_drop_schema_a;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_drop_schema_a;
DROP SCHEMA IF EXISTS m_drop_schema_b;

-- case_id: manifest_m_drop_schema_finite_0d30ea1cb448
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_schema_if_exists_none", "targets": "m_drop_schema_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_schema_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_drop_schema_a;
CREATE SCHEMA m_drop_schema_b;
-- test_sql:
DROP SCHEMA m_drop_schema_a, m_drop_schema_b;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_drop_schema_a;
DROP SCHEMA IF EXISTS m_drop_schema_b;

-- case_id: manifest_m_drop_schema_finite_fcf6bf5a601c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_schema_if_exists_yes", "targets": "m_drop_schema_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_schema_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_drop_schema_a;
CREATE SCHEMA m_drop_schema_b;
-- test_sql:
DROP SCHEMA IF EXISTS m_drop_schema_a;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_drop_schema_a;
DROP SCHEMA IF EXISTS m_drop_schema_b;

-- case_id: manifest_m_drop_schema_finite_804a242c3be5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_schema_if_exists_yes", "targets": "m_drop_schema_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_schema_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_drop_schema_a;
CREATE SCHEMA m_drop_schema_b;
-- test_sql:
DROP SCHEMA IF EXISTS m_drop_schema_a, m_drop_schema_b;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_drop_schema_a;
DROP SCHEMA IF EXISTS m_drop_schema_b;
