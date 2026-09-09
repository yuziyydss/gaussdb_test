-- generated_from: manifest_m_explain_dml_plan_only
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_explain_dml_plan_only_eb3a3a94b143
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_insert", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT TEXT) INSERT INTO m_b01_source(id,qty) VALUES (4,40);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_dml_plan_only_fbdf629b544f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_update", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_json", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT JSON) UPDATE m_b01_source SET qty=99 WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_dml_plan_only_bf58a6452946
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_delete", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT TEXT) DELETE FROM m_b01_source WHERE id=2;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_dml_plan_only_dabd867d90d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_update", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_text", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT TEXT) UPDATE m_b01_source SET qty=99 WHERE id=1;
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_dml_plan_only_b39b05f009de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_insert", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_json", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT JSON) INSERT INTO m_b01_source(id,qty) VALUES (4,40);
-- fixture_teardown:
DROP TABLE m_b01_source;

-- case_id: manifest_m_explain_dml_plan_only_3c14a80094d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "m_explain_analyze_off", "body": "m_explain_body_delete", "buffers": "m_explain_buffers_off", "costs": "m_explain_costs_on", "form": "m_explain_form_options", "format": "m_explain_format_json", "ordered": "m_explain_ordered_none", "verbose": "m_explain_verbose_off"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_explain_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, BUFFERS FALSE, FORMAT JSON) DELETE FROM m_b01_source WHERE id=2;
-- fixture_teardown:
DROP TABLE m_b01_source;
