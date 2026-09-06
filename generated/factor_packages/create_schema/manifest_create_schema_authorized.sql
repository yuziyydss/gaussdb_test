-- generated_from: manifest_create_schema_authorized
-- static_only: true
-- case_count: 2

-- case_id: manifest_create_schema_authorized_9dce370682bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_present", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["fp_cs_owner"], "fact_refs": ["create_schema_fact_existing_role"], "key": "prepared_schema_owner"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SCHEMA fp_cs_new AUTHORIZATION fp_cs_owner;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_schema_authorized_2c172a20f7dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_present", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_absent", "form": "create_schema_form_owner", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["fp_cs_owner"], "fact_refs": ["create_schema_fact_existing_role"], "key": "prepared_schema_owner"}]
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE SCHEMA AUTHORIZATION fp_cs_owner;
-- fixture_teardown:
ROLLBACK;
