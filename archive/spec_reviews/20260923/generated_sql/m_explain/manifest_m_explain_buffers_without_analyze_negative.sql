-- generated_from: manifest_m_explain_buffers_without_analyze_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_explain_buffers_without_analyze_negative_e3c68533a5f6
-- expected: error
-- expected_error_category: buffers
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_on", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS TRUE, FORMAT TEXT) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;
