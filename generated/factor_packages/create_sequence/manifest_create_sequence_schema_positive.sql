-- generated_from: manifest_create_sequence_schema_positive
-- static_only: true
-- case_count: 5

-- case_id: manifest_create_sequence_schema_positive_633e6a909132
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE public.seq_cs_schema_633e6a90;

-- case_id: manifest_create_sequence_schema_positive_ed4418b9e4bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE IF NOT EXISTS public.seq_cs_schema_ed4418b9 INCREMENT 10;

-- case_id: manifest_create_sequence_schema_positive_b46fdf502da6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE public.seq_cs_schema_b46fdf50 INCREMENT 10;

-- case_id: manifest_create_sequence_schema_positive_96e99bdce75a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS public.seq_cs_schema_96e99bdc;

-- case_id: manifest_create_sequence_schema_positive_72fc4c0fa2da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE public.seq_cs_schema_72fc4c0f;
