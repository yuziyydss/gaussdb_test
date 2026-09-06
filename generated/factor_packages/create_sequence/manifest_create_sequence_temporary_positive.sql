-- generated_from: manifest_create_sequence_temporary_positive
-- static_only: true
-- case_count: 11

-- case_id: manifest_create_sequence_temporary_positive_f01c7c8bbb5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE seq_cs_tmp_f01c7c8b;

-- case_id: manifest_create_sequence_temporary_positive_c73386a41493
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_no", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_one"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE IF NOT EXISTS seq_cs_tmp_c73386a4 INCREMENT 10 NO MINVALUE NO MAXVALUE START 1 CACHE 1 CYCLE OWNED BY NONE;

-- case_id: manifest_create_sequence_temporary_positive_9a81f9d6e418
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_temp", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMP SEQUENCE seq_cs_tmp_9a81f9d6 INCREMENT -2 NO MAXVALUE CACHE 1 NO CYCLE OWNED BY NONE;

-- case_id: manifest_create_sequence_temporary_positive_6a24c8cfc1c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temp", "start_clause": "cs_start_one"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMP SEQUENCE IF NOT EXISTS seq_cs_tmp_6a24c8cf NO MINVALUE START 1 NO CYCLE;

-- case_id: manifest_create_sequence_temporary_positive_4f7e4aacbb4c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temp", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMP SEQUENCE seq_cs_tmp_4f7e4aac INCREMENT 10 CYCLE;

-- case_id: manifest_create_sequence_temporary_positive_1af6ec5227f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE IF NOT EXISTS seq_cs_tmp_1af6ec52 INCREMENT -2 NO MINVALUE OWNED BY NONE;

-- case_id: manifest_create_sequence_temporary_positive_be77795fb860
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temp", "start_clause": "cs_start_one"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMP SEQUENCE seq_cs_tmp_be77795f NO MAXVALUE START 1 CACHE 1;

-- case_id: manifest_create_sequence_temporary_positive_1f26f358950f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE seq_cs_tmp_1f26f358 NO MINVALUE CACHE 1 CYCLE OWNED BY NONE;

-- case_id: manifest_create_sequence_temporary_positive_44e303576c51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE IF NOT EXISTS seq_cs_tmp_44e30357 INCREMENT 10 NO MAXVALUE NO CYCLE;

-- case_id: manifest_create_sequence_temporary_positive_beeb168870aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE seq_cs_tmp_beeb1688 INCREMENT -2 CYCLE;

-- case_id: manifest_create_sequence_temporary_positive_2b02326b4100
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_temporary", "start_clause": "cs_start_absent"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["cs_fact_temp_pg_mode"], "key": "compatibility_mode"}]
-- test_sql:
CREATE TEMPORARY SEQUENCE seq_cs_tmp_2b02326b INCREMENT 10;
