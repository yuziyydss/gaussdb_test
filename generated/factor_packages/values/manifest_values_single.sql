-- generated_from: manifest_values_single
-- static_only: true
-- case_count: 25

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

-- case_id: manifest_values_single_88fd62a19f5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3) ORDER BY 1 USING < OFFSET 0;

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

-- case_id: manifest_values_single_2ead67e9369b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1) ORDER BY 1 DESC LIMIT 1 OFFSET 1 ROW;

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

-- case_id: manifest_values_single_459a017e197f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) ORDER BY 1 USING < LIMIT 1 OFFSET 1 ROWS;

-- case_id: manifest_values_single_b5a57a26fc1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) ORDER BY 1 USING < LIMIT ALL OFFSET 1 ROW;

-- case_id: manifest_values_single_77ef5708c023
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_nested", "limit": "values_limit_one", "more_rows": "values_more_rows_absent", "offset": "values_offset_row", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3) ORDER BY 1 LIMIT 1 OFFSET 1 ROW;

-- case_id: manifest_values_single_f8e1752eb440
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_nested", "limit": "values_limit_all", "more_rows": "values_more_rows_absent", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3) ORDER BY 1 ASC LIMIT ALL OFFSET 1 ROWS;

-- case_id: manifest_values_single_b06427defd2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) ORDER BY 1 DESC OFFSET 0;

-- case_id: manifest_values_single_62c086d75136
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1) ORDER BY 1 USING <;

-- case_id: manifest_values_single_47916e0a976c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3);

-- case_id: manifest_values_single_d2b1b85ee243
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1) ORDER BY 1 ASC;

-- case_id: manifest_values_single_b040736174b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)) ORDER BY 1 USING <;

-- case_id: manifest_values_single_039d6f20ecac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)) ORDER BY 1;

-- case_id: manifest_values_single_9f85ae0546d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_absent", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3) ORDER BY 1 DESC;
