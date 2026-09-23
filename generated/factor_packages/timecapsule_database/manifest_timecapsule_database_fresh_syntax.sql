-- generated_from: manifest_timecapsule_database_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_timecapsule_database_fresh_syntax_5dd315208023
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"database_name": "timecapsule_database_database_name_fresh", "rename": "timecapsule_database_rename_none"}
-- environment_requirements: [{"allowed_values": ["admin_or_target_create_privilege"], "fact_refs": ["timecapsule_database_fact_body_43"], "key": "database_recovery_privilege"}]
-- test_sql:
TIMECAPSULE DATABASE g_timecapsule_database TO BEFORE DROP;
