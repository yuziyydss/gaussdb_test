-- generated_from: manifest_show_special
-- static_only: true
-- case_count: 5

-- case_id: manifest_show_special_b638c5bd097b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_special", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_schema"}
-- test_sql:
SHOW CURRENT_SCHEMA;

-- case_id: manifest_show_special_73dd8f646c16
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_special", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_zone"}
-- test_sql:
SHOW TIME ZONE;

-- case_id: manifest_show_special_2b6baf11cd02
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_special", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_isolation"}
-- test_sql:
SHOW TRANSACTION ISOLATION LEVEL;

-- case_id: manifest_show_special_e22497146924
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_special", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_auth"}
-- test_sql:
SHOW SESSION AUTHORIZATION;

-- case_id: manifest_show_special_dc1a7575ce24
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "show_form_special", "parameter": "show_parameter_timezone", "pattern": "show_pattern_var", "special": "show_special_all"}
-- test_sql:
SHOW ALL;
