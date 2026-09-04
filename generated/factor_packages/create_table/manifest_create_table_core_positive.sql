-- generated_from: manifest_create_table_core_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_table_core_positive_85f5a2f12ac8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer", "if_not_exists": "ct_if_absent", "persistence_modifier": "ct_persistence_permanent"}
-- test_sql:
CREATE TABLE t_ct_core_85f5a2f1 (id INTEGER);

-- case_id: manifest_create_table_core_positive_e8ce7da22a5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer_varchar", "if_not_exists": "ct_if_present", "persistence_modifier": "ct_persistence_permanent"}
-- test_sql:
CREATE TABLE IF NOT EXISTS t_ct_core_e8ce7da2 (id INTEGER, name VARCHAR(50));

-- case_id: manifest_create_table_core_positive_f5ae178fe78c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer_varchar", "if_not_exists": "ct_if_absent", "persistence_modifier": "ct_persistence_unlogged"}
-- test_sql:
CREATE UNLOGGED TABLE t_ct_core_f5ae178f (id INTEGER, name VARCHAR(50));

-- case_id: manifest_create_table_core_positive_cffc32db3e03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer", "if_not_exists": "ct_if_present", "persistence_modifier": "ct_persistence_unlogged"}
-- test_sql:
CREATE UNLOGGED TABLE IF NOT EXISTS t_ct_core_cffc32db (id INTEGER);
