-- generated_from: manifest_vacuum_parenthesized
-- static_only: true
-- case_count: 9

-- case_id: manifest_vacuum_parenthesized_d78a03b003f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (ANALYZE) t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_94652261bf55
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_one", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_full_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (FULL, VERBOSE, ANALYZE) t_vacuum_source (col_1) OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_0891da02d63b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_two", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_reverse", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (ANALYZE, VERBOSE, FULL, FREEZE) t_vacuum_source (col_1, col_2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_63a23bfea04c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_reverse", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (ANALYZE, VERBOSE, FULL, FREEZE) t_vacuum_source OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_3f1d62ba84cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_two", "execution_mode": "vacuum_execution_mode_offline", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (ANALYZE) t_vacuum_source (col_1, col_2) OFFLINE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_22deeb4b45e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_none", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_full_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (FULL, VERBOSE, ANALYZE) t_vacuum_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_d09f7ef7e8a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_one", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (ANALYZE) t_vacuum_source (col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_e6e250750ef3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_one", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_reverse", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (ANALYZE, VERBOSE, FULL, FREEZE) t_vacuum_source (col_1);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;

-- case_id: manifest_vacuum_parenthesized_3ab9f8f84343
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "vacuum_analyze_analyze", "columns": "vacuum_columns_two", "execution_mode": "vacuum_execution_mode_default", "form": "vacuum_form_paren", "freeze": "vacuum_freeze_none", "full": "vacuum_full_none", "options": "vacuum_options_full_analyze", "verbose": "vacuum_verbose_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["vacuum_fact_no_transaction"], "key": "autocommit_no_transaction"}]
-- fixture_setup:
CREATE TABLE t_vacuum_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_vacuum_source VALUES (1, 2), (3, 4);
DELETE FROM t_vacuum_source WHERE col_1 = 1;
-- test_sql:
VACUUM (FULL, VERBOSE, ANALYZE) t_vacuum_source (col_1, col_2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_vacuum_source CASCADE;
