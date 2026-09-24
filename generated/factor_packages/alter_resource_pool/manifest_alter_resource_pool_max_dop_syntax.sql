-- generated_from: manifest_alter_resource_pool_max_dop_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_resource_pool_max_dop_syntax_3662c1396390
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_dop_one"}
-- environment_requirements: [{"allowed_values": ["expansion_or_authoritative_contract"], "fact_refs": ["alter_resource_pool_fact_dop_centralized_conflict"], "key": "max_dop_support_context"}]
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (MAX_DOP = 1);
