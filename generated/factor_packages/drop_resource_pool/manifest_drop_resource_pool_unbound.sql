-- generated_from: manifest_drop_resource_pool_unbound
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_resource_pool_unbound_eebc2a246625
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_resource_pool_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["drop_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["false"], "fact_refs": ["drop_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
DROP RESOURCE POOL b9_pool;
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_drop_resource_pool_unbound_f53a6c2a91e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_resource_pool_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["drop_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["drop_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["false"], "fact_refs": ["drop_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
DROP RESOURCE POOL IF EXISTS b9_pool;
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;
