-- generated_from: manifest_m_insert_generated_null_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_insert_generated_null_negative_d1da4fa43b43
-- expected: error
-- expected_error_category: generated_write
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"duplicate": "m_insert_duplicate_none", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_generated_null", "target_profile": "m_insert_target_profile_generated", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_generated(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
-- test_sql:
INSERT INTO m_b01_generated VALUES (7,9,NULL);
-- fixture_teardown:
DROP TABLE m_b01_generated;
