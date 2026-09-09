-- generated_from: manifest_m_start_transaction_begin
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_start_transaction_begin_433c8b141a0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_default", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_37ed0ad2ecae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_committed", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_02e1326a99d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_uncommitted", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_b1f0eb0bcf4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_repeatable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_8904f750bff1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_serializable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_412bca0bc29f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_default", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_70ff8a9ddcb1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_default", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN WORK READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_781fd6c3d165
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_committed", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_18fbe3ee98e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_uncommitted", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL READ UNCOMMITTED READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_6fcde1067737
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_committed", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_7f093ce269b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_uncommitted", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_6adc03b453b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_repeatable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL REPEATABLE READ READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_cf59346073fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_repeatable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_ae36a4d53b65
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_serializable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL SERIALIZABLE READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_begin_8162b5bc54b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_begin", "isolation": "m_start_transaction_isolation_serializable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL SERIALIZABLE READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;
