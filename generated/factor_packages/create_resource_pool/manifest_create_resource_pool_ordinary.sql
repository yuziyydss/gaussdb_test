-- generated_from: manifest_create_resource_pool_ordinary
-- static_only: true
-- case_count: 11

-- case_id: manifest_create_resource_pool_ordinary_683feff66df7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_default"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool;
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_c056564ccfa5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_high"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (CONTROL_GROUP = 'High');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_513a2162d405
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_medium"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (CONTROL_GROUP = 'Medium');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_d523d923fb98
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_mem_zero"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (MEM_PERCENT = 0);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_983ead2465f8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_mem_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (MEM_PERCENT = 1);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_d88252fdfb78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_mem_max"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (MEM_PERCENT = 100);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_2c7a58ab52b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_active_unlimited"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (ACTIVE_STATEMENTS = -1);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_6093a17f46d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_active_disabled"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (ACTIVE_STATEMENTS = 0);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_abddb1374f5e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_active_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (ACTIVE_STATEMENTS = 1);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_34150e26416d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_memory"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (MEMORY_LIMIT = '1MB');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_create_resource_pool_ordinary_26fce8f3d284
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "create_resource_pool_options_precedence"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["create_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["High,Medium"], "fact_refs": ["create_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
SELECT 1 / (1 - COUNT(*)) AS assert_pool_absent FROM pg_resource_pool WHERE respool_name = 'b9_pool';
-- test_sql:
CREATE RESOURCE POOL b9_pool WITH (MEM_PERCENT = 1, MEMORY_LIMIT = '1MB');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;
