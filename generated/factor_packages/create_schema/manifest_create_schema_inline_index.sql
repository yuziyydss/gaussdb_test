-- generated_from: manifest_create_schema_inline_index
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_schema_inline_index_798a7e3f241f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"authorization": "create_schema_authorization_absent", "blockchain": "create_schema_blockchain_absent", "charset": "create_schema_charset_absent", "collation": "create_schema_collation_absent", "elements": "create_schema_elements_table_index", "form": "create_schema_form_named", "schema_name": "create_schema_schema_name_new"}
-- environment_requirements: [{"allowed_values": ["database_create"], "fact_refs": ["create_schema_fact_permission"], "key": "schema_create_authority"}, {"allowed_values": ["create_any_index"], "fact_refs": ["create_index::ci_fact_permissions"], "key": "inline_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}]
-- fixture_setup:
SHOW search_path;
-- test_sql:
CREATE SCHEMA fp_cs_new CREATE TABLE fp_cs_new.t_cs_index (id INTEGER) WITH (storage_type=astore) CREATE INDEX fp_cs_new.i_cs_index ON fp_cs_new.t_cs_index USING btree (id);
-- fixture_teardown:
DROP TABLE fp_cs_new.t_cs_index PURGE;
DROP SCHEMA fp_cs_new RESTRICT;
