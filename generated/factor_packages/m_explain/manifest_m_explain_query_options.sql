-- generated_from: manifest_m_explain_query_options
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_explain_query_options_e7122f3cfbd3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, BUFFERS FALSE, FORMAT TEXT) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_0c84d414073e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_on", "body": "m_explain_body_query", "buffers": "m_explain_buffers_on", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_xml", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE TRUE, COSTS TRUE, BUFFERS TRUE, FORMAT XML) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_48e2e47eac79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_on", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_json", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS TRUE, FORMAT JSON) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_6024fc04d4e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_on", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_yaml", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE TRUE, COSTS FALSE, BUFFERS FALSE, FORMAT YAML) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_e6064daf7add
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_xml", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, BUFFERS FALSE, FORMAT XML) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_84693cfa4a60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_on", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_yaml", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, BUFFERS TRUE, FORMAT YAML) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_e2a2cc1b1745
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_json", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE TRUE, COSTS FALSE, BUFFERS FALSE, FORMAT JSON) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_55a71c746001
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_on", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT TEXT) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_f4f5811a8a15
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_on", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_on"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE TRUE, COSTS FALSE, BUFFERS TRUE, FORMAT TEXT) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_6fbe796f9125
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_yaml", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT YAML) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_query_options_7d254f7d6917
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_on", "body": "m_explain_body_query", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_off", "form": "m_explain_form_options", "format": "m_explain_format_json", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, BUFFERS FALSE, FORMAT JSON) SELECT id,qty FROM m_b01_source WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;
