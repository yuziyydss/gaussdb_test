-- generated_from: manifest_values_fetch
-- static_only: true
-- case_count: 25

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

-- case_id: manifest_values_fetch_6c5ccaca7d41
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 ASC OFFSET 1 ROW FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_fd146bbe0e64
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 DESC OFFSET 1 ROWS FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_65da63d80030
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 USING < OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_c64ff206ec5f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) OFFSET 1 ROWS FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_37db28185d99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 DESC OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_a94c0742fa20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_ef4c21a3453a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 ASC FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_7cea4ea3319a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 DESC OFFSET 0 FETCH FIRST 2 ROWS ONLY;

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

-- case_id: manifest_values_fetch_9464c8765ff1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_0468c2613e28
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) OFFSET 0 FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_9f11be240629
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 ASC OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_d65b148085bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 USING < FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_a970eb5c871f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) OFFSET 1 ROW FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_d073b41710f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 ASC OFFSET 1 ROWS FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_a99b191cf173
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 DESC FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_d3af313a8576
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2, CAST('b' AS TEXT)) ORDER BY 1 USING < OFFSET 1 ROWS FETCH FIRST ROW ONLY;

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

-- case_id: manifest_values_fetch_760da348bf94
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 ASC OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_33d2bbd5f3e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_e7d235a57a32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 DESC FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_307de4176665
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 USING < FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_54e6d9ca54ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 FETCH FIRST ROW ONLY;
