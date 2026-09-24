-- generated_from: manifest_create_resource_pool_max_dop_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_resource_pool_max_dop_syntax_33bf2ddbb299
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_dop_one"}
-- environment_requirements: [{"allowed_values": ["expansion_or_authoritative_contract"], "fact_refs": ["create_resource_pool_fact_dop_centralized_conflict"], "key": "max_dop_support_context"}]
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (MAX_DOP = 1);
