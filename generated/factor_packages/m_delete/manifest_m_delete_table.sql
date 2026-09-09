-- generated_from: manifest_m_delete_table
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_delete_table_511875a3e97a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_none", "order": "m_delete_order_none", "target": "m_delete_target_table", "where": "m_delete_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DELETE FROM m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_delete_table_dd847067ee3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_one", "order": "m_delete_order_asc", "target": "m_delete_target_table", "where": "m_delete_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DELETE FROM m_b01_source WHERE id = 2 ORDER BY id ASC LIMIT 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_delete_table_f2ee6cf16556
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_one", "order": "m_delete_order_desc_null", "target": "m_delete_target_table", "where": "m_delete_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DELETE FROM m_b01_source ORDER BY id DESC NULLS LAST LIMIT 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_delete_table_7f508dbf7e48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_none", "order": "m_delete_order_desc_null", "target": "m_delete_target_table", "where": "m_delete_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DELETE FROM m_b01_source WHERE id = 2 ORDER BY id DESC NULLS LAST;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_delete_table_88372da935b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_none", "order": "m_delete_order_asc", "target": "m_delete_target_table", "where": "m_delete_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DELETE FROM m_b01_source ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_delete_table_721e182456e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"limit": "m_delete_limit_one", "order": "m_delete_order_none", "target": "m_delete_target_table", "where": "m_delete_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_delete_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
DELETE FROM m_b01_source WHERE id = 2 LIMIT 1;
-- fixture_teardown:
DROP TABLE m_b01_source;
