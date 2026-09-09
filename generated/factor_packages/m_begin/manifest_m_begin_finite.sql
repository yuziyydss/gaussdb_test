-- generated_from: manifest_m_begin_finite
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_begin_finite_4e74d9b6a7d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_default", "isolation": "m_begin_isolation_default", "work": "m_begin_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_f8d83d7ff2d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_write", "isolation": "m_begin_isolation_default", "work": "m_begin_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN WORK READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_eeaf5234facb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_read", "isolation": "m_begin_isolation_default", "work": "m_begin_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_b1ce33288066
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_default", "isolation": "m_begin_isolation_committed", "work": "m_begin_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_881d7b5bbebd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_write", "isolation": "m_begin_isolation_committed", "work": "m_begin_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL READ COMMITTED READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_c1e5faf889cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_default", "isolation": "m_begin_isolation_uncommitted", "work": "m_begin_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_ab9a4a881cf8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_read", "isolation": "m_begin_isolation_uncommitted", "work": "m_begin_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL READ UNCOMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_a7bf21e56214
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_write", "isolation": "m_begin_isolation_repeatable", "work": "m_begin_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_b8b3e39f0c00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_read", "isolation": "m_begin_isolation_repeatable", "work": "m_begin_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL REPEATABLE READ READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_f4069836b047
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_read", "isolation": "m_begin_isolation_committed", "work": "m_begin_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_f6aaab3a2433
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_write", "isolation": "m_begin_isolation_uncommitted", "work": "m_begin_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL READ UNCOMMITTED READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_cf7b40119483
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_default", "isolation": "m_begin_isolation_repeatable", "work": "m_begin_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL REPEATABLE READ;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_6fc8a7eeff26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_default", "isolation": "m_begin_isolation_serializable", "work": "m_begin_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN ISOLATION LEVEL SERIALIZABLE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_e8da7f885f5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_write", "isolation": "m_begin_isolation_serializable", "work": "m_begin_work_work"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN WORK ISOLATION LEVEL SERIALIZABLE READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;

-- case_id: manifest_m_begin_finite_827aa1a9b358
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_begin_access_read", "isolation": "m_begin_isolation_serializable", "work": "m_begin_work_transaction"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_begin_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_begin_data (id INT);
INSERT INTO m_begin_data VALUES (0);
-- test_sql:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_begin_data;
