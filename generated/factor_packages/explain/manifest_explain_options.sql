-- generated_from: manifest_explain_options
-- static_only: true
-- case_count: 23

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

-- case_id: manifest_explain_options_e5e4f9fef775
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS TRUE, FORMAT YAML, TIMING TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_4411a91644c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_insert", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE TRUE, COSTS FALSE, FORMAT TEXT, TIMING TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_16d704fd5181
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE TRUE, COSTS FALSE, FORMAT JSON) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_316e99141596
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS TRUE, FORMAT TEXT, CPU TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_fbead51af704
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_select", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE TRUE, COSTS FALSE, FORMAT XML, DETAIL TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_a607249d4d3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS TRUE, FORMAT XML, BUFFERS TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_6a8c428bc24d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_true", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS TRUE, FORMAT YAML) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_f4c03dedbb0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT YAML, CPU TRUE) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_4809a36618b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_xml", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_true"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE TRUE, COSTS FALSE, FORMAT XML) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_4c97f205c238
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_analyse", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYSE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT JSON, BUFFERS TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_c6df08913f82
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_buffers", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT, BUFFERS TRUE) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
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

-- case_id: manifest_explain_options_225251b3dded
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT TEXT, DETAIL TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_7665de5f748c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_true", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_timing", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE TRUE, VERBOSE FALSE, COSTS FALSE, FORMAT JSON, TIMING TRUE) DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_4a6923f9699c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_cpu", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT JSON, CPU TRUE) SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_2cfe67bbb3c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_implicit", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_yaml", "legacy": "explain_legacy_plain", "resource": "explain_resource_detail", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE, VERBOSE FALSE, COSTS FALSE, FORMAT YAML, DETAIL TRUE) INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_options_cedd7c3756e3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_options", "format": "explain_format_json", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN (ANALYZE FALSE, VERBOSE FALSE, COSTS FALSE, FORMAT JSON) UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
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
