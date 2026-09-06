-- generated_from: manifest_analyze_analyse_statistics
-- static_only: true
-- case_count: 8

-- case_id: manifest_analyze_analyse_statistics_fda56ee4dc1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE t_analyze_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_d949c87da670
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_one", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_yes"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE VERBOSE t_analyze_source (col_1);
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_0405bff48808
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_two", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_yes"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE VERBOSE t_analyze_source (col_1, col_2);
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_e35d0c59541b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_joint", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE t_analyze_source ((col_1, col_2));
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_9416f25cfc16
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_one", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE t_analyze_source (col_1);
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_f6905d3ac4d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_joint", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyze", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_yes"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYZE VERBOSE t_analyze_source ((col_1, col_2));
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_7bccea78b59f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_two", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_none"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE t_analyze_source (col_1, col_2);
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;

-- case_id: manifest_analyze_analyse_statistics_33e1481bc10b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cascade": "analyze_analyse_cascade_none", "columns": "analyze_analyse_columns_all", "form": "analyze_analyse_form_statistics", "keyword": "analyze_analyse_keyword_analyse", "mode": "analyze_analyse_mode_fast", "target": "analyze_analyse_target_table", "verbose": "analyze_analyse_verbose_yes"}
-- fixture_setup:
CREATE TABLE t_analyze_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_analyze_source VALUES (1, 2), (3, 4);
CREATE INDEX i_analyze_source ON t_analyze_source USING btree (col_1);
-- test_sql:
ANALYSE VERBOSE t_analyze_source;
-- fixture_teardown:
DROP INDEX IF EXISTS i_analyze_source;
DROP TABLE IF EXISTS t_analyze_source CASCADE;
