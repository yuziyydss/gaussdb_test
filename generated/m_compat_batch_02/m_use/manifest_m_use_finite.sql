-- generated_from: manifest_m_use_finite
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_use_finite_368d0eb18ae5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "m_use_target_a"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_use_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_use_a;
CREATE SCHEMA m_use_b;
-- test_sql:
USE m_use_a;
-- fixture_teardown:
USE public;
DROP SCHEMA m_use_a;
DROP SCHEMA m_use_b;

-- case_id: manifest_m_use_finite_c62e0221ed6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "m_use_target_b"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_use_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE SCHEMA m_use_a;
CREATE SCHEMA m_use_b;
-- test_sql:
USE m_use_b;
-- fixture_teardown:
USE public;
DROP SCHEMA m_use_a;
DROP SCHEMA m_use_b;
