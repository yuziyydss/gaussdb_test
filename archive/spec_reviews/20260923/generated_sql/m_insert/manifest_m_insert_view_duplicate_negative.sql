-- generated_from: manifest_m_insert_view_duplicate_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_insert_view_duplicate_negative_ff932306dd68
-- expected: error
-- expected_error_category: view_duplicate
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"duplicate": "m_insert_duplicate_yes", "into": "m_insert_into_yes", "source_profile": "m_insert_source_profile_values", "target_profile": "m_insert_target_profile_view", "values_keyword": "m_insert_values_keyword_values"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_insert_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
INSERT INTO m_b01_view VALUES (7,9) ON DUPLICATE KEY UPDATE qty = VALUES(qty);
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;
