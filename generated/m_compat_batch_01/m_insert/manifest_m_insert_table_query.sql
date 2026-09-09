-- generated_from: manifest_m_insert_table_query
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_insert_table_query_e53001224d87
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_query", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT INTO m_b01_source SELECT id,qty FROM m_b01_source WHERE id = 1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_insert_table_query_54cd89bfa2c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_none", "source_profile": "m_insert_source_profile_query", "target_profile": "m_insert_target_profile_table", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
INSERT m_b01_source SELECT id,qty FROM m_b01_source WHERE id = 1;
-- fixture_teardown:
DROP TABLE m_b01_source;
