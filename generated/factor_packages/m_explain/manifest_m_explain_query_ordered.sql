-- generated_from: manifest_m_explain_query_ordered
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_explain_query_ordered_d8672e7530a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_ordered", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_ordered_f890c53bd32d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_ordered", "format": "m_explain_format_text", "ordered": "m_explain_ordered_verbose", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN VERBOSE SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_ordered_eed967985a19
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_ordered", "format": "m_explain_format_text", "ordered": "m_explain_ordered_analyze", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN ANALYZE SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_ordered_f42008561e5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_ordered", "format": "m_explain_format_text", "ordered": "m_explain_ordered_both", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN ANALYZE VERBOSE SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;
