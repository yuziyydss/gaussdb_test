-- generated_from: manifest_create_sequence_regular_positive
-- static_only: true
-- case_count: 154

-- case_id: manifest_create_sequence_regular_positive_68c8cd82fdc7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_68c8cd82;

-- case_id: manifest_create_sequence_regular_positive_c9bc5343a31c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_hundred", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_c9bc5343 INCREMENT -2 MINVALUE 1 MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_2f00b6ca7486
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE IF NOT EXISTS seq_cs_2f00b6ca;

-- case_id: manifest_create_sequence_regular_positive_caadafa8eecf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_caadafa8 INCREMENT 10 NO MINVALUE;

-- case_id: manifest_create_sequence_regular_positive_f12d98461aa0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_f12d9846 INCREMENT BY 2 NOMINVALUE;

-- case_id: manifest_create_sequence_regular_positive_7f98125c0cb2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_7f98125c NO MAXVALUE START 1;

-- case_id: manifest_create_sequence_regular_positive_a51b23b04ac9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_a51b23b0 NOMAXVALUE START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_98574984e50b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_98574984 CACHE 1 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_79637f5e0441
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_79637f5e CACHE 5 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_8d457b972c10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_8d457b97 NOCYCLE OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_300afc28639d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_300afc28 INCREMENT -2;

-- case_id: manifest_create_sequence_regular_positive_de02c00b96b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_de02c00b MINVALUE 1;

-- case_id: manifest_create_sequence_regular_positive_6fb8a898f75f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_6fb8a898 MAXVALUE 100 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_e7b456db2f66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_e7b456db INCREMENT 10 NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_ec5be795ecd6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_ec5be795 INCREMENT BY 2 NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_ca069f25bf08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_ca069f25 NO MINVALUE START 1;

-- case_id: manifest_create_sequence_regular_positive_b3c5e9372843
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_b3c5e937 NOMINVALUE START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_c2a65beec0d4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_c2a65bee CACHE 5 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_43a39f258a34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_43a39f25 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_34021a81983a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_34021a81 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_64d6c42555ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_64d6c425 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_09598ea6227d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_09598ea6 INCREMENT -2 MAXVALUE 100 START 1;

-- case_id: manifest_create_sequence_regular_positive_34d5f41d50b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_34d5f41d INCREMENT -2 MAXVALUE 100 START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_e99b76ceaa24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_e99b76ce INCREMENT 10;

-- case_id: manifest_create_sequence_regular_positive_8ce25e66bb28
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_8ce25e66 INCREMENT BY 2;

-- case_id: manifest_create_sequence_regular_positive_0609f81dd3bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_0609f81d MINVALUE 1;

-- case_id: manifest_create_sequence_regular_positive_9271bcdcb689
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_9271bcdc NO MINVALUE;

-- case_id: manifest_create_sequence_regular_positive_7b6045d22d11
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_7b6045d2 NOMINVALUE;

-- case_id: manifest_create_sequence_regular_positive_c34ba6a4c480
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_c34ba6a4 MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_3c93d4e6a62c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_3c93d4e6 NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_b84af6b7603c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_b84af6b7 NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_535935ab17e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_one"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_535935ab START 1;

-- case_id: manifest_create_sequence_regular_positive_669963ee95f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_669963ee START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_f0b620f79625
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_f0b620f7 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_bc47f8b17c78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_bc47f8b1 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_f9895a19f33b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_f9895a19 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_9b0a08c196f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_9b0a08c1 INCREMENT 10;

-- case_id: manifest_create_sequence_regular_positive_fa646ca3a6e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_fa646ca3 INCREMENT BY 2;

-- case_id: manifest_create_sequence_regular_positive_5babb6530e9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_5babb653 INCREMENT -2;

-- case_id: manifest_create_sequence_regular_positive_9707fa0a00a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_9707fa0a NO MINVALUE;

-- case_id: manifest_create_sequence_regular_positive_b03201e4afba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_b03201e4 NOMINVALUE;

-- case_id: manifest_create_sequence_regular_positive_fdfefad7596f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_fdfefad7 MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_c0250197f7ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_c0250197 NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_3c60c8853e91
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_3c60c885 NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_70d384bf4ea8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_70d384bf START 1;

-- case_id: manifest_create_sequence_regular_positive_b0d6372865e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_b0d63728 START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_66da73ef7dbe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_66da73ef CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_868bec530024
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_868bec53 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_e2a0da8bb426
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_e2a0da8b CYCLE;

-- case_id: manifest_create_sequence_regular_positive_e074f665a1d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_e074f665 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_6493fb5f6065
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_6493fb5f NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_b3cd12ade7e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_b3cd12ad OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_42b5189019bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_42b51890 INCREMENT 10 MINVALUE 1;

-- case_id: manifest_create_sequence_regular_positive_024c61e1fc60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_024c61e1 INCREMENT 10 NOMINVALUE;

-- case_id: manifest_create_sequence_regular_positive_1daab8cb212d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_1daab8cb INCREMENT BY 2 MINVALUE 1;

-- case_id: manifest_create_sequence_regular_positive_c6ec72205685
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_c6ec7220 INCREMENT BY 2 NO MINVALUE;

-- case_id: manifest_create_sequence_regular_positive_e39f3c711fae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_e39f3c71 INCREMENT -2 NO MINVALUE;

-- case_id: manifest_create_sequence_regular_positive_959e9a05aec9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_959e9a05 INCREMENT -2 NOMINVALUE;

-- case_id: manifest_create_sequence_regular_positive_d4c74475342b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_d4c74475 INCREMENT 10 MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_87db61f0b577
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_87db61f0 INCREMENT 10 NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_0c79ad73e169
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_0c79ad73 INCREMENT BY 2 MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_21f24ae53f24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_21f24ae5 INCREMENT BY 2 NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_bebfa882b22c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_bebfa882 INCREMENT -2 NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_938bb8ffd2ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_938bb8ff INCREMENT -2 NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_3820491c6d5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_3820491c INCREMENT 10 START 1;

-- case_id: manifest_create_sequence_regular_positive_46946a52dc57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_46946a52 INCREMENT 10 START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_ffef868ded23
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_ffef868d INCREMENT BY 2 START 1;

-- case_id: manifest_create_sequence_regular_positive_ccdf90ba8316
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_ccdf90ba INCREMENT BY 2 START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_7f015432fd1e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_7f015432 INCREMENT 10 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_1e9bf2176add
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_1e9bf217 INCREMENT 10 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_9a666fc363f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_9a666fc3 INCREMENT BY 2 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_cebccb9795fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_cebccb97 INCREMENT BY 2 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_dfaf93678135
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_dfaf9367 INCREMENT -2 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_5f20ff20aa2f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5f20ff20 INCREMENT -2 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_3a2e3e042b83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_3a2e3e04 INCREMENT 10 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_5cecdf37b127
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5cecdf37 INCREMENT 10 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_b182b5f1eb1c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_b182b5f1 INCREMENT 10 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_88df6bb5edef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_88df6bb5 INCREMENT BY 2 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_5f6161ed9303
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5f6161ed INCREMENT BY 2 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_6471b6b55a5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_6471b6b5 INCREMENT BY 2 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_619959c9aa5a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_619959c9 INCREMENT -2 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_a44bc66fbe18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_a44bc66f INCREMENT -2 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_270a82994756
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_270a8299 INCREMENT -2 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_0f0afa1905a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_0f0afa19 INCREMENT 10 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_55df1e72b03c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive_by", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_55df1e72 INCREMENT BY 2 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_e324ebfddb8f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_negative", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_e324ebfd INCREMENT -2 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_5bdb71108129
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5bdb7110 MINVALUE 1 NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_77770dee7202
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_77770dee MINVALUE 1 NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_90d30937c96e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_90d30937 NO MINVALUE MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_de55e0916657
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_de55e091 NO MINVALUE NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_66ea4ea3b7a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_66ea4ea3 NO MINVALUE NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_01f422d191ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_01f422d1 NOMINVALUE MAXVALUE 100;

-- case_id: manifest_create_sequence_regular_positive_a8060f67456e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_a8060f67 NOMINVALUE NO MAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_736a3dd65ede
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_736a3dd6 NOMINVALUE NOMAXVALUE;

-- case_id: manifest_create_sequence_regular_positive_1fd519295a53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_1fd51929 MINVALUE 1 START 1;

-- case_id: manifest_create_sequence_regular_positive_ec1a2f34675c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_ec1a2f34 MINVALUE 1 START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_5d0acffe4397
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_5d0acffe NO MINVALUE START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_23fc17823e9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_23fc1782 NOMINVALUE START 1;

-- case_id: manifest_create_sequence_regular_positive_ce2f7999c3e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_ce2f7999 MINVALUE 1 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_85c542d779b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_85c542d7 MINVALUE 1 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_b0b53381cd2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_b0b53381 NO MINVALUE CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_7d29941ac6b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_7d29941a NO MINVALUE CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_659bb6c242cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_659bb6c2 NOMINVALUE CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_8d4b6c739f9f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_8d4b6c73 NOMINVALUE CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_952e86797515
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_952e8679 MINVALUE 1 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_74a899898811
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_74a89989 MINVALUE 1 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_5343e8030067
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5343e803 MINVALUE 1 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_2ecd012fee00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_2ecd012f NO MINVALUE CYCLE;

-- case_id: manifest_create_sequence_regular_positive_2d7c65f33067
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_2d7c65f3 NO MINVALUE NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_f2802923bdd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_f2802923 NO MINVALUE NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_9ff4b329b846
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_9ff4b329 NOMINVALUE CYCLE;

-- case_id: manifest_create_sequence_regular_positive_9a4569c4ac3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_9a4569c4 NOMINVALUE NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_5bd450ff20e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5bd450ff NOMINVALUE NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_2692b12c020b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_one", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_2692b12c MINVALUE 1 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_67c2d9cd2d51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_no", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_67c2d9cd NO MINVALUE OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_317fcd3ec608
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_nomin", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_317fcd3e NOMINVALUE OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_cc14105d9354
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_cc14105d NO MAXVALUE START WITH 10;

-- case_id: manifest_create_sequence_regular_positive_c5fe0aeb6c00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_c5fe0aeb NOMAXVALUE START 1;

-- case_id: manifest_create_sequence_regular_positive_bf50216fb7c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_bf50216f MAXVALUE 100 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_fa98f11fa73d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_fa98f11f NO MAXVALUE CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_d82a1ce21024
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_d82a1ce2 NO MAXVALUE CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_aaa37e1ad791
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_aaa37e1a NOMAXVALUE CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_5bb490ce6dd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_5bb490ce NOMAXVALUE CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_1a308aead809
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_1a308aea MAXVALUE 100 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_2ec1acc53984
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_2ec1acc5 MAXVALUE 100 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_806df3e93bc0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_806df3e9 MAXVALUE 100 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_f4abafeba9c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_f4abafeb NO MAXVALUE CYCLE;

-- case_id: manifest_create_sequence_regular_positive_65f894b5e017
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_65f894b5 NO MAXVALUE NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_483c7898d360
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_483c7898 NO MAXVALUE NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_c8da3dcad4c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_c8da3dca NOMAXVALUE CYCLE;

-- case_id: manifest_create_sequence_regular_positive_2348ca3419fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_2348ca34 NOMAXVALUE NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_b8e2694c9eb8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_b8e2694c NOMAXVALUE NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_41c968a26657
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_hundred", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_41c968a2 MAXVALUE 100 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_3d0e1c61f078
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_no", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_3d0e1c61 NO MAXVALUE OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_aad075623f3e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_nomax", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_aad07562 NOMAXVALUE OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_cc0aeb0e8370
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_cc0aeb0e START 1 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_8b9605631586
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_8b960563 START 1 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_b507b8b487c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_b507b8b4 START WITH 10 CACHE 1;

-- case_id: manifest_create_sequence_regular_positive_252dd4176bd0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_252dd417 START WITH 10 CACHE 5;

-- case_id: manifest_create_sequence_regular_positive_64dd27774e96
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_64dd2777 START 1 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_26f11b0265dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_26f11b02 START 1 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_57eb0607646c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_57eb0607 START 1 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_b57ada1db174
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_b57ada1d START WITH 10 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_21bfdba75e7f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_21bfdba7 START WITH 10 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_766ed3f54ca2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_766ed3f5 START WITH 10 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_5174e2fdd76c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_one"}
-- test_sql:
CREATE SEQUENCE seq_cs_5174e2fd START 1 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_8eb719e70fb6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_with_ten"}
-- test_sql:
CREATE SEQUENCE seq_cs_8eb719e7 START WITH 10 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_c3388c55daf3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_c3388c55 CACHE 1 NO CYCLE;

-- case_id: manifest_create_sequence_regular_positive_e1b7a6f4e043
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_e1b7a6f4 CACHE 1 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_2a01a4c1e0a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_2a01a4c1 CACHE 5 CYCLE;

-- case_id: manifest_create_sequence_regular_positive_826fab9a190c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_five", "cycle_clause": "cs_nocycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_absent", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_826fab9a CACHE 5 NOCYCLE;

-- case_id: manifest_create_sequence_regular_positive_207baa824ed2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_one", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_207baa82 CACHE 1 OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_3911a1f2ddba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_3911a1f2 CYCLE OWNED BY NONE;

-- case_id: manifest_create_sequence_regular_positive_775b8687135e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_no_cycle", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_none", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- test_sql:
CREATE SEQUENCE seq_cs_775b8687 NO CYCLE OWNED BY NONE;
