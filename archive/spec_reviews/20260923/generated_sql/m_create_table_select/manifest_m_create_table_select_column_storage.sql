-- generated_from: manifest_m_create_table_select_column_storage
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_table_select_column_storage_5f79c4c14b9b
-- expected: error
-- expected_error_category: row_only
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"as_keyword": "m_create_table_select_as_keyword_none", "comment": "m_create_table_select_comment_none", "custom_columns": "m_create_table_select_custom_columns_none", "if_not_exists": "m_create_table_select_if_not_exists_none", "projection": "m_create_table_select_projection_two", "storage": "m_create_table_select_storage_column"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_table_select_fact_mode"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE m_ctas_source (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_ctas_source(id,qty) VALUES (1,10),(2,NULL);
-- test_sql:
CREATE TABLE m_ctas_new WITH (orientation=column) SELECT id, qty FROM m_ctas_source;
-- fixture_teardown:
DROP TABLE IF EXISTS m_ctas_new;
DROP TABLE m_ctas_source;
