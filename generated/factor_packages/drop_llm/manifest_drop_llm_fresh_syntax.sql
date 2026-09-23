-- generated_from: manifest_drop_llm_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_llm_fresh_syntax_b3243bb76d71
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"model_name": "drop_llm_model_name_fresh"}
-- environment_requirements: [{"allowed_values": ["sysadmin"], "fact_refs": ["drop_llm_fact_body_8"], "key": "llm_drop_privilege"}, {"allowed_values": ["non_m"], "fact_refs": ["drop_llm_fact_body_9"], "key": "compatibility_mode"}]
-- test_sql:
DROP LLM MODEL g_drop_llm;
