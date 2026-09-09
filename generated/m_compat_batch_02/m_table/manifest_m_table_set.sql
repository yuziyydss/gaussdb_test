-- generated_from: manifest_m_table_set
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_table_set_840c0f9831c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_set", "limit": "m_table_limit_none", "operator": "m_table_operator_union", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source UNION TABLE m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_set_b41734abf1a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_set", "limit": "m_table_limit_none", "operator": "m_table_operator_all", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source UNION ALL TABLE m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_set_e4b25e9001be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_set", "limit": "m_table_limit_none", "operator": "m_table_operator_except", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source EXCEPT TABLE m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;
