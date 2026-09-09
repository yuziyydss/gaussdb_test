-- generated_from: manifest_m_show_view_columns
-- static_only: true
-- case_count: 6

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_show_view_columns_d1afaa09b6ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_columns", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW COLUMNS FROM m_b01_view;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_view_columns_2a084881eb29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_like", "form": "m_show_form_columns", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_yes", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW FULL COLUMNS FROM m_b01_view LIKE 'id';
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_view_columns_694d43823185
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_where", "form": "m_show_form_columns", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW COLUMNS FROM m_b01_view WHERE Field = 'id';
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_view_columns_4583ae1898d2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_like", "form": "m_show_form_columns", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_none", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW COLUMNS FROM m_b01_view LIKE 'id';
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_view_columns_4b1f83a6947b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_none", "form": "m_show_form_columns", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_yes", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW FULL COLUMNS FROM m_b01_view;
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;

-- case_id: manifest_m_show_view_columns_ceeacb1450ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"column_filter": "m_show_column_filter_where", "form": "m_show_form_columns", "from_keyword": "m_show_from_keyword_from", "full": "m_show_full_yes", "index_keyword": "m_show_index_keyword_index", "parameter": "m_show_parameter_timezone", "table_filter": "m_show_table_filter_none", "target": "m_show_target_view"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_show_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_object_owner"], "fact_refs": ["m_show_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_b01_view AS SELECT id,qty FROM m_b01_source;
-- test_sql:
SHOW FULL COLUMNS FROM m_b01_view WHERE Field = 'id';
-- fixture_teardown:
DROP VIEW m_b01_view;
DROP TABLE m_b01_source;
