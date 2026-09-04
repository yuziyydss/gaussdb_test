-- generated_from: manifest_create_sequence_owned_by_positive
-- static_only: true
-- case_count: 5

-- case_id: manifest_create_sequence_owned_by_positive_472a66894c8a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_column", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
-- test_sql:
CREATE SEQUENCE seq_cs_own_472a6689 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_create_sequence_owned_by_positive_0625f6b2943a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_column", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
-- test_sql:
CREATE LARGE SEQUENCE IF NOT EXISTS seq_cs_own_0625f6b2 INCREMENT 10 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_create_sequence_owned_by_positive_1b2e4d502724
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_positive", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_column", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
-- test_sql:
CREATE SEQUENCE seq_cs_own_1b2e4d50 INCREMENT 10 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_create_sequence_owned_by_positive_1bb7a263d72a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_present", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_column", "sequence_kind": "cs_kind_regular", "start_clause": "cs_start_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
-- test_sql:
CREATE SEQUENCE IF NOT EXISTS seq_cs_own_1bb7a263 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cs_owner CASCADE;

-- case_id: manifest_create_sequence_owned_by_positive_aa691c409fae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"cache_clause": "cs_cache_absent", "cycle_clause": "cs_cycle_absent", "if_not_exists": "cs_if_absent", "increment_clause": "cs_increment_default", "max_clause": "cs_max_absent", "min_clause": "cs_min_absent", "owned_by_clause": "cs_owned_column", "sequence_kind": "cs_kind_large", "start_clause": "cs_start_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
CREATE TABLE t_cs_owner (id INTEGER NOT NULL);
-- test_sql:
CREATE LARGE SEQUENCE seq_cs_own_aa691c40 OWNED BY t_cs_owner.id;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cs_owner CASCADE;
