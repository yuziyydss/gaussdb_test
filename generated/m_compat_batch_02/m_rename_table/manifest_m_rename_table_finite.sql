-- generated_from: manifest_m_rename_table_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_rename_table_finite_7aa29f938152
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "m_rename_table_keyword_table", "renames": "m_rename_table_renames_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rename_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rename_table_a (id INT);
CREATE TABLE m_rename_table_b (id INT);
INSERT INTO m_rename_table_a VALUES (7);
-- test_sql:
RENAME TABLE m_rename_table_a TO m_rename_table_x;
-- fixture_teardown:
DROP TABLE IF EXISTS m_rename_table_x;
DROP TABLE IF EXISTS m_rename_table_y;
DROP TABLE IF EXISTS m_rename_table_a;
DROP TABLE IF EXISTS m_rename_table_b;

-- case_id: manifest_m_rename_table_finite_b0350fc1825d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "m_rename_table_keyword_table", "renames": "m_rename_table_renames_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rename_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rename_table_a (id INT);
CREATE TABLE m_rename_table_b (id INT);
INSERT INTO m_rename_table_a VALUES (7);
-- test_sql:
RENAME TABLE m_rename_table_a TO m_rename_table_x, m_rename_table_b TO m_rename_table_y;
-- fixture_teardown:
DROP TABLE IF EXISTS m_rename_table_x;
DROP TABLE IF EXISTS m_rename_table_y;
DROP TABLE IF EXISTS m_rename_table_a;
DROP TABLE IF EXISTS m_rename_table_b;

-- case_id: manifest_m_rename_table_finite_dd533916bf12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "m_rename_table_keyword_tables", "renames": "m_rename_table_renames_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rename_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rename_table_a (id INT);
CREATE TABLE m_rename_table_b (id INT);
INSERT INTO m_rename_table_a VALUES (7);
-- test_sql:
RENAME TABLES m_rename_table_a TO m_rename_table_x;
-- fixture_teardown:
DROP TABLE IF EXISTS m_rename_table_x;
DROP TABLE IF EXISTS m_rename_table_y;
DROP TABLE IF EXISTS m_rename_table_a;
DROP TABLE IF EXISTS m_rename_table_b;

-- case_id: manifest_m_rename_table_finite_849b86cd64d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "m_rename_table_keyword_tables", "renames": "m_rename_table_renames_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_rename_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_rename_table_a (id INT);
CREATE TABLE m_rename_table_b (id INT);
INSERT INTO m_rename_table_a VALUES (7);
-- test_sql:
RENAME TABLES m_rename_table_a TO m_rename_table_x, m_rename_table_b TO m_rename_table_y;
-- fixture_teardown:
DROP TABLE IF EXISTS m_rename_table_x;
DROP TABLE IF EXISTS m_rename_table_y;
DROP TABLE IF EXISTS m_rename_table_a;
DROP TABLE IF EXISTS m_rename_table_b;
