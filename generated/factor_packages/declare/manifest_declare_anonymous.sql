-- generated_from: manifest_declare_anonymous
-- static_only: true
-- case_count: 1

-- case_id: manifest_declare_anonymous_e2976502a9a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"binary": "declare_binary_text", "cursor_name": "declare_cursor_name_one", "declarations": "declare_declarations_integer", "form": "declare_form_anonymous", "hold": "declare_hold_absent", "projection": "declare_projection_two", "query_form": "declare_query_form_select", "scroll": "declare_scroll_auto", "value_rows": "declare_value_rows_two"}
-- test_sql:
DECLARE num INTEGER := 10; BEGIN dbe_output.print_line(num); END;
