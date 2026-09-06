-- generated_from: manifest_values_insert_default
-- static_only: true
-- case_count: 1

-- case_id: manifest_values_insert_default_a8dd03d8d352
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"context": "values_context_insert", "fetch": "values_fetch_absent", "first_row": "values_first_row_default", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- fixture_setup:
CREATE TABLE t_values_test (id INTEGER DEFAULT 7);
-- test_sql:
INSERT INTO t_values_test (id) VALUES (DEFAULT);
-- fixture_teardown:
DROP TABLE t_values_test;
