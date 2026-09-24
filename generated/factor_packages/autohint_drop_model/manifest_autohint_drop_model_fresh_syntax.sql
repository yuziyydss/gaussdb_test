-- generated_from: manifest_autohint_drop_model_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_autohint_drop_model_fresh_syntax_dd9397bdacf0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"query": "autohint_drop_model_query_select_one"}
-- environment_requirements: [{"allowed_values": ["super_or_admin"], "fact_refs": ["autohint_drop_model_fact_body_8"], "key": "actor_authority"}]
-- test_sql:
AUTOHINT DROP MODEL SELECT 1;
