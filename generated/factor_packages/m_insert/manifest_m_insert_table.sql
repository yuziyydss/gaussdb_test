-- generated_from: manifest_m_insert_table
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_insert_table_bda386a36497
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT INTO m_b01_source VALUES (7,9);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_insert_table_8854110a3fba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_none", "source_profile": "m_insert_source_profile_many", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT m_b01_source VALUE (7,9), (8,10);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_insert_table_1826ff3e6bb8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_default", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT INTO m_b01_source VALUE (7,DEFAULT);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_insert_table_20e5f3fb312c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_none", "source_profile": "m_insert_source_profile_default", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT m_b01_source VALUES (7,DEFAULT);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_insert_table_befd413f002c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_many", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT INTO m_b01_source VALUES (7,9), (8,10);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_insert_table_6b670607803a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_none", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT m_b01_source VALUE (7,9);
-- fixture_teardown:
DROP TABLE m_b01_source;
