-- generated_from: manifest_m_table_query
-- static_only: true
-- case_count: 12

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_table_query_84a40661a0c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_none", "operator": "m_table_operator_union", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_72dbe39fd2db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_count", "operator": "m_table_operator_union", "order": "m_table_order_asc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY id ASC LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_f9e235807d93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_comma", "operator": "m_table_operator_union", "order": "m_table_order_desc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY 1 DESC LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_2c1b4292e971
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_offset", "operator": "m_table_operator_union", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_5e3269cd042c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_count", "operator": "m_table_operator_union", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_aed3d9272763
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_comma", "operator": "m_table_operator_union", "order": "m_table_order_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_263f4ff27c2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_none", "operator": "m_table_operator_union", "order": "m_table_order_asc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY id ASC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_9d488bc53b81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_comma", "operator": "m_table_operator_union", "order": "m_table_order_asc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY id ASC LIMIT 1,2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_c26800c238e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_offset", "operator": "m_table_operator_union", "order": "m_table_order_asc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY id ASC LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_88754c855ecc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_none", "operator": "m_table_operator_union", "order": "m_table_order_desc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY 1 DESC;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_4fa026c1482d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_count", "operator": "m_table_operator_union", "order": "m_table_order_desc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY 1 DESC LIMIT 2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_table_query_9fc3e46f3ad0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_table_form_query", "limit": "m_table_limit_offset", "operator": "m_table_operator_union", "order": "m_table_order_desc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
TABLE m_b01_source ORDER BY 1 DESC LIMIT 2 OFFSET 1;
-- fixture_teardown:
DROP TABLE m_b01_source;
