-- generated_from: manifest_autohint_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_autohint_fresh_syntax_b5add6a84400
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "autohint_options_analyze_false", "query": "autohint_query_select_one"}
-- environment_requirements: [{"allowed_values": ["super_or_admin"], "fact_refs": ["autohint_fact_body_10"], "key": "actor_authority"}]
-- test_sql:
AUTOHINT (ANALYZE FALSE) SELECT 1;
