-- generated_from: manifest_create_table_temp_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_create_table_temp_positive_b41228b69026
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer", "if_not_exists": "ct_if_absent", "persistence_modifier": "ct_persistence_temp"}
-- test_sql:
CREATE TEMP TABLE t_ct_temp_b41228b6 (id INTEGER);

-- case_id: manifest_create_table_temp_positive_4a488d121496
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer_varchar", "if_not_exists": "ct_if_present", "persistence_modifier": "ct_persistence_temp"}
-- test_sql:
CREATE TEMP TABLE IF NOT EXISTS t_ct_temp_4a488d12 (id INTEGER, name VARCHAR(50));

-- case_id: manifest_create_table_temp_positive_433b4f87ce88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer_varchar", "if_not_exists": "ct_if_absent", "persistence_modifier": "ct_persistence_temporary"}
-- test_sql:
CREATE TEMPORARY TABLE t_ct_temp_433b4f87 (id INTEGER, name VARCHAR(50));

-- case_id: manifest_create_table_temp_positive_856cd3fb653a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_profile": "ct_columns_integer", "if_not_exists": "ct_if_present", "persistence_modifier": "ct_persistence_temporary"}
-- test_sql:
CREATE TEMPORARY TABLE IF NOT EXISTS t_ct_temp_856cd3fb (id INTEGER);
