-- generated_from: manifest_vacuum_plain
-- static_only: true
-- case_count: 6

-- case_id: manifest_vacuum_plain_0b94f37aec31
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_plain", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_plain_f20b36809cfd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_plain", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL FREEZE VERBOSE t_vacuum_source OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_plain_82ef61ef2ec0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_plain", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM VERBOSE t_vacuum_source OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_plain_7d5d43d45355
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_plain", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL FREEZE t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_plain_d78f8d49e68e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_plain", "freeze": "vacuum_freeze_freeze", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FREEZE t_vacuum_source OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_plain_7c29dce47c4b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_plain", "freeze": "vacuum_freeze_none", "full": "vacuum_full_full", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_verbose"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM FULL VERBOSE t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;
