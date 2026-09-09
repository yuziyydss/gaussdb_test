-- generated_from: manifest_m_drop_view_finite
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_view_finite_d843d3d77d12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_view_dependency_none", "if_exists": "m_drop_view_if_exists_none", "targets": "m_drop_view_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_drop_view_a AS SELECT id FROM m_b01_source;
CREATE VIEW m_drop_view_b AS SELECT id FROM m_b01_source;
-- test_sql:
DROP VIEW m_drop_view_a;
-- fixture_teardown:
DROP VIEW IF EXISTS m_drop_view_a;
DROP VIEW IF EXISTS m_drop_view_b;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_view_finite_11843bcd69f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_view_dependency_cascade", "if_exists": "m_drop_view_if_exists_none", "targets": "m_drop_view_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_drop_view_a AS SELECT id FROM m_b01_source;
CREATE VIEW m_drop_view_b AS SELECT id FROM m_b01_source;
-- test_sql:
DROP VIEW m_drop_view_a, m_drop_view_b CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS m_drop_view_a;
DROP VIEW IF EXISTS m_drop_view_b;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_view_finite_a25746c75b7d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_view_dependency_cascade", "if_exists": "m_drop_view_if_exists_yes", "targets": "m_drop_view_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_drop_view_a AS SELECT id FROM m_b01_source;
CREATE VIEW m_drop_view_b AS SELECT id FROM m_b01_source;
-- test_sql:
DROP VIEW IF EXISTS m_drop_view_a CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS m_drop_view_a;
DROP VIEW IF EXISTS m_drop_view_b;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_view_finite_190846bf9559
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_view_dependency_none", "if_exists": "m_drop_view_if_exists_yes", "targets": "m_drop_view_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_drop_view_a AS SELECT id FROM m_b01_source;
CREATE VIEW m_drop_view_b AS SELECT id FROM m_b01_source;
-- test_sql:
DROP VIEW IF EXISTS m_drop_view_a, m_drop_view_b;
-- fixture_teardown:
DROP VIEW IF EXISTS m_drop_view_a;
DROP VIEW IF EXISTS m_drop_view_b;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_view_finite_87bc0d441ec8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_view_dependency_restrict", "if_exists": "m_drop_view_if_exists_none", "targets": "m_drop_view_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_drop_view_a AS SELECT id FROM m_b01_source;
CREATE VIEW m_drop_view_b AS SELECT id FROM m_b01_source;
-- test_sql:
DROP VIEW m_drop_view_a RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS m_drop_view_a;
DROP VIEW IF EXISTS m_drop_view_b;
DROP TABLE m_b01_source;

-- case_id: manifest_m_drop_view_finite_8b864d9dc122
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency": "m_drop_view_dependency_restrict", "if_exists": "m_drop_view_if_exists_yes", "targets": "m_drop_view_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_view_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_drop_view_a AS SELECT id FROM m_b01_source;
CREATE VIEW m_drop_view_b AS SELECT id FROM m_b01_source;
-- test_sql:
DROP VIEW IF EXISTS m_drop_view_a, m_drop_view_b RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS m_drop_view_a;
DROP VIEW IF EXISTS m_drop_view_b;
DROP TABLE m_b01_source;
