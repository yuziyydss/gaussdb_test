-- generated_from: manifest_m_analyze_missing_column
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_analyze_missing_column_30cdb501ad0b
-- expected: error
-- expected_error_category: column_exists
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "m_analyze_columns_missing", "verbose": "m_analyze_verbose_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_analyze_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["m_analyze_fact_owner"], "key": "table_authority"}, {"allowed_values": ["top_level_autocommit"], "fact_refs": ["m_analyze_fact_transaction"], "key": "execution_context"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
ANALYZE m_b01_source (missing_col);
-- fixture_teardown:
DROP TABLE m_b01_source;
