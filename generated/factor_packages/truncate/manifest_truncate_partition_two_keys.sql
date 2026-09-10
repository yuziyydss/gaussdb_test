-- generated_from: manifest_truncate_partition_two_keys
-- static_only: true
-- case_count: 1

-- case_id: manifest_truncate_partition_two_keys_dfc3faef74ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"dependency_clause": "tr_dependency_default", "full_scope": "tr_scope_all", "full_table_profile": "tr_table_regular", "identity_clause": "tr_identity_default", "partition_if_exists": "tr_partition_if_absent", "partition_name": "tr_partition_name_low", "partition_selector": "tr_partition_by_values", "partition_table_profile": "tr_partition_table_two_owned", "partition_value_profile": "tr_partition_values_two_owned", "purge_clause": "tr_purge_absent", "statement_form": "tr_form_partition", "table_keyword": "tr_table_keyword_absent", "update_global_index": "tr_update_index_absent"}
-- environment_requirements: [{"allowed_values": ["actual_case_table_owner"], "fact_refs": ["tr_fact_permissions"], "key": "target_authority"}, {"allowed_values": ["database_create"], "fact_refs": ["create_schema::create_schema_fact_permission"], "key": "namespace_create_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["fixture_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "cleanup_table"}, {"allowed_values": ["owned_fresh_non_current_schema"], "fact_refs": ["drop_schema::drop_schema_fact_permission", "drop_schema::drop_schema_fact_current"], "key": "cleanup_namespace"}]
-- fixture_setup:
CREATE SCHEMA g_tr_two_ns;
CREATE TABLE g_tr_two_ns.target_table (id INTEGER, qty INTEGER) PARTITION BY RANGE (id, qty) (PARTITION p_low VALUES LESS THAN (10, 20), PARTITION p_max VALUES LESS THAN (MAXVALUE, MAXVALUE));
INSERT INTO g_tr_two_ns.target_table (id,qty) VALUES (1,10),(11,30);
-- test_sql:
ALTER TABLE g_tr_two_ns.target_table TRUNCATE PARTITION FOR (1, 10);
-- fixture_teardown:
DROP TABLE g_tr_two_ns.target_table PURGE;
DROP SCHEMA g_tr_two_ns RESTRICT;
