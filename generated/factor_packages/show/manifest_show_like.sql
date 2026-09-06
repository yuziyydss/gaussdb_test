-- generated_from: manifest_show_like
-- static_only: true
-- case_count: 1

-- case_id: manifest_show_like_b4aec93f8dff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_like", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_schema"}
-- test_sql:
SHOW VARIABLES LIKE var;
