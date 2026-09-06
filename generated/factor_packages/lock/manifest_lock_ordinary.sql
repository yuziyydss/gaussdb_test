-- generated_from: manifest_lock_ordinary
-- static_only: true
-- case_count: 36

-- case_id: manifest_lock_ordinary_05fe698671ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_default", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_5cada1b5ef7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m0", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one, t_lock_two IN ACCESS SHARE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_0d1d9c4be265
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m1", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one IN ROW SHARE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_15577dcb30cf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m2", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one, t_lock_two IN ROW EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_09f45fb3e96f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m1", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN ROW SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_6d9a11f7b1ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m2", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN ROW EXCLUSIVE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_fea61b3d7ad4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_default", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE ONLY t_lock_one NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_e59b2aa74d03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m0", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one * IN ACCESS SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_32aa7b264918
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m3", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN SHARE UPDATE EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_8669fb31d409
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m4", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_a21f25084bb7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m5", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN SHARE ROW EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_9a444559e600
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m6", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_42f830742404
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m7", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN ACCESS EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_c31eac2db9ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m3", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one, t_lock_two IN SHARE UPDATE EXCLUSIVE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_d2113fd4938e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m4", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one, t_lock_two IN SHARE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_a5a2c293e491
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m5", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one, t_lock_two IN SHARE ROW EXCLUSIVE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_64bba97d4936
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m6", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one, t_lock_two IN EXCLUSIVE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_81c7fb202d98
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m7", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK TABLE t_lock_one, t_lock_two IN ACCESS EXCLUSIVE MODE NOWAIT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_cb08daecee7c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m0", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN ACCESS SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_3b5ab1c2a7d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m2", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_one"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one IN ROW EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_972a6830835e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_default", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one, t_lock_two;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_1d7a064cdd9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m1", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_two"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one, t_lock_two IN ROW SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_ab944893d1d8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m0", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN ACCESS SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_1a338ba963f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m2", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN ROW EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_9a703a3f85f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m3", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN SHARE UPDATE EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_cdc6ce4d5d65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m4", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_a0a4a0cb0663
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m5", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN SHARE ROW EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_52943572ee0a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m6", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_14508d881184
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m7", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_only"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK ONLY t_lock_one IN ACCESS EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_5590fef3082b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_default", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one *;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_ab6e42d270fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m1", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN ROW SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_5cb582b7761e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m3", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN SHARE UPDATE EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_c6edfcde9877
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m4", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN SHARE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_cadb8c1326f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m5", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN SHARE ROW EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_f3d66da61cad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m6", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;

-- case_id: manifest_lock_ordinary_0546d5eb814c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "lock_mode_m7", "nowait": "lock_nowait_wait", "table_keyword": "lock_table_keyword_absent", "targets": "lock_targets_star"}
-- environment_requirements: [{"allowed_values": ["owner"], "fact_refs": ["lock_fact_permission"], "key": "target_privileges"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_one CASCADE;
CREATE TABLE t_lock_one (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_one (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_lock_two CASCADE;
CREATE TABLE t_lock_two (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_two (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
LOCK t_lock_one * IN ACCESS EXCLUSIVE MODE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_lock_two CASCADE;
DROP TABLE IF EXISTS t_lock_one CASCADE;
