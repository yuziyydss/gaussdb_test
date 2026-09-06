-- generated_from: manifest_values_multi_order
-- static_only: true
-- case_count: 1

-- case_id: manifest_values_multi_order_1d75910888f1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_two", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 ASC, 2 DESC;
