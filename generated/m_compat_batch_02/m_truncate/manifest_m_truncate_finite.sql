-- generated_from: manifest_m_truncate_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_truncate_finite_eded1a4955bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"purge": "m_truncate_purge_none", "table_word": "m_truncate_table_word_none", "targets": "m_truncate_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_truncate_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_truncate_a (id INT);
CREATE TABLE m_truncate_b (id INT);
INSERT INTO m_truncate_a VALUES (1),(2);
INSERT INTO m_truncate_b VALUES (3);
-- test_sql:
TRUNCATE m_truncate_a;
-- fixture_teardown:
DROP TABLE m_truncate_a;
DROP TABLE m_truncate_b;

-- case_id: manifest_m_truncate_finite_0af409f72cfb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"purge": "m_truncate_purge_yes", "table_word": "m_truncate_table_word_none", "targets": "m_truncate_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_truncate_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_truncate_a (id INT);
CREATE TABLE m_truncate_b (id INT);
INSERT INTO m_truncate_a VALUES (1),(2);
INSERT INTO m_truncate_b VALUES (3);
-- test_sql:
TRUNCATE m_truncate_a, m_truncate_b PURGE;
-- fixture_teardown:
DROP TABLE m_truncate_a;
DROP TABLE m_truncate_b;

-- case_id: manifest_m_truncate_finite_fc9d3d6a1962
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"purge": "m_truncate_purge_yes", "table_word": "m_truncate_table_word_yes", "targets": "m_truncate_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_truncate_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_truncate_a (id INT);
CREATE TABLE m_truncate_b (id INT);
INSERT INTO m_truncate_a VALUES (1),(2);
INSERT INTO m_truncate_b VALUES (3);
-- test_sql:
TRUNCATE TABLE m_truncate_a PURGE;
-- fixture_teardown:
DROP TABLE m_truncate_a;
DROP TABLE m_truncate_b;

-- case_id: manifest_m_truncate_finite_74170919087d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"purge": "m_truncate_purge_none", "table_word": "m_truncate_table_word_yes", "targets": "m_truncate_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_truncate_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_truncate_a (id INT);
CREATE TABLE m_truncate_b (id INT);
INSERT INTO m_truncate_a VALUES (1),(2);
INSERT INTO m_truncate_b VALUES (3);
-- test_sql:
TRUNCATE TABLE m_truncate_a, m_truncate_b;
-- fixture_teardown:
DROP TABLE m_truncate_a;
DROP TABLE m_truncate_b;
