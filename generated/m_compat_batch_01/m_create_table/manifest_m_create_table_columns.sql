-- generated_from: manifest_m_create_table_columns
-- static_only: true
-- case_count: 11

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_columns_066c371b61c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE m_b01_created (id INT, qty INT DEFAULT 9);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_20ae871390c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_stored", "comment": "m_create_table_comment_text", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_row", "persistence": "m_create_table_persistence_temporary"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TEMPORARY TABLE IF NOT EXISTS m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED) COMMENT = 'M pilot' WITH (orientation = row);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_2920fbd46c5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_virtual", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_row", "persistence": "m_create_table_persistence_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE LOCAL TEMPORARY TABLE m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) VIRTUAL) WITH (orientation = row);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_9cddb929ead4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_virtual", "comment": "m_create_table_comment_text", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) VIRTUAL) COMMENT = 'M pilot';
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_79e9a79dadea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_stored", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_temporary"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TEMPORARY TABLE m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_d4e0608d0448
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_text", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE LOCAL TEMPORARY TABLE IF NOT EXISTS m_b01_created (id INT, qty INT DEFAULT 9) COMMENT = 'M pilot';
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_9e6a6112e533
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_text", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_row", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE m_b01_created (id INT, qty INT DEFAULT 9) COMMENT = 'M pilot' WITH (orientation = row);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_4d79c7c1b38c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_stored", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_yes", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE IF NOT EXISTS m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_2a4d9d5a8ce0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_temporary"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TEMPORARY TABLE m_b01_created (id INT, qty INT DEFAULT 9);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_8e7698da2a23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_virtual", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_temporary"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TEMPORARY TABLE m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) VIRTUAL);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;

-- case_id: manifest_m_create_table_columns_78780d9b24dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "m_create_table_columns_stored", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_none", "persistence": "m_create_table_persistence_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE LOCAL TEMPORARY TABLE m_b01_created (id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;
