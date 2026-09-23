-- generated_from: manifest_generated_update_system_object_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_generated_update_system_object_fresh_syntax_c3234a39d38c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "generated_update_system_object_command_fixed"}
-- environment_requirements: [{"allowed_values": ["authoritative_OM_upgrade"], "fact_refs": ["generated_update_system_object_fact_upgrade_context"], "key": "upgrade_context"}, {"allowed_values": ["true"], "fact_refs": ["generated_update_system_object_fact_initial_user"], "key": "initial_user_identity"}]
-- test_sql:
GENERATED UPDATE SYSTEM OBJECT;
