-- generated_from: manifest_explain_autohint_user_call_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_explain_autohint_user_call_negative_923689c43f73
-- expected: error
-- expected_error_category: user_call_outside_autohint_task
-- expected_sqlstates: -
-- expected_error_regex: Can not get exploration cache for cache id: 2
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"mode": "explain_autohint_mode_plan"}
-- environment_requirements: [{"allowed_values": ["not_in_kernel_autohint_task"], "fact_refs": ["explain_autohint_fact_runtime_contract"], "key": "autohint_task_context"}]
-- test_sql:
EXPLAIN AUTOHINT 2 PLAN '{"hints":[{"type": 0, "name": "enable_seqscan", "value": "true"}, {"type": 0, "name": "enable_mergejoin", "value": "false"}]}' FOR SELECT * FROM t1, t2 WHERE t1.id = t2.id and t1.a > 100 and t2.b < 200;

-- case_id: manifest_explain_autohint_user_call_negative_b655c4875ed5
-- expected: error
-- expected_error_category: user_call_outside_autohint_task
-- expected_sqlstates: -
-- expected_error_regex: Can not get exploration cache for cache id: 2
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"mode": "explain_autohint_mode_execute"}
-- environment_requirements: [{"allowed_values": ["not_in_kernel_autohint_task"], "fact_refs": ["explain_autohint_fact_runtime_contract"], "key": "autohint_task_context"}]
-- test_sql:
EXPLAIN AUTOHINT 2 EXECUTE '{"topology": 740798663, "cards": [18936500, 10592, 9308, 9308]}' FOR SELECT * FROM t1, t2 WHERE t1.id = t2.id and t1.a > 100 and t2.b < 200;
