-- generated_from: manifest_m_alter_view_definition
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_view_definition_854cffa4b000
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_4d5946544fd0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_default", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_explicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_filter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target (id,qty) AS SELECT id,qty FROM m_b01_source WHERE id > 1 WITH CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_0e92a684f4ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_local", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_filter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source WHERE id > 1 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_9e540e1cc465
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_cascaded", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_explicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target (id,qty) AS SELECT id,qty FROM m_b01_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_d9b654b6289b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_default", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source WITH CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_1c9fd73de9f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_cascaded", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_filter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source WHERE id > 1 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_a88b7ea1f983
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_local", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_explicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target (id,qty) AS SELECT id,qty FROM m_b01_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_definition_06132639b37e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_explicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_definition", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_filter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target (id,qty) AS SELECT id,qty FROM m_b01_source WHERE id > 1;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;
