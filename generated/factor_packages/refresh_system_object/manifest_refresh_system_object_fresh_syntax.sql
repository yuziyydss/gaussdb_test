-- generated_from: manifest_refresh_system_object_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_refresh_system_object_fresh_syntax_88e44a34398d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "refresh_system_object_command_fixed"}
-- environment_requirements: [{"allowed_values": ["authoritative_pre_507_upgrade"], "fact_refs": ["refresh_system_object_fact_upgrade_context"], "key": "upgrade_context"}, {"allowed_values": ["nonzero"], "fact_refs": ["refresh_system_object_fact_upgrade_mode"], "key": "upgrade_mode"}, {"allowed_values": ["initial_user"], "fact_refs": ["refresh_system_object_fact_initial_user"], "key": "executor"}]
-- test_sql:
REFRESH SYSTEM OBJECT;
