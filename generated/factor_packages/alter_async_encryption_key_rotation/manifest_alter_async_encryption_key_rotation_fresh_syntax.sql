-- generated_from: manifest_alter_async_encryption_key_rotation_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_async_encryption_key_rotation_fresh_syntax_f561f8739c2c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"command": "alter_async_encryption_key_rotation_command_fixed"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_async_encryption_key_rotation_fact_switches"], "key": "tde_enabled"}, {"allowed_values": ["true"], "fact_refs": ["alter_async_encryption_key_rotation_fact_switches"], "key": "tde_async_encryption_enabled"}, {"allowed_values": ["sysadmin"], "fact_refs": ["alter_async_encryption_key_rotation_fact_privilege"], "key": "actor_authority"}, {"allowed_values": ["not_M"], "fact_refs": ["alter_async_encryption_key_rotation_fact_no_m"], "key": "compatibility_mode"}]
-- test_sql:
ALTER ASYNC ENCRYPTION KEY ROTATION;
