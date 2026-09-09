-- generated_from: manifest_create_sequence_float_b_fresh
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_sequence_float_b_fresh_d67b0511f3cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_float_b_fresh", "max_clause": "cs_max_hundred", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_float_fixture", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["cs_fact_float_increment_mode"], "key": "compatibility_mode"}, {"allowed_values": ["create_any_table_and_sequence"], "fact_refs": ["cs_fact_permissions", "create_table::ct_fact_create_permissions"], "key": "executor_authority"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["cs_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE t_cs_float_owner (id INTEGER);
-- test_sql:
CREATE SEQUENCE seq_cs_float_d67b0511 INCREMENT 1.5 MINVALUE 1 MAXVALUE 100 START 1 NO CYCLE OWNED BY t_cs_float_owner.id;
-- fixture_teardown:
DROP TABLE t_cs_float_owner;
