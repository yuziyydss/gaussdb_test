-- generated_from: manifest_show_parameter
-- static_only: true
-- case_count: 2

-- case_id: manifest_show_parameter_5aa83a4105ff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_parameter", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_schema"}
-- test_sql:
SHOW timezone;

-- case_id: manifest_show_parameter_60c2cd810862
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_parameter", "parameter": "show_parameter_max_datanodes", "pattern": "show_pattern_var", "special": "show_special_schema"}
-- test_sql:
SHOW max_datanodes;
