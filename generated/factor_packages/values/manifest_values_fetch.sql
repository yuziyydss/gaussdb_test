-- generated_from: manifest_values_fetch
-- static_only: true
-- case_count: 20

-- case_id: manifest_values_fetch_191e9da322ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_4015efa5e801
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_implicit", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 OFFSET 0 FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_07c922028fde
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC OFFSET 1 ROW FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_3a63992aa14f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC OFFSET 1 ROWS FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_241ee479c176
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 USING < FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_8346692c96d9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 ASC OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_c408aa9b0aa0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_f5e9bbc46f35
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) OFFSET 1 ROW FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_986b2e1545b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_c7d973bab58e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 DESC OFFSET 0 FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_ec24e66fec1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) OFFSET 1 ROWS FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_5f5b36c7d1ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_215edadccf5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_62bb0f40d695
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_cdd251f1f53d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < OFFSET 1 ROW FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_91bc3913bc02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_035df43c10cf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_75083d2bd77b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_be354a7f16c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_3ffd840cd94c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 USING < OFFSET 1 ROWS FETCH FIRST ROW ONLY;
