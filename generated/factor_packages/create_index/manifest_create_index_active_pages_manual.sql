-- generated_from: manifest_create_index_active_pages_manual
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_index_active_pages_manual_d105b4049d17
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment_clause": "ci_comment_none", "concurrently": "ci_concurrently_none", "if_not_exists": "ci_if_not_exists_none", "ilm_clause": "ci_ilm_none", "include_profile": "ci_include_none", "index_name_presence": "ci_index_name_present", "key_profile": "ci_key_id", "method": "ci_method_ubtree", "predicate_clause": "ci_predicate_none", "scope_clause": "ci_scope_local", "statement_form": "ci_statement_partition", "storage_profile": "ci_active_pages_manual", "table_profile": "ci_table_ustore_local_fresh", "tablespace_clause": "ci_tablespace_none", "unique_modifier": "ci_unique_none", "visibility_clause": "ci_visibility_none"}
-- environment_requirements: [{"allowed_values": ["create_any_index"], "fact_refs": ["ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["ci_fact_permissions"], "key": "case_namespace"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_creation_authority"}, {"allowed_values": ["on"], "fact_refs": ["create_table::ct_fact_ustore_tracking_prerequisites"], "key": "track_counts"}, {"allowed_values": ["on"], "fact_refs": ["create_table::ct_fact_ustore_tracking_prerequisites"], "key": "track_activities"}, {"allowed_values": ["syntax_only_not_recommended"], "fact_refs": ["ci_fact_active_pages"], "key": "active_pages_manual_profile"}]
-- fixture_setup:
CREATE TABLE g_ci_ustore_local (id INTEGER) WITH (storage_type=ustore) PARTITION BY RANGE (id) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
-- test_sql:
CREATE INDEX idx_ci_ap_d105b404 ON g_ci_ustore_local USING ubtree (id) LOCAL WITH (active_pages = 16);
-- fixture_teardown:
DROP TABLE g_ci_ustore_local RESTRICT;
