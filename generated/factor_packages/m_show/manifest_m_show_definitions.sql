-- generated_from: manifest_m_show_definitions
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_show_definitions_c9a2d8cd44a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_create_table", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW CREATE TABLE m_b01_source;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_definitions_32824a90a664
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_create_table_view", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW CREATE TABLE m_b01_view;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_definitions_a523c4cdb8bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_create_view", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_table"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW CREATE VIEW m_b01_view;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;
