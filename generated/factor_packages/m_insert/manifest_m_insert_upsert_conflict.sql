-- generated_from: manifest_m_insert_upsert_conflict
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_insert_upsert_conflict_c55c0acbee62
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_yes", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_upsert", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator_with_insert_update_select"], "fact_refs": ["m_insert_fact_duplicate_authority"], "key": "target_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_upsert (id INT PRIMARY KEY, qty INT DEFAULT 9);
INSERT INTO m_b01_upsert VALUES (7,3);
-- test_sql:
INSERT INTO m_b01_upsert VALUES (7,9) ON DUPLICATE KEY UPDATE qty = VALUES(qty);
-- fixture_teardown:
DROP TABLE m_b01_upsert;

-- case_id: manifest_m_insert_upsert_conflict_cc67ed3873b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_yes", "into": "m_insert_into_none", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_upsert", "values_keyword": "m_insert_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator_with_insert_update_select"], "fact_refs": ["m_insert_fact_duplicate_authority"], "key": "target_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_upsert (id INT PRIMARY KEY, qty INT DEFAULT 9);
INSERT INTO m_b01_upsert VALUES (7,3);
-- test_sql:
INSERT m_b01_upsert VALUE (7,9) ON DUPLICATE KEY UPDATE qty = VALUES(qty);
-- fixture_teardown:
DROP TABLE m_b01_upsert;

-- case_id: manifest_m_insert_upsert_conflict_309a13b31c9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_yes", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_upsert", "values_keyword": "m_insert_values_keyword_value"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator_with_insert_update_select"], "fact_refs": ["m_insert_fact_duplicate_authority"], "key": "target_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_upsert (id INT PRIMARY KEY, qty INT DEFAULT 9);
INSERT INTO m_b01_upsert VALUES (7,3);
-- test_sql:
INSERT INTO m_b01_upsert VALUE (7,9) ON DUPLICATE KEY UPDATE qty = VALUES(qty);
-- fixture_teardown:
DROP TABLE m_b01_upsert;

-- case_id: manifest_m_insert_upsert_conflict_56dba100b26b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"duplicate": "m_insert_duplicate_yes", "into": "m_insert_into_none", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_upsert", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator_with_insert_update_select"], "fact_refs": ["m_insert_fact_duplicate_authority"], "key": "target_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_upsert (id INT PRIMARY KEY, qty INT DEFAULT 9);
INSERT INTO m_b01_upsert VALUES (7,3);
-- test_sql:
INSERT m_b01_upsert VALUES (7,9) ON DUPLICATE KEY UPDATE qty = VALUES(qty);
-- fixture_teardown:
DROP TABLE m_b01_upsert;
