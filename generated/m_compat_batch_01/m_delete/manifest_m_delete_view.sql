-- generated_from: manifest_m_delete_view
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_delete_view_5590894f5dea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_none", "order": "m_delete_order_none", "target": "m_delete_target_view", "where": "m_delete_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DELETE FROM m_b01_view;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_delete_view_43f6bc693e43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_none", "order": "m_delete_order_none", "target": "m_delete_target_view", "where": "m_delete_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DELETE FROM m_b01_view WHERE id = 2;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;
