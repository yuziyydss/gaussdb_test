-- generated_from: manifest_m_lock_unsupported_mode
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_lock_unsupported_mode_f27d40b02237
-- expected: error
-- expected_error_category: supported_modes
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"count": "m_lock_count_one", "keyword": "m_lock_keyword_none", "mode": "m_lock_mode_unsupported", "nowait": "m_lock_nowait_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_lock_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["same_explicit_transaction"], "fact_refs": ["m_lock_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_lock_one (id INTEGER);
CREATE TABLE m_lock_two (id INTEGER);
START TRANSACTION;
-- test_sql:
LOCK m_lock_one IN ROW SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_lock_two;
DROP TABLE m_lock_one;
