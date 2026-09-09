-- generated_from: manifest_m_replace_multiple_unique
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_replace_multiple_unique_05da099420bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_multiple_conflict", "target_profile": "m_replace_target_profile_multiple_unique", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_multi (id INT PRIMARY KEY, qty INT UNIQUE);
INSERT INTO m_replace_multi (id,qty) VALUES (1,10),(2,20);
-- test_sql:
REPLACE INTO m_replace_multi (id,qty) VALUES (1,20);
-- fixture_teardown:
DROP TABLE m_replace_multi;

-- case_id: manifest_m_replace_multiple_unique_02e4f0f20f55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"into": "m_replace_into_yes", "source_profile": "m_replace_source_profile_multiple_control", "target_profile": "m_replace_target_profile_multiple_unique", "values_keyword": "m_replace_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_replace_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_replace_fact_permissions"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_replace_multi (id INT PRIMARY KEY, qty INT UNIQUE);
INSERT INTO m_replace_multi (id,qty) VALUES (1,10),(2,20);
-- test_sql:
REPLACE INTO m_replace_multi (id,qty) VALUES (3,30);
-- fixture_teardown:
DROP TABLE m_replace_multi;
