-- generated_from: manifest_m_update_generated_negative
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_update_generated_negative_0808cd9f8f24
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"assignments": "m_update_assignments_generated_literal", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_generated", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_update_generated(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO m_b01_update_generated(id,qty) VALUES (2,9);
-- test_sql:
UPDATE m_b01_update_generated SET g = 99 WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_b01_update_generated;

-- case_id: manifest_m_update_generated_negative_440ab0a48954
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"assignments": "m_update_assignments_generated_null", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_generated", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_update_generated(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
INSERT INTO m_b01_update_generated(id,qty) VALUES (2,9);
-- test_sql:
UPDATE m_b01_update_generated SET g = NULL WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_b01_update_generated;
