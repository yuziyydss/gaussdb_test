-- generated_from: manifest_create_llm_fresh_syntax
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_llm_fresh_syntax_e51a95a974bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"model_kind": "create_llm_model_kind_query", "model_name": "create_llm_model_name_fresh", "options": "create_llm_options_static"}
-- environment_requirements: [{"allowed_values": ["sysadmin"], "fact_refs": ["create_llm_fact_body_9"], "key": "actor_authority"}]
-- test_sql:
CREATE LLM QUERY MODEL g_create_llm USING (MODEL = 'static-syntax-model', URL = 'https://llm-static-syntax.invalid/path/to/api', API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789');

-- case_id: manifest_create_llm_fresh_syntax_211ee51c5b32
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"model_kind": "create_llm_model_kind_embed", "model_name": "create_llm_model_name_fresh", "options": "create_llm_options_static"}
-- environment_requirements: [{"allowed_values": ["sysadmin"], "fact_refs": ["create_llm_fact_body_9"], "key": "actor_authority"}]
-- test_sql:
CREATE LLM EMBED MODEL g_create_llm USING (MODEL = 'static-syntax-model', URL = 'https://llm-static-syntax.invalid/path/to/api', API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789');

-- case_id: manifest_create_llm_fresh_syntax_321a1af61ca9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"model_kind": "create_llm_model_kind_rerank", "model_name": "create_llm_model_name_fresh", "options": "create_llm_options_static"}
-- environment_requirements: [{"allowed_values": ["sysadmin"], "fact_refs": ["create_llm_fact_body_9"], "key": "actor_authority"}]
-- test_sql:
CREATE LLM RERANK MODEL g_create_llm USING (MODEL = 'static-syntax-model', URL = 'https://llm-static-syntax.invalid/path/to/api', API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789');
