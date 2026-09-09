-- generated_from: manifest_m_alter_view_defaults
-- static_only: true
-- case_count: 5

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_view_defaults_6c3118a13f13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_default", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target ALTER id SET DEFAULT 7;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_defaults_fab0d75156b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_yes", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_drop", "form": "m_alter_view_form_default", "if_exists": "m_alter_view_if_exists_yes", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW IF EXISTS m_alter_view_target ALTER COLUMN id DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_defaults_c98fc8f7ecf9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_drop", "form": "m_alter_view_form_default", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target ALTER id DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_defaults_87a4d514aec7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_yes", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_default", "if_exists": "m_alter_view_if_exists_none", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW m_alter_view_target ALTER COLUMN id SET DEFAULT 7;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;

-- case_id: manifest_m_alter_view_defaults_85cc4e4a6509
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_alter_view_check_none", "column_keyword": "m_alter_view_column_keyword_none", "columns": "m_alter_view_columns_implicit", "default_change": "m_alter_view_default_change_set", "form": "m_alter_view_form_default", "if_exists": "m_alter_view_if_exists_yes", "query": "m_alter_view_query_plain"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_view_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["case_view_owner"], "fact_refs": ["m_alter_view_fact_authority"], "key": "object_authority"}]
-- fixture_setup:
CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);
INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);
CREATE VIEW m_alter_view_target AS SELECT id,qty FROM m_b01_source;
-- test_sql:
ALTER VIEW IF EXISTS m_alter_view_target ALTER id SET DEFAULT 7;
-- fixture_teardown:
DROP VIEW IF EXISTS m_alter_view_renamed;
DROP VIEW IF EXISTS m_alter_view_target;
DROP TABLE m_b01_source;
