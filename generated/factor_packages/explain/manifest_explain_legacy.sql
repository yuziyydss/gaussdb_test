-- generated_from: manifest_explain_legacy
-- static_only: true
-- case_count: 24

-- case_id: manifest_explain_legacy_f187d5d3a0d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_8d30bf78a94a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_verbose", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN VERBOSE INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_26492c8be596
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyze", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_adf694d7f8e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyse", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_9a3a4ad6e21b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE VERBOSE SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_7a71b5049e3f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both_alias", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE VERBOSE SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_f9e28d4b3841
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_verbose", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN VERBOSE SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_4be2dd911999
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyze", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_16fadf1edd32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyse", "resource": "explain_resource_none", "statement": "explain_statement_select", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE SELECT col_1, col_2 FROM t_explain_source WHERE col_1 > 0;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_b708a2d61351
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_1f4cfae96c67
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyze", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_1901dfdd1a9d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyse", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_6712d68f476e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE VERBOSE INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_8f5dee983d2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both_alias", "resource": "explain_resource_none", "statement": "explain_statement_insert", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE VERBOSE INSERT INTO t_explain_source (col_1, col_2) VALUES (5, 6);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_a30db04cdac7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_e20a2ace29d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_verbose", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN VERBOSE UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_914cdf85af2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyse", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_857b0462a463
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE VERBOSE UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_d6477a9926ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both_alias", "resource": "explain_resource_none", "statement": "explain_statement_update", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE VERBOSE UPDATE t_explain_source SET col_2 = 8 WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_c923249a0068
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_plain", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_428d9b6aaaed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_verbose", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN VERBOSE DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_6aed37e62ee4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_analyze", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_73223f260d00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYZE VERBOSE DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;

-- case_id: manifest_explain_legacy_e50800e6953c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"analyze": "explain_analyze_false", "costs": "explain_costs_false", "form": "explain_form_legacy", "format": "explain_format_text", "legacy": "explain_legacy_both_alias", "resource": "explain_resource_none", "statement": "explain_statement_delete", "verbose": "explain_verbose_false"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["explain_fact_rollback"], "key": "session_ownership"}]
-- fixture_setup:
CREATE TABLE t_explain_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_source VALUES (1, 2), (3, 4);
BEGIN;
SET LOCAL explain_perf_mode=normal;
-- test_sql:
EXPLAIN ANALYSE VERBOSE DELETE FROM t_explain_source WHERE col_1 = 1;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_explain_source CASCADE;
