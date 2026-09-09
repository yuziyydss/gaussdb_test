-- generated_from: manifest_m_create_table_like
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_like_ee11054f98fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_like", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE m_b01_created LIKE m_b01_like_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_like_32517b2fe4a9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_like", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_temporary"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TEMPORARY TABLE IF NOT EXISTS m_b01_created LIKE m_b01_like_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_like_b156a401211a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_like", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE LOCAL TEMPORARY TABLE m_b01_created LIKE m_b01_like_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_like_48d807d3e17d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_like", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_b01_created LIKE m_b01_like_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_like_ba6fbcacc591
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_like", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_temporary"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TEMPORARY TABLE m_b01_created LIKE m_b01_like_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_like_41d2ebb05437
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_like", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE LOCAL TEMPORARY TABLE IF NOT EXISTS m_b01_created LIKE m_b01_like_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;
