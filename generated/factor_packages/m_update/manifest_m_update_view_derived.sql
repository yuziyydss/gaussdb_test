-- generated_from: manifest_m_update_view_derived
-- static_only: true
-- case_count: 5

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_update_view_derived_06ca10afdc1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_view", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
UPDATE m_b01_view SET qty = 99;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_view_derived_0d64030827a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_default", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_derived", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
UPDATE (SELECT id,qty FROM m_b01_source) SET qty = DEFAULT WHERE id = 2;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_view_derived_5b60120e398f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_view", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
UPDATE m_b01_view SET qty = 99 WHERE id = 2;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_view_derived_fb061f76d464
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_default", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_view", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
UPDATE m_b01_view SET qty = DEFAULT;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_view_derived_ac9dc189fc8f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_derived", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
UPDATE (SELECT id,qty FROM m_b01_source) SET qty = 99;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;
