-- generated_from: manifest_m_describe_finite
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_describe_finite_c1632a592358
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_all", "keyword": "m_describe_keyword_describe", "target": "m_describe_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESCRIBE m_b01_source;
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_beb9b958532d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_id", "keyword": "m_describe_keyword_describe", "target": "m_describe_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESCRIBE m_describe_view id;
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_03825c4b39a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_id", "keyword": "m_describe_keyword_desc", "target": "m_describe_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESC m_b01_source id;
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_89ddb087b6b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_all", "keyword": "m_describe_keyword_desc", "target": "m_describe_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESC m_describe_view;
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_61b6a1da1a64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_wild_percent", "keyword": "m_describe_keyword_describe", "target": "m_describe_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESCRIBE m_b01_source 'i%';
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_db3cdaa1ebb8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_wild_one", "keyword": "m_describe_keyword_describe", "target": "m_describe_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESCRIBE m_b01_source 'q_y';
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_3dfcdb034908
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_wild_percent", "keyword": "m_describe_keyword_desc", "target": "m_describe_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESC m_describe_view 'i%';
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_describe_finite_0d37e8e3074a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column": "m_describe_column_wild_one", "keyword": "m_describe_keyword_desc", "target": "m_describe_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_describe_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_describe_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
DESC m_describe_view 'q_y';
-- fixture_teardown:
DROP VIEW m_describe_view;
DROP TABLE m_b01_source;
