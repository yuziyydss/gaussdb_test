-- generated_from: manifest_m_alter_index_fillfactor_below
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_index_fillfactor_below_03119d1d1b3d
-- expected: error
-- expected_error_category: fillfactor
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action": "m_alter_index_action_below", "if_exists": "m_alter_index_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_index_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE INDEX m_b03_existing_index ON m_b01_source(id);
CREATE INDEX m_b03_existing_index_two ON m_b01_source(qty);
-- test_sql:
ALTER INDEX m_b03_existing_index SET (fillfactor=9);
-- fixture_teardown:
DROP INDEX IF EXISTS m_b03_existing_index_two;
DROP INDEX IF EXISTS m_b03_existing_index;
DROP TABLE m_b01_source;
