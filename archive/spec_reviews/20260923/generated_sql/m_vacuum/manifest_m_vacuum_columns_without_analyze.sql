-- generated_from: manifest_m_vacuum_columns_without_analyze
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_vacuum_columns_without_analyze_bc137bfa7e03
-- expected: error
-- expected_error_category: columns_require_analyze
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "m_vacuum_columns_id", "form": "m_vacuum_form_options", "freeze": "m_vacuum_freeze_none", "full": "m_vacuum_full_none", "options": "m_vacuum_options_verbose", "verbose": "m_vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_vacuum_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_vacuum_fact_transaction"], "key": "execution_context"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_vacuum_fact_owner"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE m_vacuum_source (id INTEGER, qty INTEGER);
INSERT INTO m_vacuum_source VALUES (1,10),(2,20),(3,30);
DELETE FROM m_vacuum_source WHERE id = 1;
-- test_sql:
VACUUM (VERBOSE) m_vacuum_source (id);
-- fixture_teardown:
DROP TABLE m_vacuum_source;
