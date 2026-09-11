-- generated_from: manifest_create_sequence_system_rowid_a_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_sequence_system_rowid_a_negative_1e537e495a7c
-- expected: error
-- expected_error_category: system_column_ownership_forbidden
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_rowid_a_invalid", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_table::ct_fact_hasrowid_mode"], "key": "compatibility_mode"}, {"allowed_values": ["create_any_table_and_sequence"], "fact_refs": ["cs_fact_permissions", "create_table::ct_fact_create_permissions"], "key": "executor_authority"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["cs_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_a3_cs_system_owner (id INTEGER) WITH (hasrowid = on);
-- test_sql:
CREATE SEQUENCE seq_cs_system_1e537e49 OWNED BY g_a3_cs_system_owner.rowid;
-- fixture_teardown:
DROP TABLE g_a3_cs_system_owner RESTRICT;
