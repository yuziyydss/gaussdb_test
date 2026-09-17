-- generated_from: manifest_alter_resource_pool_ordinary
-- static_only: true
-- case_count: 10

-- case_id: manifest_alter_resource_pool_ordinary_27d0d42e271d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_high"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (CONTROL_GROUP = 'High');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_844b50a4cd22
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_medium"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (CONTROL_GROUP = 'Medium');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_541a13e6739e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_memory_zero"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (MEM_PERCENT = 0);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_0ff92f6a17d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_memory_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (MEM_PERCENT = 1);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_e26dfc76cf39
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_active_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (ACTIVE_STATEMENTS = 1);
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_3a366680f7a3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_io_priority_low"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (IO_PRIORITY = 'Low');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_3a96878ec9bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_io_priority_medium"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (IO_PRIORITY = 'Medium');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_3fba4ba53810
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_io_priority_high"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (IO_PRIORITY = 'High');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_5a1076e42b88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_io_priority_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (IO_PRIORITY = 'None');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;

-- case_id: manifest_alter_resource_pool_ordinary_01a5c190f31f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"options": "alter_resource_pool_options_combined"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_pool_fact_privilege"], "key": "resource_pool_admin"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_upgrade"], "key": "upgrade_in_progress"}, {"allowed_values": ["false"], "fact_refs": ["alter_resource_pool_fact_no_multitenant"], "key": "multitenant"}, {"allowed_values": ["complex_jobs_only"], "fact_refs": ["alter_resource_pool_fact_complex_jobs"], "key": "io_control_scope"}, {"allowed_values": ["High,Medium"], "fact_refs": ["alter_resource_pool_fact_timeshare"], "key": "default_timeshare_groups_available"}]
-- fixture_setup:
CREATE RESOURCE POOL b9_pool;
-- test_sql:
ALTER RESOURCE POOL b9_pool WITH (MEM_PERCENT = 1, MEMORY_LIMIT = '1MB');
-- fixture_teardown:
DROP RESOURCE POOL IF EXISTS b9_pool;
