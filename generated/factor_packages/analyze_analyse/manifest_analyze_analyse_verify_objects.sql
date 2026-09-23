-- generated_from: manifest_analyze_analyse_verify_objects
-- static_only: true
-- case_count: 6

-- case_id: manifest_analyze_analyse_verify_objects_5b0a306f5e8a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- environment_requirements: [{"allowed_values": ["no_concurrent_business_dml"], "fact_refs": ["analyze_analyse_fact_concurrent_dml"], "key": "maintenance_window"}]
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE VERIFY FAST t_analyze_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_verify_objects_d7d3f8a145e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_yes", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_complete", "target": "analyze_analyse_target_index", "verbose": "analyze_analyse_verbose_none"}
-- environment_requirements: [{"allowed_values": ["no_concurrent_business_dml"], "fact_refs": ["analyze_analyse_fact_concurrent_dml"], "key": "maintenance_window"}]
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE VERIFY COMPLETE i_analyze_source CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_verify_objects_57814c0a244b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_yes", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_complete", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- environment_requirements: [{"allowed_values": ["no_concurrent_business_dml"], "fact_refs": ["analyze_analyse_fact_concurrent_dml"], "key": "maintenance_window"}]
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE VERIFY COMPLETE t_analyze_source CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_verify_objects_0772897d1b6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_index", "verbose": "analyze_analyse_verbose_none"}
-- environment_requirements: [{"allowed_values": ["no_concurrent_business_dml"], "fact_refs": ["analyze_analyse_fact_concurrent_dml"], "key": "maintenance_window"}]
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE VERIFY FAST i_analyze_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_verify_objects_b3fe287d0c54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_yes", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_index", "verbose": "analyze_analyse_verbose_none"}
-- environment_requirements: [{"allowed_values": ["no_concurrent_business_dml"], "fact_refs": ["analyze_analyse_fact_concurrent_dml"], "key": "maintenance_window"}]
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE VERIFY FAST i_analyze_source CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_verify_objects_a165adc1433c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_verify", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_complete", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- environment_requirements: [{"allowed_values": ["no_concurrent_business_dml"], "fact_refs": ["analyze_analyse_fact_concurrent_dml"], "key": "maintenance_window"}]
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE VERIFY COMPLETE t_analyze_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;
