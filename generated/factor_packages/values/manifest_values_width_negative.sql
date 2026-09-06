-- generated_from: manifest_values_width_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_values_width_negative_09f95aab77e5
-- expected: error
-- expected_error_category: values_arity_mismatch
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1), (2, CAST('b' AS TEXT));
