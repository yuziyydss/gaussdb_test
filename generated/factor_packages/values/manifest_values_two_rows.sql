-- generated_from: manifest_values_two_rows
-- static_only: true
-- case_count: 23

-- case_id: manifest_values_two_rows_d58507b23bdb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2);

-- case_id: manifest_values_two_rows_2e04d0f67537
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_implicit", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1 + 1), (2, CAST('b' AS TEXT)) ORDER BY 1 LIMIT 1 OFFSET 0;

-- case_id: manifest_values_two_rows_2b28d55d211c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 ASC LIMIT ALL OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_2cf609b6dc13
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 DESC LIMIT 1 OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_f92ae191d0c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1), (2, CAST('b' AS TEXT)) ORDER BY 1 USING < LIMIT ALL OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_1e56a906bb3a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1 + 1), (2, CAST('b' AS TEXT)) ORDER BY 1 DESC OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_cf4e0ed11751
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 USING < OFFSET 0;

-- case_id: manifest_values_two_rows_3d5b8782b639
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2, CAST('b' AS TEXT)) LIMIT 1;

-- case_id: manifest_values_two_rows_2094c7ce889b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 LIMIT ALL;

-- case_id: manifest_values_two_rows_fe83ce365ca4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) LIMIT ALL OFFSET 0;

-- case_id: manifest_values_two_rows_5b0edfae049d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_asc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1), (2, CAST('b' AS TEXT)) ORDER BY 1 ASC LIMIT 1 OFFSET 0;

-- case_id: manifest_values_two_rows_fa9d1e993e56
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 ASC OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_94c5502e4fb0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_235e43c1efdf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < LIMIT 1 OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_2b304aece619
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC LIMIT ALL;

-- case_id: manifest_values_two_rows_3d81a89cd700
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_836b199f170f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 ASC;

-- case_id: manifest_values_two_rows_64d07fcfc01f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_1b2d31b75aaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 USING <;

-- case_id: manifest_values_two_rows_3d34daa888f1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 DESC OFFSET 0;

-- case_id: manifest_values_two_rows_9030835585e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_638f9011dabf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1;

-- case_id: manifest_values_two_rows_e6551054a15e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 USING <;
