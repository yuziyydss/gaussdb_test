-- generated_from: manifest_m_start_transaction_start
-- static_only: true
-- case_count: 15

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_start_transaction_start_3a5327e1943f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_default", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_3cf616c95d4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_committed", "snapshot": "m_start_transaction_snapshot_yes", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ COMMITTED READ WRITE WITH CONSISTENT SNAPSHOT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_e187c6d94fcf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_uncommitted", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ UNCOMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_e0a91e9051c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_repeatable", "snapshot": "m_start_transaction_snapshot_yes", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL REPEATABLE READ WITH CONSISTENT SNAPSHOT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_6e4f7c6c9052
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_serializable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL SERIALIZABLE READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_9e7b019d240b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_default", "snapshot": "m_start_transaction_snapshot_yes", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION READ ONLY WITH CONSISTENT SNAPSHOT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_832fdeaace3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_committed", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_90d7b95bcb18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_uncommitted", "snapshot": "m_start_transaction_snapshot_yes", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ UNCOMMITTED WITH CONSISTENT SNAPSHOT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_19388b0fd29d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_repeatable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL REPEATABLE READ READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_fa3af496824d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_default", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_serializable", "snapshot": "m_start_transaction_snapshot_yes", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL SERIALIZABLE WITH CONSISTENT SNAPSHOT;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_1d9954e3cdac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_default", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_ef705ec7451c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_committed", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_fb62c82bec23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_write", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_uncommitted", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL READ UNCOMMITTED READ WRITE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_8a334ff770fd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_repeatable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;

-- case_id: manifest_m_start_transaction_start_be05393c9155
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"access": "m_start_transaction_access_read", "form": "m_start_transaction_form_start", "isolation": "m_start_transaction_isolation_serializable", "snapshot": "m_start_transaction_snapshot_none", "work": "m_start_transaction_work_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_start_transaction_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_start_transaction_data (id INT);
INSERT INTO m_start_transaction_data VALUES (0);
-- test_sql:
START TRANSACTION ISOLATION LEVEL SERIALIZABLE READ ONLY;
-- fixture_teardown:
ROLLBACK;
DROP TABLE m_start_transaction_data;
