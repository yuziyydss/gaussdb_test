-- generated_from: manifest_m_create_table_column_storage_negative
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_column_storage_negative_9e1012be2201
-- expected: error
-- expected_error_category: row_only
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "m_create_table_columns_plain", "comment": "m_create_table_comment_none", "form": "m_create_table_form_columns", "if_exists": "m_create_table_if_exists_none", "orientation": "m_create_table_orientation_column", "persistence": "m_create_table_persistence_regular"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);
-- test_sql:
CREATE TABLE m_b01_created (id INT, qty INT DEFAULT 9) WITH (orientation = column);
-- fixture_teardown:
DROP TABLE IF EXISTS m_b01_created;
DROP TABLE m_b01_like_source;
