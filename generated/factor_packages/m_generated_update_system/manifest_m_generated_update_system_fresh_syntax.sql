-- generated_from: manifest_m_generated_update_system_fresh_syntax
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_generated_update_system_fresh_syntax_7ed6630fc43d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "m_generated_update_system_command_fixed"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_generated_update_system_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["authoritative_OM_upgrade"], "fact_refs": ["m_generated_update_system_fact_upgrade"], "key": "upgrade_context"}, {"allowed_values": ["true"], "fact_refs": ["m_generated_update_system_fact_initial_user"], "key": "initial_user_identity"}, {"allowed_values": ["internal_static_review_only"], "fact_refs": ["m_generated_update_system_fact_internal"], "key": "command_usage"}]
-- test_sql:
GENERATED UPDATE SYSTEM;
