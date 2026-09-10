-- generated_from: manifest_create_schema_inline_sequence
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_schema_inline_sequence_6c9a89f2492c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_sequence", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["database_create"], "fact_refs": ["create_schema_fact_permission"], "key": "schema_create_authority"}, {"allowed_values": ["create_any_sequence"], "fact_refs": ["create_sequence::cs_fact_permissions"], "key": "inline_create_authority"}]
-- fixture_setup:
SHOW search_path;
-- test_sql:
CREATE SCHEMA fp_cs_new CREATE SEQUENCE fp_cs_new.s_cs_inline START WITH 101 INCREMENT BY 10;
-- fixture_teardown:
DROP SEQUENCE fp_cs_new.s_cs_inline RESTRICT;
DROP SCHEMA fp_cs_new RESTRICT;
