-- generated_from: manifest_analyze_analyse_index_cascade_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_analyze_analyse_index_cascade_negative_2a3c1e73cb92
-- expected: error
-- expected_error_category: cascade_not_valid_for_index
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"cascade": "analyze_analyse_cascade_yes", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_index", "verbose": "analyze_analyse_verbose_none"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE VERIFY FAST i_analyze_source CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;
