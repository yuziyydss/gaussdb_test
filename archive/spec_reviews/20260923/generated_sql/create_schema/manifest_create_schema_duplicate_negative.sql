-- generated_from: manifest_create_schema_duplicate_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_schema_duplicate_negative_e1ba7c2a8431
-- expected: error
-- expected_error_category: duplicate_schema
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_existing"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE SCHEMA fp_cs_one;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
