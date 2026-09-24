-- generated_from: manifest_values_two_rows
-- static_only: true
-- case_count: 20

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

-- case_id: manifest_values_two_rows_a3917cebe5eb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_implicit", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 LIMIT 1 OFFSET 0;

-- case_id: manifest_values_two_rows_62f779e0a6a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC LIMIT ALL OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_2900db7b8df5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC LIMIT 1 OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_1e31e3abfa1d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_using", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 USING < OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_1d46a2769e92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) LIMIT ALL OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_dc542ef9ecda
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < LIMIT ALL OFFSET 0;

-- case_id: manifest_values_two_rows_41d7e5d0c5f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 ASC LIMIT 1;

-- case_id: manifest_values_two_rows_a344d828340e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_1f2e4dca3a51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 DESC OFFSET 0;

-- case_id: manifest_values_two_rows_c701e74a892e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) LIMIT 1 OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_e5fd0597e62c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_all", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 LIMIT ALL;

-- case_id: manifest_values_two_rows_7634b345b3cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC OFFSET 0;

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

-- case_id: manifest_values_two_rows_8f1fa9ac8dd8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_one", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < LIMIT 1;

-- case_id: manifest_values_two_rows_c9bd8e94884b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) OFFSET 0;

-- case_id: manifest_values_two_rows_6483a9f58ce3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_afbd7fe8f529
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC OFFSET 1 ROWS;

-- case_id: manifest_values_two_rows_fae91d69fb11
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC OFFSET 1 ROW;

-- case_id: manifest_values_two_rows_5f0df00d9712
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_absent", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < OFFSET 1 ROWS;
