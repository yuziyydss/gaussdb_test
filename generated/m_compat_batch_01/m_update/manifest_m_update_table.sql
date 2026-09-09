-- generated_from: manifest_m_update_table
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_update_table_b6d21b097f04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = 99;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_f48cfb0fe959
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_default", "limit": "m_update_limit_one", "order": "m_update_order_asc", "target": "m_update_target_table", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = DEFAULT WHERE id = 2 ORDER BY id ASC LIMIT 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_8c668f094e7f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_two", "limit": "m_update_limit_one", "order": "m_update_order_desc", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET id = 8, qty = DEFAULT ORDER BY id DESC LIMIT 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_45039bec7128
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_none", "order": "m_update_order_desc", "target": "m_update_target_table", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = 99 WHERE id = 2 ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_a671acccbfd7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_default", "limit": "m_update_limit_none", "order": "m_update_order_asc", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = DEFAULT ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_bd81d3e91069
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_two", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_table", "where": "m_update_where_id"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET id = 8, qty = DEFAULT WHERE id = 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_ac32ec3e0360
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_one", "order": "m_update_order_none", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = 99 LIMIT 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_75dfa07e4be4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_literal", "limit": "m_update_limit_none", "order": "m_update_order_asc", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = 99 ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_022542745768
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_default", "limit": "m_update_limit_none", "order": "m_update_order_none", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = DEFAULT;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_1bf3016c2c70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_default", "limit": "m_update_limit_none", "order": "m_update_order_desc", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET qty = DEFAULT ORDER BY id DESC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_update_table_f27255dcbd13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignments": "m_update_assignments_two", "limit": "m_update_limit_none", "order": "m_update_order_asc", "target": "m_update_target_table", "where": "m_update_where_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_update_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
UPDATE m_b01_source SET id = 8, qty = DEFAULT ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE m_b01_source;
