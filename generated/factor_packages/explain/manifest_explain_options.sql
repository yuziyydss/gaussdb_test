-- generated_from: manifest_explain_options
-- static_only: true
-- case_count: 25

-- case_id: manifest_explain_options_fea23fac47e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_403ad6b9302e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_insert", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE TRUE, COSTS TRUE, FORMAT XML, CPU TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_ec704e87cb67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS TRUE, FORMAT JSON, DETAIL TRUE) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_9fd6d1058a5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_delete", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE TRUE, COSTS FALSE, FORMAT YAML, BUFFERS TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_a3db87a73b71
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_select", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE TRUE, COSTS TRUE, FORMAT JSON, TIMING TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_246c9cacf258
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT YAML, TIMING TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_c9a92bf069a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_update", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE TRUE, COSTS FALSE, FORMAT TEXT, CPU TRUE) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_7183e1026569
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS TRUE, FORMAT XML) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_e017967a4c6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_select", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE TRUE, COSTS FALSE, FORMAT XML, DETAIL TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_a0da0a7496d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS TRUE, FORMAT TEXT, BUFFERS TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_d9cbd7318211
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, FORMAT YAML, CPU TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_2b49bec19d23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE TRUE, COSTS FALSE, FORMAT JSON) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_4b4c67912cc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT, DETAIL TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_af15d9ea7e92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT XML, BUFFERS TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_fd8828d03726
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT YAML) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_d33d2d13a8fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT XML, TIMING TRUE) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_41bccdf72430
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT, TIMING TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_6673e2edfda1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT JSON, CPU TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_6ae13ad3225d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, FORMAT JSON, BUFFERS TRUE) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_217270aa8e64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT YAML, DETAIL TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_30d8f243e3fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_e0ebbfad8c6e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_94d35c7e3e8a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_361330aab641
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_60b1b4cebc79
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;
