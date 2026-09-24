-- generated_from: manifest_create_sequence_float_pg_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_sequence_float_pg_negative_0db0095ff544
-- expected: error
-- expected_error_category: float_increment_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_float_pg_invalid", "max_clause": "cs_max_hundred", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_float_fixture", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_float_increment_mode"], "key": "compatibility_mode"}, {"allowed_values": ["create_any_table_and_sequence"], "fact_refs": ["cs_fact_permissions", "create_table::ct_fact_create_permissions"], "key": "executor_authority"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["cs_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE t_cs_float_owner (id INTEGER);
-- test_sql:
CREATE SEQUENCE seq_cs_float_0db0095f INCREMENT 1.5 MINVALUE 1 MAXVALUE 100 START 1 NO CYCLE OWNED BY t_cs_float_owner.id;
-- fixture_teardown:
DROP TABLE t_cs_float_owner;
