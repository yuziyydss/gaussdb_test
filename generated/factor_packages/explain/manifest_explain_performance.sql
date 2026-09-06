-- generated_from: manifest_explain_performance
-- static_only: true
-- case_count: 4

-- case_id: manifest_explain_performance_c24fe91fe6b9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_performance", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN PERFORMANCE SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_performance_fa4ba403431a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_performance", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN PERFORMANCE INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_performance_343fea1e6321
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_performance", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN PERFORMANCE UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_performance_27666306eada
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_performance", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN PERFORMANCE DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;
