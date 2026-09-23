-- generated_from: manifest_explain_execution_stats_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_explain_execution_stats_negative_8698eaccd447
-- expected: error
-- expected_error_category: explain_runtime_option_requires_analyze
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT, CPU TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;
