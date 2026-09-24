-- generated_from: manifest_explain_autohint_kernel_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_explain_autohint_kernel_syntax_5a868e3519db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"mode": "explain_autohint_mode_kernel_plan"}
-- environment_requirements: [{"allowed_values": ["in_kernel_autohint_task"], "fact_refs": ["explain_autohint_fact_runtime_contract"], "key": "autohint_task_context"}]
-- test_sql:
EXPLAIN AUTOHINT 1 PLAN '[]' FOR SELECT 1;
