-- generated_from: manifest_values_single
-- static_only: true
-- case_count: 20

-- case_id: manifest_values_single_a6ef8c7179b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1);

-- case_id: manifest_values_single_521fb74d1dd2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) ORDER BY 1 LIMIT 1 OFFSET 0;

-- case_id: manifest_values_single_503749c75f64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) ORDER BY 1 ASC LIMIT ALL OFFSET 1 ROW;

-- case_id: manifest_values_single_8a173d404c34
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) ORDER BY 1 DESC OFFSET 1 ROWS;

-- case_id: manifest_values_single_cf5dc9797c74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1) ORDER BY 1 USING < LIMIT 1 OFFSET 1 ROW;

-- case_id: manifest_values_single_1df71cf5ba32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1) ORDER BY 1 LIMIT ALL OFFSET 1 ROWS;

-- case_id: manifest_values_single_49c368a7d946
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) ORDER BY 1 DESC LIMIT ALL;

-- case_id: manifest_values_single_ca32b87cf2ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) LIMIT 1 OFFSET 1 ROWS;

-- case_id: manifest_values_single_53c423331e53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) ORDER BY 1 USING < OFFSET 0;

-- case_id: manifest_values_single_463be450c0d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) LIMIT ALL OFFSET 0;

-- case_id: manifest_values_single_875e599c4c86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) ORDER BY 1 ASC LIMIT 1;

-- case_id: manifest_values_single_0867e6bcb584
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) OFFSET 1 ROW;

-- case_id: manifest_values_single_66de703a2948
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1) ORDER BY 1 ASC OFFSET 0;

-- case_id: manifest_values_single_03e59c515175
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) ORDER BY 1 USING < LIMIT ALL OFFSET 1 ROWS;

-- case_id: manifest_values_single_2180b9e0f2ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) ORDER BY 1;

-- case_id: manifest_values_single_24ae1dfc2cee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1) ORDER BY 1 DESC LIMIT 1 OFFSET 0;

-- case_id: manifest_values_single_40db6f60103d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) ORDER BY 1 OFFSET 1 ROW;

-- case_id: manifest_values_single_3ff5af390ec3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) ORDER BY 1 ASC OFFSET 1 ROWS;

-- case_id: manifest_values_single_afd45a8718bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) ORDER BY 1 DESC OFFSET 1 ROW;

-- case_id: manifest_values_single_a16fbb904086
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) ORDER BY 1 USING <;
