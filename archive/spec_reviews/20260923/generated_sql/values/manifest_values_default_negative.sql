-- generated_from: manifest_values_default_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_values_default_negative_64d73f553fe8
-- expected: error
-- expected_error_category: default_outside_insert_values
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_default", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (DEFAULT);
