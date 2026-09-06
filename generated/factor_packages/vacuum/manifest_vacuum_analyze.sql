-- generated_from: manifest_vacuum_analyze
-- static_only: true
-- case_count: 8

-- case_id: manifest_vacuum_analyze_28643c30056c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM ANALYZE t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_116c920a29ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyse", "columns": "vacuum_columns_one", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL FREEZE VERBOSE ANALYSE t_vacuum_source (col_1) OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_9411a3c617df
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyse", "columns": "vacuum_columns_two", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM ANALYSE t_vacuum_source (col_1, col_2) OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_e99a93efc37f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_two", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL FREEZE VERBOSE ANALYZE t_vacuum_source (col_1, col_2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_96d1c8f18871
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_one", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM VERBOSE ANALYZE t_vacuum_source (col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_95e46677c63f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL FREEZE ANALYZE t_vacuum_source OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_4ba9380a0a3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyse", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FREEZE VERBOSE ANALYSE t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_analyze_c72f18f82452
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_one", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_analyze", "freeze": "vacuum_freeze_none", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL ANALYZE t_vacuum_source (col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;
