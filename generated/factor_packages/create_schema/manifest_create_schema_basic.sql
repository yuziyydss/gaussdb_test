-- generated_from: manifest_create_schema_basic
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_schema_basic_f9a867bb6ea4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_new"}
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_basic_fc610b6fcf13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_table", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_new"}
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CREATE TABLE t_cs_inline (id INT);
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;

-- case_id: manifest_create_schema_basic_02aa353d2379
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_table_view", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_new"}
-- fixture_setup:
DROP SCHEMA IF EXISTS fp_cs_new;
-- test_sql:
CREATE SCHEMA fp_cs_new CREATE TABLE t_cs_inline (id INT) CREATE VIEW v_cs_inline AS SELECT id FROM fp_cs_new.t_cs_inline;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_new CASCADE;
