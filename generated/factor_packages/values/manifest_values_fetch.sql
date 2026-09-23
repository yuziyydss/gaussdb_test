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

-- case_id: manifest_values_fetch_f82bdb96ff14
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_implicit", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1 + 1), (2, CAST('b' AS TEXT)) ORDER BY 1 OFFSET 0 FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_5021150b68fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 ASC OFFSET 1 ROW FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_5edbaedc63a1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 DESC OFFSET 1 ROWS FETCH NEXT ROWS ONLY;

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

-- case_id: manifest_values_fetch_9583465b6b7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_asc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1), (2, CAST('b' AS TEXT)) ORDER BY 1 ASC OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_4520eae1a924
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 USING < OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_4b29915d8811
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_absent", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES ((1 + 2) * 3), (2, CAST('b' AS TEXT)) OFFSET 1 ROW FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_560651d09f78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_1d9d5fdda76f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_desc", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (1), (2, CAST('b' AS TEXT)) ORDER BY 1 DESC OFFSET 0 FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_5dc191a22722
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) OFFSET 1 ROWS FETCH FIRST 2 ROWS ONLY;

-- case_id: manifest_values_fetch_b5d208742ee8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_count", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_two_columns"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2, CAST('b' AS TEXT)) ORDER BY 1 FETCH FIRST 2 ROWS ONLY;

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

-- case_id: manifest_values_fetch_1f2bd172522f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 ASC FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_71d44b41e9cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 DESC FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_bf8065b4258a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_53c896c6c235
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_next", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 ASC OFFSET 0 FETCH NEXT ROWS ONLY;

-- case_id: manifest_values_fetch_39eb8e469510
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_expression", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1 + 1), (2) ORDER BY 1 DESC OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_ce0a5dbc5cb9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_f99627ec7996
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_nested", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_zero", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES ((1 + 2) * 3), (2) ORDER BY 1 USING < OFFSET 0 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_c5fdd74eb306
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_row", "order_by": "values_order_by_asc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 ASC OFFSET 1 ROW FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_4846d1d72b78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_null", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_using", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (CAST(NULL AS INTEGER)), (2) ORDER BY 1 USING < OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_9a5f259e8d97
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_rows", "order_by": "values_order_by_absent", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) OFFSET 1 ROWS FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_a3ec29955c18
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_integer", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_implicit", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1), (2) ORDER BY 1 FETCH FIRST ROW ONLY;

-- case_id: manifest_values_fetch_961204282905
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "values_context_standalone", "fetch": "values_fetch_first", "first_row": "values_first_row_two_columns", "limit": "values_limit_absent", "more_rows": "values_more_rows_present", "offset": "values_offset_absent", "order_by": "values_order_by_desc", "second_row": "values_second_row_integer"}
-- test_sql:
VALUES (1, CAST('a' AS TEXT)), (2) ORDER BY 1 DESC FETCH FIRST ROW ONLY;
